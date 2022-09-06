//
//  NetworkRequestExecutor.swift
//  RaiffeisenTest
//
//  Created by Oleh Petrenko on 05.09.2022.
//

import Foundation
import Alamofire

enum NetworkRequestError: Error {
    
    case failed(NetworkResponse)
    case invalidURL(NetworkResponse?, String)
    
}

final class NetworkRequestExecutor {
    
    private lazy var sessionManager: Session = {
        //TODO: SSL pinning
        
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 30
        
        return Session(configuration: configuration)
    }()
    
    func executeRequest(_ url: URLConvertible,
                               method: HTTPMethod = .get,
                               parameters: Parameters? = nil,
                               encoding: ParameterEncoding = ParameterEncoding.JSON, //TODO: make an abstraction for this value
                               headers: HTTPHeaders? = nil) async -> Result<NetworkResponse, NetworkRequestError> {

        let alamofireMethod = httpMethodToAlamofire(method)
        let alamofireEncoding = parameterEncodingToAlamofire(encoding)
        let alamofireHeaders = httpHeadersToAlamofire(headers: headers)

        let task = sessionManager.request(url, method: alamofireMethod, parameters: parameters, encoding: alamofireEncoding, headers: alamofireHeaders).serializingData()
        let statucCode = await task.response.response?.statusCode
        
        do {
            let value = try await task.value
            let networkResponse = NetworkResponse(responseData: value, httpStatusCode: statucCode, error: nil)
            
            return .success(networkResponse)
        } catch let error {
            let value = try? await task.value
            let networkResponse = NetworkResponse(responseData: value, httpStatusCode: statucCode, error: error)
            
            return .failure(.failed(networkResponse))
        }
    }
    
}

extension NetworkRequestExecutor {
    
    private func httpMethodToAlamofire(_ httpMethod: HTTPMethod) -> Alamofire.HTTPMethod {
        switch httpMethod {
        case .get:
            return .get
        case .post:
            return .post
        case .put:
            return .put
        case .patch:
            return .patch
        case .delete:
            return .delete
        }
    }
    
    private func parameterEncodingToAlamofire(_ encoding: ParameterEncoding) -> Alamofire.ParameterEncoding {
        switch encoding {
        case .JSON:
            return Alamofire.JSONEncoding.default//Alamofire.JSONParameterEncoder.default
        case .URL:
            return Alamofire.URLEncoding.default//Alamofire.URLEncodedFormParameterEncoder.default
        }
    }
    
    private func httpHeadersToAlamofire(headers: HTTPHeaders?) -> Alamofire.HTTPHeaders? {
        guard let headers = headers else {
            return nil
        }

        return Alamofire.HTTPHeaders(headers)
    }
    
}

