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
    
    static func createModule(withBluetooth ble: CBPeripheral) -> UIViewController {
        let view =  FingerprintEnrollmentViewController()
        view.ble = ble

        let interactor = FingerprintEnrollmentInteractor()
        let router = FingerprintEnrollmentRouter()
        let presenter = FingerprintEnrollmentPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }
    
    func showFingerprintVideoTutorialViewController() {
        let fingerprintVideoTutorialViewController = FingerprintVideoTutorialRouter.createModule()
        viewController?.present(fingerprintVideoTutorialViewController, animated: true)
    }
}
