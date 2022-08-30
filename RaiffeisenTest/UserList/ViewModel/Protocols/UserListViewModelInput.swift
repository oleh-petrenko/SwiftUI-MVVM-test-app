//
//  UserListViewModelInput.swift
//  RaiffeisenTest
//
//  Created by Oleh Petrenko on 30.08.2022.
//

import Foundation

protocol UserListViewModelInput: AnyObject {
    
    func saveAndAddNewUser(_ user: User)
    
}
