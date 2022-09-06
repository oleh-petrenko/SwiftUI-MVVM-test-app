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
            List(userListViewModel.users) { user in
                NavigationLink(destination: UserDetailList(userDetailListViewModel: UserDetailListViewModel(user: user)), label: { UserRow(user: user) })
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
        }.onAppear { //TODO: testing HttpClient. Remove later
//            Task {
//                let httpClient = HttpClient(baseURL: postURL, requestExecutor: NetworkRequestExecutor())
//                let result = await httpClient.executeRequest(endpoint: nil, method: .post, parameters: ["1": 1, "2": 2], headers: ["Accept": "application/json"])
//
//                switch result {
//                case .success(let response):
//                    print(response.responseDictionary)
//                case .failure(let networkRequestError):
//                    switch networkRequestError {
//                    case .invalidURL(_, let urlString):
//                        print(urlString)
//                    case .failed(let response):
//                        let data = response.responseData
//                        print(data)
//                    }
//                }
//            }
        }
    }
    
}

//struct UserList_Previews: PreviewProvider {
//    static var previews: some View {
//        UserList()
//    }
//}
