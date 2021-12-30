//
//  NetworkConstants.swift
//  Attendance
//
//  Created by Peter Bassem on 12/16/19.
//  Copyright © 2019 iMac. All rights reserved.
//
import Foundation

struct K {
    struct ProductionServer {
        static let baseURL = "https://las.s-badge.com:8099/api/"
        static let baseImageURL = "https://mandobeemobileapp.mandobee.com/"
    }
    
    struct APIQueryKey { }
    
    struct APIParameterKey { }
    
    enum HTTPHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }
    
    enum ContentType: String {
        case json = "application/json"
        case formData = "form-data"
        case multipart = "multipart/form-data"
        case bearer = "Bearer"
    }
}
