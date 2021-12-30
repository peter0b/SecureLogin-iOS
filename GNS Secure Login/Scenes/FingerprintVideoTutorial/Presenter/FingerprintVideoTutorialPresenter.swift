//
//  FingerprintVideoTutorialPresenter.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 29/08/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation

// MARK: FingerprintVideoTutorial Presenter -

class FingerprintVideoTutorialPresenter: BasePresenter {

    weak var view: FingerprintVideoTutorialViewProtocol?
    private let interactor: FingerprintVideoTutorialInteractorInputProtocol
    private let router: FingerprintVideoTutorialRouterProtocol
    
    init(view: FingerprintVideoTutorialViewProtocol, interactor: FingerprintVideoTutorialInteractorInputProtocol, router: FingerprintVideoTutorialRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - FingerprintVideoTutorialPresenterProtocol
extension FingerprintVideoTutorialPresenter: FingerprintVideoTutorialPresenterProtocol {
    
    func viewDidLoad() {
        
    }
}

// MARK: - API
extension FingerprintVideoTutorialPresenter: FingerprintVideoTutorialInteractorOutputProtocol {
    
}

// MARK: - Selector
extension FingerprintVideoTutorialPresenter {
    
    func performDismiss() {
        router.dismissViewController()
    }
}
