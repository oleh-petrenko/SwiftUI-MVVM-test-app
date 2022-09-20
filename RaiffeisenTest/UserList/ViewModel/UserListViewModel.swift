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

    @AppStorage(Constants.usersKey) var cachedUsers: Data?
    @Published var users: [User] = []
    
    lazy private(set) var addUserScreenViewModel: AddUserScreenViewModel = {
        let addUserScreenViewModel = AddUserScreenViewModel()
        let cancellable = addUserScreenViewModel.publisher.sink(receiveValue: { user in
            self.saveAndAddNewUser(user)
        })
        cancellables.append(cancellable)
        
        return addUserScreenViewModel
    }()
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        self.users = fetchUsersFromDB()//fetchUsersFromUserDefaults()
    }

    private var cancellables: [AnyCancellable] = []
    
    private func saveAndAddNewUser(_ user: User) {
        users.append(user)
//        saveUsersToUserDefaults(users)
        saveUserToDB(user)
    }
    
    func deleteUser(at offset: IndexSet) {
        guard let index = offset.first else { return }
        
        let user = users[index]
        deleteUserFromDB(user)
        users.remove(at: index)
    }
    
    //MARK: - Data Base flow
    
    private func fetchUsersFromDB() -> [User] {
        return userRepository.fetchUsers()
    }
    
    private func saveUserToDB(_ user: User) {
        let newUsers = [user]
        userRepository.saveUsers(newUsers)
    }
    
    private func deleteUserFromDB(_ user: User) {
        let newUsers = [user]
        userRepository.deleteUsers(newUsers)
    }
    
}

extension UserListViewModel: LocalUserRepository {
    
    func saveUsersToUserDefaults(_ users: [User]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(users)
            
            cachedUsers = data
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func fetchUsersFromUserDefaults() -> [User] {
        if let userData = cachedUsers {
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
    
    var numberOfCachedUsers: Int {
        users.count
    }
    
}
