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
    
    private var mUsername: String?
    private var mPassword: String?
    
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
 
    func fetchingLoginSuccessfully(user: AuthResponse) {
        view?.hideLoading()
        
//        let usernameCFString = (mUsername ?? "") as CFString
//        let passwordCFString = (mPassword ?? "") as CFString
//        SecAddSharedWebCredential(
//            "las.s-badge.com" as CFString,
//            usernameCFString,
//            passwordCFString
//        ) { error in
//            if let error = error {
//                print("❌Failed to save user to icloud keychain:", error)
//                return
//            }
//            print("Saved user to icloud keychaing✅")
//        }
    }
    
    func fetchingLoignWithError(error: String) {
        view?.hideLoading()
        view?.showBottomMessage(error)
    }
}

// MARK : - Selectors
extension AuthPresenter {
    
    func performLogin(company: String?, username: String?, password: String?) {
        mUsername = username
        mPassword = password
        view?.showLoading()
        interactor.loginUser(authRequest: AuthRequest(username: username, password: password))
//        router.navigateToHome()
    }
}
