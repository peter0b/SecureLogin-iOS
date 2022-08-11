//
//  EnrollmentAlertRouter.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 10/08/2022.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit

// MARK: EnrollmentAlert Router -

class EnrollmentAlertRouter: BaseRouter, EnrollmentAlertRouterProtocol {
    
    static func createModule(enrollAlertType: EnrollAlertType, badgeSerial: String?, completionAction: @escaping EnrollAlertCompletion) -> UIViewController {
        let view =  EnrollmentAlertViewController()

        let interactor = EnrollmentAlertInteractor(
            useCase: EnrollmentAlertUseCase(
                applicationsListRepository: ApplicationsListRepositryImp()
            )
        )
        let router = EnrollmentAlertRouter()
        let presenter = EnrollmentAlertPresenter(view: view, interactor: interactor, router: router, badgeSerial: badgeSerial, enrollAlertType: enrollAlertType, completionAction: completionAction)
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }

}
