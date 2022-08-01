//
//  UserList.swift
//  RaiffeisenTest
//
//  Created by Oleh Petrenko on 01.08.2022.
//

import SwiftUI

struct UserList: View {
    
    private struct Constants {
        
        static let title = "Users"
        static let addUserButtonImageString = "person.crop.circle.fill.badge.plus"
        
    }
    
    @ObservedObject var userListViewModel: UserListViewModel
    
    init() {
        self.userListViewModel = UserListViewModel()
    }
        
    var body: some View {
        NavigationView {
            List(userListViewModel.users) { user in
                NavigationLink(destination: UserDetailList(userDetailListViewModel: UserDetailListViewModel(user: user)), label: { UserRow(user: user) })
            }
            .navigationTitle(Constants.title)
            .toolbar {
                NavigationLink(destination: {
                    AddUserScreen(addUserScreenViewModel: AddUserScreenViewModel(), userNetwork: userListViewModel)
                }, label: {
                    Image(systemName: Constants.addUserButtonImageString)
                        .renderingMode(.original)
                        .foregroundColor(.blue)
                })
            }
        }
    }
    
}

struct UserList_Previews: PreviewProvider {
    static var previews: some View {
        UserList()
    }
}
