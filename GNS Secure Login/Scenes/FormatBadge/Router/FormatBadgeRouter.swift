//
//  FormatBadgeRouter.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 25/07/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit

// MARK: FormatBadge Router -

class FormatBadgeRouter: BaseRouter, FormatBadgeRouterProtocol {
    
    static func createModule() -> UIViewController {
        let view =  FormatBadgeViewController()

        let interactor = FormatBadgeInteractor()
        let router = FormatBadgeRouter()
        let presenter = FormatBadgePresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }

}
