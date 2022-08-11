//
//  FingerprintEnrollmentUseCase.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 11/08/2022.
//

import Foundation

class FingerprintEnrollmentUseCase {
    private let applicationsListRepository: ApplicationsListRepositry
    
    init(applicationsListRepository: ApplicationsListRepositry) {
        self.applicationsListRepository = applicationsListRepository
    }
    
    func updateEnrollmentCount(params: GetApplicationsList, completion: @escaping (Result<ApplicationsList, NetworkErrorType>) -> Void) {
        applicationsListRepository.updateEnrollmentCount(params: params, completion: completion)
    }
}
