//
//  UserListViewModel.swift
//  RaiffeisenTest
//
//  Created by Oleh Petrenko on 01.08.2022.
//

import Foundation
import SwiftUI

private struct Constants {
    
    static let baseUrlString = "https://api.github.com/users/"
    static let usersKey = "Users"
    
}



final class UserListViewModel: ObservableObject {

    @Published var users: [User] = []

    init() {
        users = fetchUsers()
    }

}

extension UserListViewModel: UserNetwork {
    
    func loadUserInfo(endpoint: String) {
        let urlString = "\(Constants.baseUrlString)\(endpoint)"
        
        guard let url = URL(string: urlString) else {
            fatalError("Missing URL")
        }

        
        let urlRequest = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode == 200 {
                guard let data = data else { return }
                
                DispatchQueue.main.async {
                    do {
                        let decoder = JSONDecoder()
//                        decoder.keyDecodingStrategy = .convertFromSnakeCase //Пробовал такую штуку - чего-то не завелось
                        let decodedUser = try decoder.decode(User.self, from: data)
                        self.users.append(decodedUser)
                        self.saveUsers(self.users)
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }

        dataTask.resume()
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
