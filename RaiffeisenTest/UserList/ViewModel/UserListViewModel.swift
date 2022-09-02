//
//  UserListViewModel.swift
//  RaiffeisenTest
//
//  Created by Oleh Petrenko on 01.08.2022.
//

import Foundation
import SwiftUI
import Combine

private struct Constants {

    static let usersKey = "Users"

}

final class UserListViewModel: ObservableObject {

    @AppStorage(Constants.usersKey) var cahedUsers: Data?
    @Published var users: [User] = []
    
    lazy private(set) var addUserScreenViewModel: AddUserScreenViewModel = {
        let addUserScreenViewModel = AddUserScreenViewModel()
        let cancellable = addUserScreenViewModel.publisher.sink(receiveValue: { user in
            self.saveAndAddNewUser(user)
        })
        cancellables.append(cancellable)
        
        return addUserScreenViewModel
    }()
    
    init() {
        users = fetchUsersFromUserDefaults()
    }

    private var cancellables: [AnyCancellable] = []
    
    private func saveAndAddNewUser(_ user: User) {
        users.append(user)
        saveUsersToUserDefaults(users)
    }
    
}

extension UserListViewModel: LocalUserRepository {
    
    func saveUsersToUserDefaults(_ users: [User]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(users)
            
            cahedUsers = data
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func fetchUsersFromUserDefaults() -> [User] {
        if let userData = cahedUsers {
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
