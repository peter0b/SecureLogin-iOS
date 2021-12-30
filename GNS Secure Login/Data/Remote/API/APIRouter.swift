//
//  APIRouter.swift
//  MandoBee
//
//  Created by Peter Bassem on 18/06/2021.
//

import Foundation
import Alamofire

enum APIRouter: APIConfiguration {
    
    case login
    case getApplicationsList(params: GetApplicationsList)
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .login: return .post
        case .getApplicationsList: return .post
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .login: return "delegate/get_setting"
        case .getApplicationsList: return "AuthService/DoInvoke"
        }
    }
    
    // MARK: - Quary
    var query: [URLQueryItem]? {
        switch self {
        case .login : return nil
        case .getApplicationsList: return nil
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .login: return nil
        case .getApplicationsList(let params): return try? params.asDictionary()
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        var url = try K.ProductionServer.baseURL.asURL()
        
        if let query = query {
            var urlComponents = URLComponents(string: url.absoluteString)
            urlComponents?.queryItems = query
            url = try (urlComponents?.asURL())!
        }
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        HeaderInterceptor.defaultHeaderIntercepter(fromURLRequest: &urlRequest)
        
        print(urlRequest)
        
        // Parameters
        if let parameters = parameters {
            print(parameters)
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        return urlRequest
    }
}
