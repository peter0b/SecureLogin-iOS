//
//  HomeRouter.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 22/07/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit
import CoreBluetooth

// MARK: Home Router -

class HomeRouter: BaseRouter, HomeRouterProtocol {
    
    static func createModule() -> UIViewController {
        let view =  HomeViewController()

        let interactor = HomeInteractor()
        let router = HomeRouter()
        let presenter = HomePresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }

    func showScanBadgeViewController(withSavedCard card: CBPeripheral?) {
        viewController?.splitViewController?.showDetailViewController(UINavigationController(rootViewController: ScanBadgeRouter.createModule()), sender: self)
    }
    
    func showFormatBadgeViewController() {
        viewController?.splitViewController?.showDetailViewController(FormatBadgeRouter.createModule(), sender: self)
    }
    
    func showEmergencyContactsViewController() {
        viewController?.splitViewController?.showDetailViewController(EmergencyContactsRouter.createModule(), sender: self)
    }
    
    func showSettingsViewController(withSavedReader reader: CBPeripheral?) {
        viewController?.splitViewController?.showDetailViewController(UINavigationController(rootViewController: SettingsRouter.createModule(withSavedReader: reader)), sender: self)
    }
}
