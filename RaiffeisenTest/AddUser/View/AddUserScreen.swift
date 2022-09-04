//
//  AddUserScreen.swift
//  RaiffeisenTest
//
//  Created by Oleh Petrenko on 01.08.2022.
//

import SwiftUI

struct AddUserScreen: View {
    
    private struct Constants {
        
        static let title = "Add user"
        static let placeholder = "Login"
        static let saveButtonTitle = "Try to save"
        
    }
    
    @EnvironmentObject var numberOfCachedUsersModel: NumberOfCachedUsersModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var addUserScreenViewModel: AddUserScreenViewModel
    
    @State private var login = ""
    @State private var prompt = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                TextField(Constants.placeholder, text: $login)
                    .autocapitalization(.none)
            }.padding(8)
                .background(Color(UIColor.secondarySystemBackground))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
            Text(addUserScreenViewModel.validationError)
                .font(.caption)
                .foregroundColor(.red)
        }.padding(8)
        
        Spacer()
        Button(action: {
            let isValid = addUserScreenViewModel.validate(login)
            if isValid {
                self.hideKeyboard()
                self.presentationMode.wrappedValue.dismiss()
                self.addUserScreenViewModel.loadUserInfo(endpoint: login)
            }
        }) {
            Text("\(Constants.saveButtonTitle) \(numberOfCachedUsersModel.numberOfCachedUsers + 1) user")
                .foregroundColor(.white)
                .frame(width: 200, height: 40)
                .background(Color.green)
                .cornerRadius(15)
                .padding()
        }
        .navigationTitle(Constants.title).navigationBarTitleDisplayMode(.inline)
    }
    
}

//struct AddUserScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        AddUserScreen(addUserScreenViewModel: AddUserScreenViewModel(), userNetwork: UserListViewModel())
//    }
//}

extension View {
    
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
    
}
