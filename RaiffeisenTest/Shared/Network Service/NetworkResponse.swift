//
//  NetworkResponse.swift
//  RaiffeisenTest
//
//  Created by Oleh Petrenko on 06.09.2022.
//

import Foundation

struct NetworkResponse {
    
    let responseData: Data?
    let httpStatusCode: Int?
    let error: Error?
    
    init(responseData: Data?, httpStatusCode: Int?, error: Error?) {
        self.responseData = responseData
        self.httpStatusCode = httpStatusCode
        self.error = error
    }
    
}

extension NetworkResponse {
    
    var responseDictionary: JSON? {
        guard let responseData = responseData,
                let json = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String : Any] else { return nil }
        
        return json
    }
    
    func parse<T: Decodable>(toType type: T.Type) -> T? {
        guard let responseData = responseData else { return nil }
        return try? JSONDecoder().decode(type, from: responseData)
    }
    
}
