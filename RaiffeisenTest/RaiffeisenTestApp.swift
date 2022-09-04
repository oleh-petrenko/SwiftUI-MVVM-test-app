//
//  RaiffeisenTestApp.swift
//  RaiffeisenTest
//
//  Created by Oleh Petrenko on 01.08.2022.
//

import SwiftUI
import Combine

final class NumberOfCachedUsersModel: ObservableObject {
    
    private let localUserRepository: LocalUserRepository
    
    init(localUserRepository: LocalUserRepository) {
        self.localUserRepository = localUserRepository
    }
    
    var numberOfCachedUsers: Int {
        localUserRepository.numberOfCachedUsers
    }
    
}

@main
struct RaiffeisenTestApp: App {
    
    @StateObject var userListViewModel = UserListViewModel()
    
    var body: some Scene {
        WindowGroup {
            UserList(userListViewModel: userListViewModel)
                .environmentObject(NumberOfCachedUsersModel(localUserRepository: userListViewModel))
        }
    }
}
