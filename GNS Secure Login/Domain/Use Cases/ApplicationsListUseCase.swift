//
//  ApplicationsListUseCase.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 03/08/2021.
//

import Foundation

class ApplicationsListUseCase {
    
    private let applicationsListRepository: ApplicationsListRepositry
    
    init(applicationsListRepository: ApplicationsListRepositry) {
        self.applicationsListRepository = applicationsListRepository
    }
    
    // --------------------
    // MARK: - Applications
    // --------------------
    func getApplications(params: GetApplicationsList, completion: @escaping (Result<ApplicationsList, NetworkErrorType>) -> Void) {
        applicationsListRepository.getApplications(params: params, completion: completion)
    }
}
