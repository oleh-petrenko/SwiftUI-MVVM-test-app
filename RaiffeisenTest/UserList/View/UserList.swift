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
    
    @State var showAddUserScreen = false
    
    var body: some View {
        NavigationView {
            List(userListViewModel.users) { user in
                ZStack(alignment: .leading) {
                    NavigationLink(destination: UserDetailList(userDetailListViewModel: UserDetailListViewModel(user: user)), label: { Text("") })
                    UserRow(user: user)
                }
            }
            .navigationTitle(Constants.title)
            .toolbar {
                ZStack {
                    NavigationLink(isActive: $showAddUserScreen, destination: {
                        AddUserScreen(addUserScreenViewModel: AddUserScreenViewModel(), userNetwork: userListViewModel)
                    }, label: {
                        Text("")
                    })
                    Button {
                        showAddUserScreen = true
                    } label: {
                        Image(systemName: Constants.addUserButtonImageString)
                            .renderingMode(.original)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
    
}

struct UserList_Previews: PreviewProvider {
    static var previews: some View {
        UserList()
    }
}
