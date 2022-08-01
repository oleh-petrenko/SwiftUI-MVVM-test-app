//
//  User.swift
//  RaiffeisenTest
//
//  Created by Oleh Petrenko on 01.08.2022.
//

import Foundation

struct User: Codable, Identifiable {
    
    static let testUser = User(id: 12345,
                               login: "oleh-petrenko",
                               avatarUrl: URL(string: "https://avatars.githubusercontent.com/u/61108042?v=4")!,
                               reposUrl: URL(string: "https://api.github.com/users/oleh-petrenko/repos")!)
    
    let id: Int
    let login: String
    let avatarUrl: URL
    let reposUrl: URL
    
    private enum CodingKeys: String, CodingKey {
        
        case id
        case login
        case avatarUrl = "avatar_url"
        case reposUrl = "repos_url"
        
    }
    
}
