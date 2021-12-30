//
//  ApplicationsListInteractor.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 02/08/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation

// MARK: ApplicationsList Interactor -

class ApplicationsListInteractor: ApplicationsListInteractorInputProtocol {
    
    weak var presenter: ApplicationsListInteractorOutputProtocol?
    private let useCase: ApplicationsListUseCase
    
    init(useCase: ApplicationsListUseCase) {
        self.useCase = useCase
    }
    
    func getApplications(withParams params: GetApplicationsList) {
        useCase.getApplications(params: params) { [weak self] result in
            switch result {
            case .success(let applications):
                guard let metaData = applications.metaData,
                      let jsonData = metaData.data(using: .utf8)
                else { return }
                do {
                    let applicationsListMetaData = try JSONDecoder().decode(ApplicationsListMetaData.self, from: jsonData)
                    guard let applications = applicationsListMetaData.siteInfo, !applications.isEmpty else { return }
                    DispatchQueue.main.async {
                        self?.presenter?.fetchingApplicationsSuccessfully(applications)
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        self?.presenter?.fetchingApplicationsWithError(error)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.presenter?.fetchingApplicationsWithError(error)
                }
            }
        }
    }
}
