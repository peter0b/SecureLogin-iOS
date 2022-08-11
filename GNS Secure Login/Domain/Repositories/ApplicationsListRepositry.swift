//
//  ApplicationsListRepositry.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 03/08/2021.
//

import Foundation

protocol ApplicationsListRepositry {
    func getApplications(params: GetApplicationsList, completion: @escaping (Result<ApplicationsList, NetworkErrorType>) -> Void)
    func getCheckEnrollmentCount(params: GetApplicationsList, completion: @escaping (Result<ApplicationsList, NetworkErrorType>) -> Void)
    func validateUserPin(params: GetApplicationsList, completion: @escaping (Result<ApplicationsList, NetworkErrorType>) -> Void)
    func validateUserOTP(params: GetApplicationsList, completion: @escaping (Result<ApplicationsList, NetworkErrorType>) -> Void)
    func addUserPin(params: GetApplicationsList, completion: @escaping (Result<ApplicationsList, NetworkErrorType>) -> Void)
    func updateEnrollmentCount(params: GetApplicationsList, completion: @escaping (Result<ApplicationsList, NetworkErrorType>) -> Void)
}
