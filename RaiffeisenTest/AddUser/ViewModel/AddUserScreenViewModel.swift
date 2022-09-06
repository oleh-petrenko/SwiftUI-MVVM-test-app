//
//  AddUserScreenViewModel.swift
//  RaiffeisenTest
//
//  Created by Oleh Petrenko on 01.08.2022.
//

import Foundation
import SwiftUI
import Combine

final class AddUserScreenViewModel: ObservableObject {
    
    private struct Constants {
        
        static let errorText = "Wrong field value! Rules: min 3 characters, avoid using !@#$%^&*"
        static let baseUrlString = "https://api.github.com/users/"
        
    }
    
    @Published private(set) var validationError: String = ""
    
    lazy private(set) var publisher = PassthroughSubject<User, Never>()
    
    func validate(_ value: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[0-9a-zA-Z\\_-]{3,}$", options: .caseInsensitive)
            if regex.matches(in: value, options: [], range: NSMakeRange(0, value.count)).count > 0 {
                validationError = ""
                
                return true
            }
        }
        catch {
            print("Reg Exp validation error --> ", error.localizedDescription)
        }
        
        validationError = Constants.errorText
        
        return false
    }
    
    func loadUserInfo(endpoint: String) async {
        let urlString = "\(Constants.baseUrlString)\(endpoint)"

        guard let url = URL(string: urlString) else {
            fatalError("Missing URL")
        }

        let executor = NetworkRequestExecutor()
        let result = await executor.executeRequest(url, method: .get, encoding: ParameterEncoding.URL)

        switch result {
        case .success(let response):
            DispatchQueue.main.async {
                if let user = response.parse(toType: User.self) { //TODO: do not parse in main thread. Fix later
                    self.publisher.send(user)
                } else {
                    print("`responseData` is nil")
                }
            }
        case .failure(let error):
            print("Error decoding: ", error)
        }
    }
    
}
