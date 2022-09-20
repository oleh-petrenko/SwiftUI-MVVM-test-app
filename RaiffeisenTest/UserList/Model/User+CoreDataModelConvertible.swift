//
//  User+CoreDataModelConvertible.swift
//  RaiffeisenTest
//
//  Created by Oleh Petrenko on 20.09.2022.
//

import Foundation
import CoreData


extension User: CoreDataModelConvertible {
    
    static var entityName: String {
        "User"
    }
    
    static func managedObjectClass() -> NSManagedObject.Type {
        return UserManagedObject.self
    }
    
    func mapToNSManagedObject(withManagedObject managedObject: NSManagedObject) -> NSManagedObject {
        guard let userManagedObject = managedObject as? UserManagedObject else {
            fatalError("\(managedObject) is not UserManagedObject")
        }
        
        userManagedObject.id = Double(id)
        userManagedObject.login = login
        userManagedObject.avatarUrl = avatarUrl
        userManagedObject.reposUrl = reposUrl
        
        return userManagedObject
    }
    
    static func mapToStored(fromManagedObject managedObject: NSManagedObject) -> Stored {
        guard let userManagedObject = managedObject as? UserManagedObject else {
            fatalError("can't create UserModel object from object \(managedObject)")
        }
        
        //TODO: remove force unwrapping
        let id = Int(userManagedObject.id)
        let login = userManagedObject.login!
        let avatarUrl = userManagedObject.avatarUrl!
        let reposUrl = userManagedObject.reposUrl!
        
        return User(id: id, login: login, avatarUrl: avatarUrl, reposUrl: reposUrl)
    }
    
    static var primaryKey: String? {
        return "id"
    }
    
    var valueOfPrimaryKey: CustomStringConvertible? {
        return id
    }
    
}
