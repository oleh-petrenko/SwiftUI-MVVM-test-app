//
//  CoreDataModelConvertible.swift

import CoreData

protocol CoreDataModelConvertible: Stored, NSManagedObjectToStoredMapping, StoredToNSManagedObjectMapping {}

protocol NSManagedObjectToStoredMapping {
    
    static func mapToStored(fromManagedObject managedObject: NSManagedObject) -> Stored
    static func managedObjectClass() -> NSManagedObject.Type
    
}

protocol StoredToNSManagedObjectMapping {
    
    static var entityName: String { get }
    
    @discardableResult
    func mapToNSManagedObject(withManagedObject managedObject: NSManagedObject) -> NSManagedObject
    
}
