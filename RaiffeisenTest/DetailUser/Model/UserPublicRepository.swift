//
//  UserPublicRepository.swift
//  RaiffeisenTest
//
//  Created by Oleh Petrenko on 01.08.2022.
//

import Foundation

struct UserPublicRepository: Decodable, Identifiable {
    
    let id: Int
    let url: URL
    
}
