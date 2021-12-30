//
//  EditApplicationCredentialsRouter.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 27/12/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit
import CoreBluetooth
import SmartCardIO

// MARK: EditApplicationCredentials Router -

class EditApplicationCredentialsRouter: BaseRouter, EditApplicationCredentialsRouterProtocol {
    
    static func createModule(card: Card, mifareDesfireHelper: MiFareDesfireHelper, application: SitesInfo) -> UIViewController {
        let view =  EditApplicationCredentialsViewController(card: card, mifareDesfireHelper: mifareDesfireHelper)

        let interactor = EditApplicationCredentialsInteractor()
        let router = EditApplicationCredentialsRouter()
        let presenter = EditApplicationCredentialsPresenter(view: view, interactor: interactor, router: router, application: application)
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }
}
