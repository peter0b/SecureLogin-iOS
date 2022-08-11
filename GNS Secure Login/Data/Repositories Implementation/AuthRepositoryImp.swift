//
//  AuthRepositoryImp.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 12/01/2022.
//

import Foundation

class AuthRepositoryImp: AuthRepository {
    
    private let remoteAuthDataSource = RemoteAuthDataSource()
    
    func loginUser(authRequest: AuthRequest, completion: @escaping (Result<AuthResponse, NetworkErrorType>) -> Void) {
        remoteAuthDataSource.loginUser(from: .login(authRequest: authRequest), completion: completion)
    }
}
