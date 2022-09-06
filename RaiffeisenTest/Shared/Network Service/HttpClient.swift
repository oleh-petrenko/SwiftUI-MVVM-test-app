////
////  HttpClient.swift
////  RaiffeisenTest
////
////  Created by Oleh Petrenko on 01.09.2022.
////
//
//import Foundation
//import Alamofire
//
//final class HttpClient {
//    
//    #if DEBUG
//        private let _printMyNetDataThread: Bool = true
//    #endif
//    
//    private let baseURL: URL
//    private let requestExecutor: NetworkRequestExecutor
//    
//    private let headerProviders: [NetworkRequestAdditionalHeadersProviding]
//    private let parameterProviders: [NetworkRequestAdditionalParametersProviding]
//    private let additionalURLParameterProviders: [NetworkRequestAdditionalURLParametersProviding]
//    private let responseAdditionalHandler: [NetworkResponseAdditionalHandler]
//    
//    private var additionalParameters: Parameters {
//        return parameterProviders.reduce([:]) { result, provider -> Parameters in
//            return result + provider.parameters
//        }
//    }
//    
//    private var additionalHeaders: HTTPHeaders {
//        return headerProviders.reduce([:], { result, provider -> HTTPHeaders in
//            return result + provider.headers
//        })
//    }
//    
//    private var additionalURLParameters: Parameters {
//        return additionalURLParameterProviders.reduce([:]) { result, provider -> Parameters in
//            return result + provider.parameters
//        }
//    }
//    
//    init(baseURL: URL,
//         requestExecutor: NetworkRequestExecutor,
//         headerProviders: [NetworkRequestAdditionalHeadersProviding] = [],
//         parameterProviders: [NetworkRequestAdditionalParametersProviding] = [],
//         additionalURLParameterProviders: [NetworkRequestAdditionalURLParametersProviding] = [],
//         responseAdditionalHandler: [NetworkResponseAdditionalHandler] = []) {
//        self.baseURL = baseURL
//        self.requestExecutor = requestExecutor
//        self.headerProviders = headerProviders
//        self.parameterProviders = parameterProviders
//        self.additionalURLParameterProviders = additionalURLParameterProviders
//        self.responseAdditionalHandler = responseAdditionalHandler
//    }
//    
//    private func makeURL(withBaseURL baseURL: URL, endpoint: String?, parameters: Parameters) -> URL? {
//        guard let endpoint = endpoint else { return baseURL }
//        
//        var url = !endpoint.isEmpty ? URL(string: baseURL.absoluteString + endpoint) : baseURL
//        
//        if !parameters.isEmpty, var path = url?.absoluteString {
//            for (index, parameter) in parameters.enumerated() {
//                path += index == 0 ? "?" : "&"
//                path += parameter.key + "=" + String(describing: parameter.value)
//            }
//            url = URL(string: path)
//        }
//        
//        return url
//    }
//    
//}
