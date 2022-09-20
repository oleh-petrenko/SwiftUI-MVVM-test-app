//
//  CoreDataDBService.swift

import Foundation
import CoreData

final class CoreDataDBService {
    
    private var modelName: String
//    private var storeDirectory: URL
    
//    init(forModel modelName: String, storeDirectory: URL) {
//        self.modelName = modelName
//        self.storeDirectory = storeDirectory
//    }
    
    init(forModel modelName: String) {
        self.modelName = modelName
//        self.storeDirectory = storeDirectory
    }
    
    // MARK: - CoreData stack
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        
//        let description = NSPersistentStoreDescription(url: self.storeDirectory)
//        container.persistentStoreDescriptions = [description]
        
        //loadPersistentStores completion handler is called sync
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })

        return container
    }()
    
    // MARK: - Private methods
    
    private func fetchRequest(for entity: CoreDataModelConvertible.Type) -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest(entityName: entity.entityName)
    }
    
    private func save(_ context: NSManagedObjectContext) -> Error? {
        do {
            if context.hasPersistentStore {
                try context.save()
            }
            return nil
        } catch let error {
            return error
        }
    }
    
}

// MARK: - Private methods

extension CoreDataDBService {
    
    private func createOrUpdate<T: Stored>(_ context: NSManagedObjectContext, objects: [T]) -> DBOperationResult {
        for object in objects {
            if let coreDataConvertibleObject = object as? CoreDataModelConvertible {
                var managedObject: NSManagedObject
                let type = Swift.type(of: coreDataConvertibleObject)
                if let existingManagedObject = findManagedObject(context, type: type, primaryValue: object.valueOfPrimaryKey!.description) {
                    managedObject = existingManagedObject
                } else {
                    managedObject = NSEntityDescription.insertNewObject(forEntityName: type.entityName, into: context)
                }
                
                coreDataConvertibleObject.mapToNSManagedObject(withManagedObject: managedObject)
            }
        }
        
        if let error = self.save(context) {
            return (nil, error)
        }
        
        return (objects, nil)
    }
    
    private func read<T>(_ context: NSManagedObjectContext, coreDataModelType: CoreDataModelConvertible.Type, request: FetchRequest<T>) -> DBOperationResult {
        let fetchRequest = self.fetchRequest(for: coreDataModelType)
        fetchRequest.predicate = request.predicate
        fetchRequest.sortDescriptors = [request.sortDescriptor].compactMap { $0 }
        fetchRequest.fetchLimit = request.fetchLimit
        fetchRequest.fetchOffset = request.fetchOffset
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            let objects = result.compactMap { coreDataModelType.mapToStored(fromManagedObject: $0) as? T }
            return (objects, nil)
        } catch let error {
            return (nil, error)
        }
    }
    
    private func delete<T: Stored>(_ context: NSManagedObjectContext, objects: [T]) -> DBOperationResult {
        for object in objects {
            if let coreDataConvertibleObject = object as? CoreDataModelConvertible {
                let type = Swift.type(of: coreDataConvertibleObject)
                if let manageObject = findManagedObject(context, type: type, primaryValue: String(describing: object.valueOfPrimaryKey!)) {
                    context.delete(manageObject)
                }
            }
        }
        
        if let error = self.save(context) {
            return (nil, error)
        }
        
        return (objects, nil)
    }
    
    private func findManagedObject(_ context: NSManagedObjectContext, type: CoreDataModelConvertible.Type, primaryValue: String) -> NSManagedObject? {
        guard let primaryKey = type.primaryKey else {
            return nil
        }
        
        let primaryKeyPredicate = NSPredicate(format: "\(primaryKey) == %@", primaryValue) // primary key in managed objects should be equal to primaryValue
        let fetchRequest = self.fetchRequest(for: type)
        fetchRequest.predicate = primaryKeyPredicate
        let result = try? context.fetch(fetchRequest) as? [NSManagedObject]
        
        return result?.first
    }
    
}



extension CoreDataDBService: DataBaseService {
    
    // MARK: - Sync operations
    
    @discardableResult
    func createOrUpdate<T: Stored>(_ objects: [T]) -> DBOperationResult {
        let context = persistentContainer.newBackgroundContext()
        
        return createOrUpdate(context, objects: objects)
    }
    
    func read<T>(_ request: FetchRequest<T>) -> DBOperationResult {
        guard let coreDataModelType = T.self as? CoreDataModelConvertible.Type else {
            fatalError("CoreDataDBClient can manage only types which conform to CoreDataModelConvertible")
        }
        
        let context = persistentContainer.newBackgroundContext()
        
        return read(context, coreDataModelType: coreDataModelType, request: request)
    }
    
    
    @discardableResult
    func delete<T: Stored>(_ objects: [T]) -> DBOperationResult {
        let context = persistentContainer.newBackgroundContext()
                
        return delete(context, objects: objects)
    }
    
    // MARK: - Async operations
    
    func asyncCreateOrUpdate<T: Stored>(_ objects: [T], completion: @escaping DBOperationCompletion) {
        persistentContainer.performBackgroundTask { context in
            let retValue = self.createOrUpdate(context, objects: objects)
            completion(retValue)
        }
    }
    
    func asyncRead<T>(_ request: FetchRequest<T>, completion: @escaping DBOperationCompletion) {
        guard let coreDataModelType = T.self as? CoreDataModelConvertible.Type else {
            fatalError("CoreDataDBClient can manage only types which conform to CoreDataModelConvertible")
        }
        
        persistentContainer.performBackgroundTask { context in
            let retValue = self.read(context, coreDataModelType: coreDataModelType, request: request)
            completion(retValue)
        }
    }
    
    func asyncDelete<T: Stored>(_ objects: [T], completion: @escaping DBOperationCompletion){
        persistentContainer.performBackgroundTask { context in
            let retValue = self.delete(context, objects: objects)
            completion(retValue)
        }
    }
    
    // MARK: - Drop data base
    
    func dropDataBaseIfExists() -> Error? {
        for store in persistentContainer.persistentStoreCoordinator.persistentStores {
            guard let storeURL = store.url else { continue }
            
            do {
                try persistentContainer.persistentStoreCoordinator.destroyPersistentStore(at: storeURL, ofType: NSSQLiteStoreType, options: store.options)
                
                return nil
            } catch let error {
                return error
            }
        }
        
        return nil
    }
    
}

extension NSManagedObjectContext {
    
    var hasPersistentStore: Bool {
        guard let persistentStoreCoordinator = persistentStoreCoordinator else { return false }
        return persistentStoreCoordinator.persistentStores.first != nil
    }
    
}
