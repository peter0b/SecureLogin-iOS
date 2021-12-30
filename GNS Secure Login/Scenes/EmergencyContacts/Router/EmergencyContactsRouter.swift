//
//  EmergencyContactsRouter.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 25/07/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit

// MARK: EmergencyContacts Router -

class EmergencyContactsRouter: BaseRouter, EmergencyContactsRouterProtocol {
    
    static func createModule() -> UIViewController {
        let view =  EmergencyContactsViewController()

        let interactor = EmergencyContactsInteractor()
        let router = EmergencyContactsRouter()
        let presenter = EmergencyContactsPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }

}
