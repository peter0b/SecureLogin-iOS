//
//  FingerprintEnrollmentRouter.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 25/08/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit
import CoreBluetooth

// MARK: FingerprintEnrollment Router -

class FingerprintEnrollmentRouter: BaseRouter, FingerprintEnrollmentRouterProtocol {
    
    static func createModule(withBluetooth ble: CBPeripheral, enrollAlertType: EnrollAlertType, badgeSerial: String, firstEnrollment: Bool) -> UIViewController {
        let view =  FingerprintEnrollmentViewController()
        view.ble = ble

        let interactor = FingerprintEnrollmentInteractor(
            useCase: FingerprintEnrollmentUseCase(
                applicationsListRepository: ApplicationsListRepositryImp()
            )
        )
        let router = FingerprintEnrollmentRouter()
        let presenter = FingerprintEnrollmentPresenter(view: view, interactor: interactor, router: router, enrollAlertType: enrollAlertType, badgeSerial: badgeSerial, firstEnrollment: firstEnrollment)
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }
    
    func showFingerprintVideoTutorialViewController() {
        let fingerprintVideoTutorialViewController = FingerprintVideoTutorialRouter.createModule()
        viewController?.present(fingerprintVideoTutorialViewController, animated: true)
    }
    
    func presentEnrollmentAlertViewController(enrollAlertType: EnrollAlertType, badgeSerial: String?, completionAction: @escaping EnrollAlertCompletion) {
        let enrollmentAlertViewController = EnrollmentAlertRouter.createModule(enrollAlertType: enrollAlertType, badgeSerial: badgeSerial, completionAction: completionAction)
        enrollmentAlertViewController.modalPresentationStyle = .overFullScreen
        enrollmentAlertViewController.modalTransitionStyle = .crossDissolve
        viewController?.present(enrollmentAlertViewController, animated: true)
    }
}
