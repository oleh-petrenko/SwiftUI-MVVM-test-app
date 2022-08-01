//
//  UserDetailList.swift
//  RaiffeisenTest
//
//  Created by Oleh Petrenko on 01.08.2022.
//

import SwiftUI

//struct UserDetailList: View {
//
//    private struct Constants {
//
//        static let title = "GitHub public repos"
//
//    }
//
//    @ObservedObject var userDetailListViewModel: UserDetailListViewModel
//
//    var body: some View {
//        List(userDetailListViewModel.userPublicRepositories) { repository in
//            Link(destination: repository.url, label: {
//                Text(repository.url.lastPathComponent)
//            })
//        }
//        .navigationTitle(Constants.title)
//        .onAppear {
//            userDetailListViewModel.getPublicRepositories()
//        }
//    }
//
//}

struct UserDetailList: View {
    
    private struct Constants {
        
        static let title = "GitHub public repos"
        
    }
    
    @ObservedObject var userDetailListViewModel: UserDetailListViewModel
    
    var body: some View {
        ZStack {
            switch userDetailListViewModel.state {
            case .initial: EmptyView()
            case .loading: Text("Loading...")
            case .error: Text("Error has occured while loading User repositories")
            case .loaded:
                List(userDetailListViewModel.userPublicRepositories) { repository in
                    Link(destination: repository.url, label: {
                        Text(repository.url.lastPathComponent)
                    })
                }
                .navigationTitle(Constants.title)
            }
        }.task {
            await userDetailListViewModel.getPublicRepositories()
        }
    }
    
}

struct UserDetailList_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailList(userDetailListViewModel: UserDetailListViewModel(user: User.testUser))
    }
}
