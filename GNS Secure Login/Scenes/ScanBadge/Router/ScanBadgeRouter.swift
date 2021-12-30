//
//  ScanBadgeRouter.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 25/07/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit

// MARK: ScanBadge Router -

class ScanBadgeRouter: BaseRouter, ScanBadgeRouterProtocol {
    
    static func createModule() -> UIViewController {
        let view =  ScanBadgeViewController()

        let interactor = ScanBadgeInteractor()
        let router = ScanBadgeRouter()
        let presenter = ScanBadgePresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }

    func navigateToApplicationListViewController() {
        let applicationListCollectionViewController = ApplicationsListRouter.createModule()
        viewController?.navigationController?.pushViewController(applicationListCollectionViewController, animated: true)
    }
}
