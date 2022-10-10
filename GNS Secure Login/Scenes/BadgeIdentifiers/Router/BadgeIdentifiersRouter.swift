//
//  BadgeIdentifiersRouter.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 10/10/2022.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit

// MARK: BadgeIdentifiers Router -

class BadgeIdentifiersRouter: BaseRouter, BadgeIdentifiersRouterProtocol {
    
    static func createModule(badgeIdentifier: String) -> UIViewController {
        let view =  BadgeIdentifiersViewController()

        let interactor = BadgeIdentifiersInteractor()
        let router = BadgeIdentifiersRouter()
        let presenter = BadgeIdentifiersPresenter(view: view, interactor: interactor, router: router, badgeIdentifier: badgeIdentifier)
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }

}
