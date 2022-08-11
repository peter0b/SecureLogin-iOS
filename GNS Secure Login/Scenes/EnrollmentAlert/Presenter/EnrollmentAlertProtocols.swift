//
//  EnrollmentAlertProtocols.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 10/08/2022.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation

// MARK: EnrollmentAlert Protocols

protocol EnrollmentAlertViewProtocol: BaseViewProtocol {
    var presenter: EnrollmentAlertPresenterProtocol! { get set }
    func setAlertTitle(_ title: String)
    func setAlertTextFieldPlaceholder(_ placeholder: String)
    func disableSubmitButton()
    func enableSubmitButton()
}

protocol EnrollmentAlertPresenterProtocol: BasePresenterProtocol {
    var view: EnrollmentAlertViewProtocol? { get set }
    
    func viewDidLoad()

    func performValidateCode(_ code: String?)
    func performCancel()
    func perfromSubmit(_ code: String?)
}

protocol EnrollmentAlertRouterProtocol: BaseRouterProtocol {
    
}

protocol EnrollmentAlertInteractorInputProtocol: BaseInteractorInputProtocol {
    var presenter: EnrollmentAlertInteractorOutputProtocol? { get set }
    func validateUserOTP(params: GetApplicationsList)
    func addUserPin(params: GetApplicationsList)
    func validateUserPin(params: GetApplicationsList)
}

protocol EnrollmentAlertInteractorOutputProtocol: BaseInteractorOutputProtocol {
    func fetchingValidateUserOTPSuccessfully()
    func fetchingAddPinToBadgeSuccessfully()
    func fetchingValidateUserPinSuccessfully()
    func fetchingResponseWithError(_ error: String)
}
