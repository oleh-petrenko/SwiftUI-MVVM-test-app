//
//  UserDetailListViewModel.swift
//  RaiffeisenTest
//
//  Created by Oleh Petrenko on 01.08.2022.
//

import Foundation

protocol UserPublicRepositoriesNetwork {
    
    func getPublicRepositories() async
    
}

enum UserDetailListViewModelState {
    
    case loading
    case loaded
    case error
    case initial
    
}

final class UserDetailListViewModel: ObservableObject, UserPublicRepositoriesNetwork {
    
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    private(set) var userPublicRepositories: [UserPublicRepository] = []
    @Published private(set) var state: UserDetailListViewModelState = .initial
    
    func getPublicRepositories() async {
        state = .loading
        
        let urlRequest = URLRequest(url: user.reposUrl)
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
                        
                        let userPublicRepositories = try decoder.decode([UserPublicRepository].self, from: data)
                        self.userPublicRepositories = userPublicRepositories
                        self.state = .loaded
                    } catch let error {
                        print("Error decoding: ", error)
                        self.state = .error
                    }
                }
            } else {
                self.state = .error
            }
        }

        dataTask.resume()
    }
    
}
