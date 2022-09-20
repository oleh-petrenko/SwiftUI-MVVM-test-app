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
    
//    @Environment
//    @EnvironmentValues
//    @EnvironmentalModifier
//    @EnvironmentKey
    @EnvironmentObject var numberOfCachedUsersModel: NumberOfCachedUsersModel
    @ObservedObject var userListViewModel: UserListViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(userListViewModel.users, id: \.id) { user in
                    NavigationLink(destination: UserDetailList(userDetailListViewModel: UserDetailListViewModel(user: user)), label: { UserRow(user: user) })
                }
                .onDelete { indexSet in
                    userListViewModel.deleteUser(at: indexSet)
                }
            }
            .navigationTitle("\(Constants.title): \(numberOfCachedUsersModel.numberOfCachedUsers)")
            .toolbar {
                NavigationLink(destination: {
                    AddUserScreen(addUserScreenViewModel: userListViewModel.addUserScreenViewModel)
                }, label: {
                    Image(systemName: Constants.addUserButtonImageString)
                        .renderingMode(.original)
                        .foregroundColor(.blue)
                })
            }
        }
    }
    
}

//struct UserList_Previews: PreviewProvider {
//    static var previews: some View {
//        UserList()
//    }
//}
