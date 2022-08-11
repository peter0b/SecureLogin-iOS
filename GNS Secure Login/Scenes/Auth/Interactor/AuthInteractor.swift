//
//  AuthInteractor.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 21/07/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation

// MARK: Auth Interactor -

class AuthInteractor: AuthInteractorInputProtocol {
    
    weak var presenter: AuthInteractorOutputProtocol?
    private let authUseCase: AuthUseCase
    
    init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
    }
    
    func loginUser(authRequest: AuthRequest) {
        authUseCase.loginUser(authRequest: authRequest) { [unowned self] result in
            switch result {
            case .success(let userResponse):
                DispatchQueue.main.async {
                    self.presenter?.fetchingLoginSuccessfully(user: userResponse)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter?.fetchingLoignWithError(error: error.rawValue.localized())
                }
            }
        }
    }
}
