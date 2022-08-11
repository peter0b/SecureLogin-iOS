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
    private var enrollAlertType: EnrollAlertType
    private var badgeSerial: String
    private var firstEnrollment: Bool
    
    init(view: FingerprintEnrollmentViewProtocol, interactor: FingerprintEnrollmentInteractorInputProtocol, router: FingerprintEnrollmentRouterProtocol, enrollAlertType: EnrollAlertType, badgeSerial: String, firstEnrollment: Bool) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.enrollAlertType = enrollAlertType
        self.badgeSerial = badgeSerial
        self.firstEnrollment = firstEnrollment
    }
}

// MARK: - FingerprintEnrollmentPresenterProtocol
extension FingerprintEnrollmentPresenter: FingerprintEnrollmentPresenterProtocol {
    
    func viewDidLoad() {
        
    }
    
    func didFinishFingerEnrollmentProcess() {
        if enrollAlertType == .validateOTP {
            router.presentEnrollmentAlertViewController(enrollAlertType: .addPIN, badgeSerial: badgeSerial, completionAction: { [unowned self] _ in
                let params = GetApplicationsList(
                    commandType: AuthCommandType.changeEnrollmentCount.rawValue,
                    gnsLicense: GlobalConstants.gnsLicense.rawValue,
                    cardUID:  nil,
                    badgeSerial: badgeSerial,
                    metaData: "\(self.firstEnrollment)"
                )
                self.interactor.updateEnrollmentCount(params: params)
            })
        }
    }
}

// MARK: - API
extension FingerprintEnrollmentPresenter: FingerprintEnrollmentInteractorOutputProtocol {
    func fetchingUpdateEnrollmentCountSuccessfully() {
        print("Incremented!")
    }
    
    func fetchingCheckBadeEnrollmentCountWithError(_ error: String) {
        view?.hideLoading()
        router.presentAlertControl(title: "", message: error, actionTitle: "Okay", action: nil)
    }
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
