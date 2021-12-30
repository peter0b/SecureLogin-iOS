//
//  APIRouter.swift
//  Attendance
//
//  Created by Peter Bassem on 12/16/19.
//  Copyright © 2019 iMac. All rights reserved.
//

import Foundation
import Alamofire

protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var query: [URLQueryItem]? { get }
    var parameters: Parameters? { get }
}
