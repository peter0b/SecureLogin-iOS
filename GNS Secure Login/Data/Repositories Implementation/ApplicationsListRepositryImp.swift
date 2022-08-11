//
//  ApplicationsListRepositryImp.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 03/08/2021.
//

import Foundation

class ApplicationsListRepositryImp: ApplicationsListRepositry {
    
    private let remoteApplicationsListDataSource = RemoteApplicationsListDataSource()
    
    func getApplications(params: GetApplicationsList, completion: @escaping (Result<ApplicationsList, NetworkErrorType>) -> Void) {
        remoteApplicationsListDataSource.getFromRemote(from: .getApplicationsList(params: params), completion: completion)
    }
    
    func getCheckEnrollmentCount(params: GetApplicationsList, completion: @escaping (Result<ApplicationsList, NetworkErrorType>) -> Void) {
        remoteApplicationsListDataSource.getFromRemote(from: .getApplicationsList(params: params), completion: completion)
    }
    
    func validateUserPin(params: GetApplicationsList, completion: @escaping (Result<ApplicationsList, NetworkErrorType>) -> Void) {
        remoteApplicationsListDataSource.getFromRemote(from: .getApplicationsList(params: params), completion: completion)
    }
    
    func validateUserOTP(params: GetApplicationsList, completion: @escaping (Result<ApplicationsList, NetworkErrorType>) -> Void) {
        remoteApplicationsListDataSource.getFromRemote(from: .getApplicationsList(params: params), completion: completion)
    }
    
    func addUserPin(params: GetApplicationsList, completion: @escaping (Result<ApplicationsList, NetworkErrorType>) -> Void) {
        remoteApplicationsListDataSource.getFromRemote(from: .getApplicationsList(params: params), completion: completion)
    }
    
    func updateEnrollmentCount(params: GetApplicationsList, completion: @escaping (Result<ApplicationsList, NetworkErrorType>) -> Void) {
        remoteApplicationsListDataSource.getFromRemote(from: .getApplicationsList(params: params), completion: completion)
    }
}
