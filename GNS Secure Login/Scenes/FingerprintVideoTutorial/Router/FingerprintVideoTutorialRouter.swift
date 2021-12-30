//
//  FingerprintVideoTutorialRouter.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 29/08/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit

// MARK: FingerprintVideoTutorial Router -

class FingerprintVideoTutorialRouter: BaseRouter, FingerprintVideoTutorialRouterProtocol {
    
    static func createModule() -> UIViewController {
        let view =  FingerprintVideoTutorialViewController()
        view.modalPresentationStyle = .overFullScreen
        
        let interactor = FingerprintVideoTutorialInteractor()
        let router = FingerprintVideoTutorialRouter()
        let presenter = FingerprintVideoTutorialPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }
}
