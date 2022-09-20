//
//  UserRepository.swift
//  RaiffeisenTest
//
//  Created by Oleh Petrenko on 20.09.2022.
//

import Foundation

protocol UserRepository {
    
    func fetchUsers() -> [User]
    func saveUsers(_ users: [User])
    func deleteUsers(_ users: [User])
    
}

final class UserRepositoryService: UserRepository {
    
    private let dbService: CoreDataDBService
    
    init(dbService: CoreDataDBService) {
        self.dbService = dbService
    }
    
    func fetchUsers() -> [User] {
        let fetchRequest = FetchRequest<User>()
        let users = dbService.read(fetchRequest).objects as? [User]
        
        return users ?? []
    }
    
    func saveUsers(_ users: [User]) {
        guard let currentUsers = dbService.read(FetchRequest<User>()).objects as? [User] else { return }
        
        var newUsers = currentUsers
        newUsers.append(contentsOf: users)
        
        dbService.delete(currentUsers)
        dbService.createOrUpdate(newUsers)
    }
 
    func deleteUsers(_ users: [User]) {
        guard let currentUsers = dbService.read(FetchRequest<User>()).objects as? [User] else { return }
        
        var newUsers = currentUsers
        users.forEach { user in
            if let index = newUsers.firstIndex(where: { $0.id == user.id }) {
                newUsers.remove(at: index)
            }
        }
        
        dbService.delete(currentUsers)
        dbService.createOrUpdate(newUsers)
    }
    
}
