//
//  UserListViewModel.swift
//  RaiffeisenTest
//
//  Created by Oleh Petrenko on 01.08.2022.
//

import Foundation
import SwiftUI

private struct Constants {

    static let usersKey = "Users"

}

final class UserListViewModel: ObservableObject {

    @Published var users: [User] = []

    init() {
        users = fetchUsers()
    }

}

extension UserListViewModel: UserListViewModelInput {
    
    func saveAndAddNewUser(_ user: User) {
        users.append(user)
        saveUsers(users)
    }
    
}

extension UserListViewModel: LocalUserRepository {
    
    func saveUsers(_ users: [User]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(users)
            
            UserDefaults.standard.set(data, forKey: Constants.usersKey)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func fetchUsers() -> [User] {
        if let userData = UserDefaults.standard.data(forKey: Constants.usersKey) {
            do {
                let decoder = JSONDecoder()
                let decodedUsers = try decoder.decode([User].self, from: userData)
                                
                return decodedUsers
            } catch {
                //OP: TODO: возможно тут тоже нужно менять состояние модели. Если fetch прошел не успешно - пустой массив (initial state of list is empty (users can be added only manually)
                print(error.localizedDescription)
            }
        }
        
        return []
    }
    
}
