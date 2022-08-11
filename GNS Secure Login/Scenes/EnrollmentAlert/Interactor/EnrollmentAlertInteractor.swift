//
//  EnrollmentAlertInteractor.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 10/08/2022.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation

// MARK: EnrollmentAlert Interactor -

class EnrollmentAlertInteractor: EnrollmentAlertInteractorInputProtocol {
    
    weak var presenter: EnrollmentAlertInteractorOutputProtocol?
    private let useCase: EnrollmentAlertUseCase
    
    init(useCase: EnrollmentAlertUseCase) {
        self.useCase = useCase
    }
    
    func validateUserPin(params: GetApplicationsList) {
        useCase.validateUserPin(params: params) { [unowned self] result in
            switch result {
            case .success(let validateUserPinResponse):
                guard let metaData = validateUserPinResponse.metaData,
                      let jsonData = metaData.data(using: .utf8)
                else { return }
                do {
                    let pinValidationModel = try JSONDecoder().decode(PinValidationModel.self, from: jsonData)
                    if pinValidationModel.success == true {
                        DispatchQueue.main.async {
                            self.presenter?.fetchingValidateUserPinSuccessfully()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.presenter?.fetchingResponseWithError(pinValidationModel.message ?? "")
                        }
                    }
                    
                } catch let error {
                    DispatchQueue.main.async {
                        self.presenter?.fetchingResponseWithError(validateUserPinResponse.metaData ?? error.localizedDescription)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter?.fetchingResponseWithError(error.rawValue.localized())
                }
            }
        }
    }
    
    func validateUserOTP(params: GetApplicationsList) {
        useCase.validateUserOTP(params: params) { [unowned self] result in
            switch result {
            case .success(let validateUserOTPResponse):
                guard let metaData = validateUserOTPResponse.metaData,
                      let jsonData = metaData.data(using: .utf8)
                else { return }
                do {
                    let otpValidationModel = try JSONDecoder().decode(PinValidationModel.self, from: jsonData)
                    if otpValidationModel.success == true {
                        DispatchQueue.main.async {
                            self.presenter?.fetchingValidateUserOTPSuccessfully()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.presenter?.fetchingResponseWithError(otpValidationModel.message ?? "")
                        }
                    }
                    
                } catch let error {
                    DispatchQueue.main.async {
                        self.presenter?.fetchingResponseWithError(validateUserOTPResponse.metaData ?? error.localizedDescription)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter?.fetchingResponseWithError(error.rawValue.localized())
                }
            }
        }
    }
    
    func addUserPin(params: GetApplicationsList) {
        useCase.addUserPin(params: params) { [unowned self] result in
            switch result {
            case .success(let addPinResponse):
                if addPinResponse.metaData == params.metaData {
                    DispatchQueue.main.async {
                        self.presenter?.fetchingAddPinToBadgeSuccessfully()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.presenter?.fetchingResponseWithError(addPinResponse.metaData ?? "")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter?.fetchingResponseWithError(error.rawValue.localized())
                }
            }
        }
    }
}
