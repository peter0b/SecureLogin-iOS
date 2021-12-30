//
//  APIError.swift
//  MandoBee
//
//  Created by Peter Bassem on 18/06/2021.
//

import Foundation

enum APIError: Error, Equatable {
    case unauthorized
    case offline
    case requestExceeded
    case notFound
    case timeout
    case networkError
    case with(message: String)
    case empty
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return NSLocalizedString("error.unauthorized", comment: "Unauthorized")
        case .offline:
            return NSLocalizedString("error.offline", comment: "Offline")
        case .networkError:
            return NSLocalizedString("error.networkError", comment: "Network error")
        case .notFound:
            return NSLocalizedString("error.notFound", comment: "Not found")
        case .requestExceeded:
            return NSLocalizedString("error.requestExceeded", comment: "Reuest times exceeded")
        case .with(let message):
            return NSLocalizedString(message, comment: "Server error message")
        case .timeout:
            return NSLocalizedString("error.timeout", comment: "Connection timeout")
        case .empty:
            return NSLocalizedString("error.emptyMenu", comment: "No Items")
        }
    }
}
