//
//  EnrollmentAlertUseCase.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 10/08/2022.
//

import Foundation

class EnrollmentAlertUseCase {
    private let applicationsListRepository: ApplicationsListRepositry
    
    init(applicationsListRepository: ApplicationsListRepositry) {
        self.applicationsListRepository = applicationsListRepository
    }
    
    func validateUserPin(params: GetApplicationsList, completion: @escaping (Result<ApplicationsList, NetworkErrorType>) -> Void) {
        applicationsListRepository.validateUserPin(params: params, completion: completion)
    }
    
    func validateUserOTP(params: GetApplicationsList, completion: @escaping (Result<ApplicationsList, NetworkErrorType>) -> Void) {
        applicationsListRepository.validateUserOTP(params: params, completion: completion)
    }
    
    func addUserPin(params: GetApplicationsList, completion: @escaping (Result<ApplicationsList, NetworkErrorType>) -> Void) {
        applicationsListRepository.addUserPin(params: params, completion: completion)
    }
}
