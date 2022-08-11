//
//  EnrollmentAlertPresenter.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 10/08/2022.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation

// MARK: EnrollmentAlert Presenter -

class EnrollmentAlertPresenter: BasePresenter {

    weak var view: EnrollmentAlertViewProtocol?
    private let interactor: EnrollmentAlertInteractorInputProtocol
    private let router: EnrollmentAlertRouterProtocol
    private let enrollAlertType: EnrollAlertType
    private let badgeSerial: String?
    private let completionAction: EnrollAlertCompletion
    
    init(view: EnrollmentAlertViewProtocol, interactor: EnrollmentAlertInteractorInputProtocol, router: EnrollmentAlertRouterProtocol, badgeSerial: String?, enrollAlertType: EnrollAlertType, completionAction: @escaping EnrollAlertCompletion) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.enrollAlertType = enrollAlertType
        self.badgeSerial =  badgeSerial
        self.completionAction = completionAction
    }
}

// MARK: - EnrollmentAlertPresenterProtocol
extension EnrollmentAlertPresenter: EnrollmentAlertPresenterProtocol {
    
    func viewDidLoad() {
        view?.setAlertTitle(enrollAlertType.title)
        view?.setAlertTextFieldPlaceholder(enrollAlertType.title)
    }
    
    func performValidateCode(_ code: String?) {
        code?.isEmpty == false ? view?.enableSubmitButton() : view?.disableSubmitButton()
    }
}

// MARK: - API
extension EnrollmentAlertPresenter: EnrollmentAlertInteractorOutputProtocol {
    func fetchingValidateUserOTPSuccessfully() {
        view?.hideLoading()
        completionAction(enrollAlertType)
        router.dismissViewController()
    }
    
    func fetchingAddPinToBadgeSuccessfully() {
        view?.hideLoading()
        router.presentAlertControl(title: nil, message: "Your PIN is assigned to the badge successfully. \nYou will use it in the next fingerprint enrollment process. ", actionTitle: "Okay") { [unowned self] in
            self.completionAction(self.enrollAlertType)
            router.dismissViewController()
        }
    }
    
    func fetchingValidateUserPinSuccessfully() {
        view?.hideLoading()
        completionAction(enrollAlertType)
        router.dismissViewController()
    }
    
    func fetchingResponseWithError(_ error: String) {
        view?.hideLoading()
        router.presentAlertControl(title: nil, message: error, actionTitle: "Okay", action: nil)
    }
}

// MARK: - Selectors
extension EnrollmentAlertPresenter {
    func performCancel() {
        router.dismissViewController()
    }
    
    func perfromSubmit(_ code: String?) {
        view?.showLoading()
        switch enrollAlertType {
        case .validateOTP:
            let params = GetApplicationsList(
                commandType: AuthCommandType.ValidateBadgeOTP.rawValue,
                gnsLicense: GlobalConstants.gnsLicense.rawValue,
                cardUID:  nil,
                badgeSerial: badgeSerial,
                metaData: code
            )
            interactor.validateUserOTP(params: params)
        case .addPIN:
            let params = GetApplicationsList(
                commandType: AuthCommandType.AddToUserPIN.rawValue,
                gnsLicense: GlobalConstants.gnsLicense.rawValue,
                cardUID:  nil,
                badgeSerial: badgeSerial,
                metaData: code
            )
            interactor.addUserPin(params: params)
        case .validatPIN:
            let params = GetApplicationsList(
                commandType: AuthCommandType.ValidateUserPIN.rawValue,
                gnsLicense: GlobalConstants.gnsLicense.rawValue,
                cardUID:  nil,
                badgeSerial: badgeSerial,
                metaData: code
            )
            interactor.validateUserPin(params: params)
        }
    }
}
