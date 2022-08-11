//
//  AuthUseCase.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 12/01/2022.
//

import Foundation

class AuthUseCase {
    
    private let authReporsitory: AuthRepository
    
    init(authReporsitory: AuthRepository) {
        self.authReporsitory = authReporsitory
    }
    
    // ------------
    // MARK: - AUTH
    // ------------
    func loginUser(authRequest: AuthRequest, completion: @escaping (Result<AuthResponse, NetworkErrorType>) -> Void) {
        authReporsitory.loginUser(authRequest: authRequest, completion: completion)
    }
}
