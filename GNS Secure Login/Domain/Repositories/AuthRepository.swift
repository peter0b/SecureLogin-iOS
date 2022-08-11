//
//  AuthRepository.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 12/01/2022.
//

import Foundation

protocol AuthRepository {
    func loginUser(authRequest: AuthRequest, completion: @escaping (Result<AuthResponse, NetworkErrorType>) -> Void)
}
