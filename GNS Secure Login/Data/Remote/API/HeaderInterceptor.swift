//
//  HeaderInterceptor.swift
//  MandoBee
//
//  Created by Peter Bassem on 22/06/2021.
//

import Foundation
import Alamofire

final class HeaderInterceptor {
    
    static func defaultHeaderIntercepter(fromURLRequest urlRequest: inout URLRequest) {
        urlRequest.setValue(K.ContentType.json.rawValue, forHTTPHeaderField: K.HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(K.ContentType.json.rawValue, forHTTPHeaderField: K.HTTPHeaderField.contentType.rawValue)
    }
}
