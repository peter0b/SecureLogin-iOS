//
//  FingerprintEnrollmentInteractor.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 25/08/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation

// MARK: FingerprintEnrollment Interactor -

class FingerprintEnrollmentInteractor: FingerprintEnrollmentInteractorInputProtocol {
    
    weak var presenter: FingerprintEnrollmentInteractorOutputProtocol?
    private let useCase: FingerprintEnrollmentUseCase
    
    init(useCase: FingerprintEnrollmentUseCase) {
        self.useCase = useCase
    }
    
    func updateEnrollmentCount(params: GetApplicationsList) {
        useCase.updateEnrollmentCount(params: params) { [unowned self] result in
            switch result {
            case .success(let updateCountResponse):
                if updateCountResponse.output == GlobalConstants.kSuccess.rawValue {
                    DispatchQueue.main.async {
                        self.presenter?.fetchingUpdateEnrollmentCountSuccessfully()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter?.fetchingCheckBadeEnrollmentCountWithError(error.rawValue.localized())
                }
            }
        }
    }
}
