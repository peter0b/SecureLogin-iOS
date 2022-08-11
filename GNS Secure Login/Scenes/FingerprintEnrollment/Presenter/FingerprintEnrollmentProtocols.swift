//
//  FingerprintEnrollmentProtocols.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 25/08/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation

// MARK: FingerprintEnrollment Protocols

protocol FingerprintEnrollmentViewProtocol: BaseViewProtocol {
    var presenter: FingerprintEnrollmentPresenterProtocol! { get set }
    
}

protocol FingerprintEnrollmentPresenterProtocol: BasePresenterProtocol {
    var view: FingerprintEnrollmentViewProtocol? { get set }
    
    func viewDidLoad()
    func didFinishFingerEnrollmentProcess()

    func performBack()
    func performShowVideoTutorialViewController()
}

protocol FingerprintEnrollmentRouterProtocol: BaseRouterProtocol {
    func showFingerprintVideoTutorialViewController()
    func presentEnrollmentAlertViewController(enrollAlertType: EnrollAlertType, badgeSerial: String?, completionAction: @escaping EnrollAlertCompletion)
}

protocol FingerprintEnrollmentInteractorInputProtocol: BaseInteractorInputProtocol {
    var presenter: FingerprintEnrollmentInteractorOutputProtocol? { get set }
    func updateEnrollmentCount(params: GetApplicationsList)
}

protocol FingerprintEnrollmentInteractorOutputProtocol: BaseInteractorOutputProtocol {
    func fetchingUpdateEnrollmentCountSuccessfully()
    func fetchingCheckBadeEnrollmentCountWithError(_ error: String)
}
