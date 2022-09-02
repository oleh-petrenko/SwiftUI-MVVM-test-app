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

    func loadUserInfo(endpoint: String) {
        let urlString = "\(Constants.baseUrlString)\(endpoint)"
        
        guard let url = URL(string: urlString) else {
            fatalError("Missing URL")
        }
        
        let urlRequest = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode == 200 {
                guard let data = data else { return }
                
                DispatchQueue.main.async {
                    do {
                        let decoder = JSONDecoder()
//                        decoder.keyDecodingStrategy = .convertFromSnakeCase //Пробовал такую штуку - чего-то не завелось
                        let decodedUser = try decoder.decode(User.self, from: data)
                        self.publisher.send(decodedUser)
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }

        dataTask.resume()
    }
    
}
