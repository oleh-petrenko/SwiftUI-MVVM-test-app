//
//  User+CoreDataClass.swift
//  RaiffeisenTest
//
//  Created by Oleh Petrenko on 20.09.2022.
//
//

import Foundation
import CoreData

@objc(User)
public class UserManagedObject: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserManagedObject> {
        return NSFetchRequest<UserManagedObject>(entityName: "User")
    }
    
    @NSManaged public var id: Double
    @NSManaged public var login: String?
    @NSManaged public var avatarUrl: URL?
    @NSManaged public var reposUrl: URL?
    
}
