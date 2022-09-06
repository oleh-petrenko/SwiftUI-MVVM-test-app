//
//  TestNetworking.swift
//  RaiffeisenTest
//
//  Created by Oleh Petrenko on 06.09.2022.
//

import Foundation
import Alamofire

let method = HTTPMethod.get
let getURL = URL(string: "https://httpbin.org/json")!
let postURL = URL(string: "https://httpbin.org/post")!

final class TestNetworking {
    
    let networkRequestExecutor = NetworkRequestExecutor()
    
    func getRequest() async -> Result<NetworkResponse, NetworkRequestError> {
        return await networkRequestExecutor.executeRequest(URL(string: "https://httpbin.org/json")!, method: .get, encoding: ParameterEncoding.URL, headers: ["Accept": "application/json"])
    }
    
}

struct SlideshowModel: Codable {
    
    let slideshow: Slideshow
 
    struct Slideshow: Codable {
        
        let author: String
        let date: String
        let slides: [Slide]
        let title: String
        
    }

    struct Slide: Codable {
        
        let title: String
        let type: String
        
    }
    
}

