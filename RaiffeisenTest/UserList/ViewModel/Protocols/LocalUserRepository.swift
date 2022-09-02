//
//  LocalUserRepository.swift
//  RaiffeisenTest
//
//  Created by Oleh Petrenko on 01.08.2022.
//

import Foundation

protocol LocalUserRepository {
    
    func saveUsersToUserDefaults(_ users: [User])
    func fetchUsersFromUserDefaults() -> [User]
    
}
