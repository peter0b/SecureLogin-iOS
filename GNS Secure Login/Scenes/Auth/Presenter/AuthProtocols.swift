//
//  AuthProtocols.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 21/07/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation

// MARK: Auth Protocols

protocol AuthViewProtocol: BaseViewProtocol {
    var presenter: AuthPresenterProtocol! { get set }
    
}

protocol AuthPresenterProtocol: BasePresenterProtocol {
    var view: AuthViewProtocol? { get set }
    
    func viewDidLoad()

    func performLogin()
}

protocol AuthRouterProtocol: BaseRouterProtocol {
    func navigateToHome()
}

protocol AuthInteractorInputProtocol: BaseInteractorInputProtocol {
    var presenter: AuthInteractorOutputProtocol? { get set }
    
}

protocol AuthInteractorOutputProtocol: BaseInteractorOutputProtocol {
    
    
}
