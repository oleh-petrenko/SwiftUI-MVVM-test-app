//
//  DataBaseService.swift

import Foundation

protocol Stored {
    
    //Primary key for an object
    static var primaryKey: String? { get }
    
    //Primary value for an instance
    var valueOfPrimaryKey: CustomStringConvertible? { get }
    
}

extension Stored {
    
    static var primaryKey: String? { return nil }
    static var valueOfPrimaryKey: CVarArg? { return nil }
    
}

typealias DBOperationResult = (objects: [Stored]?, error: Error?)
typealias DBOperationCompletion = (DBOperationResult) -> Void

protocol DataBaseService {
    
    // MARK: - Sync methods
    
    @discardableResult
    func createOrUpdate<T: Stored>(_ objects: [T]) -> DBOperationResult
    
    func read<T>(_ request: FetchRequest<T>) -> DBOperationResult
    
    @discardableResult
    func delete<T: Stored>(_ objects: [T]) -> DBOperationResult
    
    // MARK: - Async methods
    
    func asyncCreateOrUpdate<T: Stored>(_ objects: [T], completion: @escaping DBOperationCompletion)
    func asyncRead<T>(_ request: FetchRequest<T>, completion: @escaping DBOperationCompletion)
    func asyncDelete<T: Stored>(_ objects: [T], completion: @escaping DBOperationCompletion)
    
    // MARK: - Drop data base
    
    func dropDataBaseIfExists() -> Error?
    
}

extension DataBaseService {
    
    func findFirst<T: Stored>(_ type: T.Type, primaryValue: String, predicate: NSPredicate? = nil) -> Stored? {
        guard let primaryKey = type.primaryKey else {
            return nil
        }
        
        let primaryKeyPredicate = NSPredicate(format: "\(primaryKey) == %@", primaryValue)
        var fetchPredicate: NSPredicate
        if let predicate = predicate {
            fetchPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [primaryKeyPredicate, predicate])
        } else {
            fetchPredicate = primaryKeyPredicate
        }
        
        let request = FetchRequest<T>(predicate: fetchPredicate, fetchLimit: 1)
        
        return read(request).objects?.first
    }
    
    func fetchAll<T: Stored>(_ type: T.Type) -> DBOperationResult {        
        return read(FetchRequest<T>())
    }
    
}
