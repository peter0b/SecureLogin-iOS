//
//  AuthRouter.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 21/07/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit

// MARK: Auth Router -

class AuthRouter: BaseRouter, AuthRouterProtocol {

    static func createModule() -> UIViewController {
        let view =  AuthViewController()

        let interactor = AuthInteractor()
        let router = AuthRouter()
        let presenter = AuthPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }

    func navigateToHome() {
        let splitViewController = SplitViewController()
        splitViewController.viewControllers = [
            UINavigationController(rootViewController: HomeRouter.createModule()),
            UINavigationController(rootViewController: ScanBadgeRouter.createModule())
        ]
        keyWindow?.rootViewController = splitViewController
        keyWindow?.makeKeyAndVisible()
    }
}
