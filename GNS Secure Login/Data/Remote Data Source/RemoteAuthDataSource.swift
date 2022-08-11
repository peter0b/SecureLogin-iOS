//
//  RemoteAuthDataSource.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 12/01/2022.
//

import Foundation

class RemoteAuthDataSource {
    
    func loginUser(from apiRouter: APIRouter, completion: @escaping (Result<AuthResponse, NetworkErrorType>) -> Void) {
        APIClient.performRequest(route: apiRouter).execute { (result) in
            completion(.success(result))
        } onFailure: { error in
            completion(.failure(error))
        }
    }
}
