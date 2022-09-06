//
//  NetworkCommonProtocols.swift
//  RaiffeisenTest
//
//  Created by Oleh Petrenko on 05.09.2022.
//

import Foundation

enum HTTPMethod: String {
    case get, post, delete, patch, put
}

enum ParameterEncoding {
    case URL, JSON
}

typealias JSON = [String: Any]

/// A dictionary of parameters to apply to a `URLRequest`.
public typealias Parameters = [String: Any]



/// A dictionary of headers to apply to a `URLRequest`.
public typealias HTTPHeaders = [String: String]

public protocol NetworkRequestAdditionalParametersProviding {

    var parameters: Parameters { get }
    
}

public protocol NetworkRequestAdditionalURLParametersProviding {
    
    var parameters: Parameters { get }
    
}

public protocol NetworkRequestAdditionalHeadersProviding {
    
    var headers: HTTPHeaders { get }
    
}
