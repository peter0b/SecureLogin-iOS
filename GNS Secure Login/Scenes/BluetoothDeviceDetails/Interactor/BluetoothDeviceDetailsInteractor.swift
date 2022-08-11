//
//  BluetoothDeviceDetailsInteractor.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 22/08/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation

// MARK: BluetoothDeviceDetails Interactor -

class BluetoothDeviceDetailsInteractor: BluetoothDeviceDetailsInteractorInputProtocol {
    
    weak var presenter: BluetoothDeviceDetailsInteractorOutputProtocol?
    private let useCase: ApplicationsListUseCase
    
    init(useCase: ApplicationsListUseCase) {
        self.useCase = useCase
    }
    
    func getCheckEnrollmentCount(params: GetApplicationsList) {
        useCase.getCheckEnrollmentCount(params: params) { result in
            switch result {
            case .success(let enrollmentCountResponse):
                guard let metaData = enrollmentCountResponse.metaData,
                      let jsonData = metaData.data(using: .utf8)
                else { return }
                do {
                    let enrollmentCountModel = try JSONDecoder().decode(MetaDataResponse.self, from: jsonData)
                    DispatchQueue.main.async {
                        self.presenter?.fetchingCheckBadgeEnrollmentCountSuccessfully(enrollmentCountModel.enrollmentCount ?? 0)
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        self.presenter?.fetchingCheckBadeEnrollmentCountWithError(enrollmentCountResponse.metaData ?? error.localizedDescription)
                    }
                }
            case .failure(let error):
                print("error:", error)
            }
        }
    }
}
