//
//  LocalUserRepository.swift
//  RaiffeisenTest
//
//  Created by Oleh Petrenko on 01.08.2022.
//

import Foundation

protocol LocalUserRepository {
    
    func saveUsers(_ users: [User])
    func fetchUsers() -> [User]
    
}
