//
//  AuthPresenter.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 21/07/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation

// MARK: Auth Presenter -

class AuthPresenter: BasePresenter {

    weak var view: AuthViewProtocol?
    private let interactor: AuthInteractorInputProtocol
    private let router: AuthRouterProtocol
    
    init(view: AuthViewProtocol, interactor: AuthInteractorInputProtocol, router: AuthRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        
    }
    
}

// MARK : - AuthPresenterProtocol
extension AuthPresenter: AuthPresenterProtocol {
    
}

// MARK : - API
extension AuthPresenter: AuthInteractorOutputProtocol {
    
}

// MARK : - Selectors
extension AuthPresenter {
    
    func performLogin() {
        router.navigateToHome()
    }
}
