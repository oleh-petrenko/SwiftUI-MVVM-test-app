//
//  AddUserScreenViewModel.swift
//  RaiffeisenTest
//
//  Created by Oleh Petrenko on 01.08.2022.
//

import Foundation
import SwiftUI

final class AddUserScreenViewModel: ObservableObject {
    
    private struct Constants {
        
        static let errorText = "Wrong field value! Rules: min 3 characters, avoid using !@#$%^&*"
        
    }
    
    @Published private(set) var validationError: String = ""
    
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
    
}
