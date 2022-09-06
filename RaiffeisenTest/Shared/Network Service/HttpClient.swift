//
//  HttpClient.swift
//  RaiffeisenTest
//
//  Created by Oleh Petrenko on 01.09.2022.
//

import Foundation

//TODO: think about `private let responseAdditionalHandler: [NetworkResponseAdditionalHandler]`. Probably it's not needed

final class HttpClient {
    
    #if DEBUG
        private let _printMyNetDataThread: Bool = true
    #endif
    
    private let baseURL: URL
    private let requestExecutor: NetworkRequestExecutor
    
    private let headerProviders: [NetworkRequestAdditionalHeadersProviding]
    private let parameterProviders: [NetworkRequestAdditionalParametersProviding]
    private let additionalURLParameterProviders: [NetworkRequestAdditionalURLParametersProviding]
//    private let responseAdditionalHandler: [NetworkResponseAdditionalHandler]
    
    private var additionalParameters: Parameters {
        return parameterProviders.reduce([:]) { result, provider -> Parameters in
            return result.merging(provider.parameters) { current, _ in current }
        }
    }
    
    private var additionalHeaders: HTTPHeaders {
        return headerProviders.reduce([:], { result, provider -> HTTPHeaders in
            return result.merging(provider.headers) { current, _ in current }
        })
    }
    
    private var additionalURLParameters: Parameters {
        return additionalURLParameterProviders.reduce([:]) { result, provider -> Parameters in
            return result.merging(provider.parameters) { current, _ in current }
        }
    }
    
    init(baseURL: URL,
         requestExecutor: NetworkRequestExecutor,
         headerProviders: [NetworkRequestAdditionalHeadersProviding] = [],
         parameterProviders: [NetworkRequestAdditionalParametersProviding] = [],
         additionalURLParameterProviders: [NetworkRequestAdditionalURLParametersProviding] = []) { //responseAdditionalHandler: [NetworkResponseAdditionalHandler] = []
        self.baseURL = baseURL
        self.requestExecutor = requestExecutor
        self.headerProviders = headerProviders
        self.parameterProviders = parameterProviders
        self.additionalURLParameterProviders = additionalURLParameterProviders
//        self.responseAdditionalHandler = responseAdditionalHandler
    }
    
    public func executeRequest(endpoint: String?,
                               method: HTTPMethod = .get,
                               parameters: Parameters? = nil,
                               headers: HTTPHeaders? = nil) async -> Result<NetworkResponse, NetworkRequestError> {
        
        guard let url = makeURL(withBaseURL: baseURL, endpoint: endpoint, parameters: additionalURLParameters), url.absoluteString.isValidURL else {
            return .failure(.invalidURL(nil, baseURL.absoluteString))
        }
        
        let encoding = (method == .get) ? ParameterEncoding.URL : ParameterEncoding.JSON
        
        let parameters = parameters ?? [:]
        let allParameters = parameters.merging(additionalParameters) { current, _ in current }
        
        let headers = headers ?? [:]
        let allHeaders = headers.merging(additionalHeaders) { current, _ in current }
        
        let endpoint = endpoint ?? ""
        var outRequestString = ""
        printdebugInfo_request(method, endpoint, parameters, url, headers, &outRequestString)
        
        let result = await requestExecutor.executeRequest(baseURL, method: method, parameters: allParameters, encoding: encoding, headers: allHeaders)
        
        printResponseIfNeeded(result: result, outRequestString: &outRequestString)
        
        return result
    }
    
    private func makeURL(withBaseURL baseURL: URL, endpoint: String?, parameters: Parameters) -> URL? {
        guard let endpoint = endpoint else { return baseURL }
        
        var url = !endpoint.isEmpty ? URL(string: baseURL.absoluteString + endpoint) : baseURL
        
        if !parameters.isEmpty, var path = url?.absoluteString {
            for (index, parameter) in parameters.enumerated() {
                path += index == 0 ? "?" : "&"
                path += parameter.key + "=" + String(describing: parameter.value)
            }
            url = URL(string: path)
        }
        
        return url
    }
    
}

//MARK: - Debug printing

extension HttpClient {
    
    private func printdebugInfo_request(_ method: HTTPMethod, _  endpoint: String, _ parameters: Parameters, _ url: URL, _ headers: HTTPHeaders, _ outRequestString: inout String) {
        #if DEBUG
        if _printMyNetDataThread {
            outRequestString = outRequestString + "\n*** Network ***\n* >>> - [\(method)]\(!endpoint.isEmpty ? ", endpoint: [\(endpoint)]" : "" )"
            outRequestString = outRequestString + "\n\turl: \(url)"
            if parameters.isEmpty == false { outRequestString = outRequestString + "\n\tparam: \(parameters as AnyObject) " }
            if headers.isEmpty == false { outRequestString = outRequestString + "\n\theaders: \(headers as AnyObject)" }
        }
        #endif
    }
    
    private func printResponseIfNeeded(result: Result<NetworkResponse, NetworkRequestError>, outRequestString: inout String) {
#if DEBUG
        if _printMyNetDataThread {
            let response: NetworkResponse?
            
            switch result {
            case .success(let resp): response = resp
            case .failure(let err):
                switch err {
                case .failed(let resp):
                    response = resp
                case .invalidURL(let resp, let invalidUrl):
                    print("INVALID URL ---->>>> \(invalidUrl)")
                    response = resp
                }
            }
            printdebugInfo_response(response?.httpStatusCode, response?.responseData, response?.error, nil, &outRequestString)
        }
#endif
    }
    
    private func printdebugInfo_response(_ statusCode: Int?, _ data: Data?, _ error: Error?, _ httpURLResponse: HTTPURLResponse?, _ outRequestString: inout String) {
        #if DEBUG
        if _printMyNetDataThread {
            var str = "\n* <<< - [\( (statusCode ?? 0)! )], error: [\( (error?.localizedDescription ?? "no")! )]"
//            str = str + "\n\turl: \(httpURLResponse?.url)"
            
            // Print all header fields
            if let allFields = httpURLResponse?.allHeaderFields.map({ "\t\t\($0.key.base): \($0.value);\n"}).joined() { str = str + "\n\tHeaderFields:\n\(allFields)" }
            
            // Print several header fields
            //if let fields = httpURLResponse?.allHeaderFields.compactMap({
            //    if let key = $0.key.base as? String {
            //        return ["Content-Type", "Content-Length"].contains(key) ? "\t\t\($0.key.base): \($0.value);\n" : nil
            //    }
            //    return nil
            //}).joined() { str = str + "\n\tHeaderFields:\n\(fields)" }
            
            if let data = data, !data.isEmpty {
                if let responseData = String(data: data, encoding: String.Encoding.utf8) {
                    let regex = try! NSRegularExpression(pattern: "\\\"content\\\":.*\\\"", options: NSRegularExpression.Options.caseInsensitive)
                    let modString = regex.stringByReplacingMatches(in: responseData, options: [], range: NSMakeRange(0, responseData.count), withTemplate: "\"content\":\"...crop image data...\"")
                    str = str + "\n\tdata: \(modString)"
                }
            }
            
            str = outRequestString + str + "\n***************\n"
            DispatchQueue.global(qos: .background).async {
                print(str)
            }
        }
        #endif
    }
    
}

//TODO: move to extensions
public extension String {
    
    var isValidURL: Bool {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector?.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
    
}
