//
//  FingerprintEnrollmentPresenter.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 25/08/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation

// MARK: FingerprintEnrollment Presenter -

class FingerprintEnrollmentPresenter: BasePresenter {

    weak var view: FingerprintEnrollmentViewProtocol?
    private let interactor: FingerprintEnrollmentInteractorInputProtocol
    private let router: FingerprintEnrollmentRouterProtocol
    
    init(view: FingerprintEnrollmentViewProtocol, interactor: FingerprintEnrollmentInteractorInputProtocol, router: FingerprintEnrollmentRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - FingerprintEnrollmentPresenterProtocol
extension FingerprintEnrollmentPresenter: FingerprintEnrollmentPresenterProtocol {
    
    func viewDidLoad() {
        
    }
}

// MARK: - API
extension FingerprintEnrollmentPresenter: FingerprintEnrollmentInteractorOutputProtocol {
    
}

// MARK: - Selectors
extension FingerprintEnrollmentPresenter {
    
    func performBack() {
        router.popupViewController()
    }
    
    func performShowVideoTutorialViewController() {
        router.showFingerprintVideoTutorialViewController()
    }
}
