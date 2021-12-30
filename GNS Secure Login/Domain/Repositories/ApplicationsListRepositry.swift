//
//  ApplicationsListRepositry.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 03/08/2021.
//

import Foundation

protocol ApplicationsListRepositry {
    func getApplications(params: GetApplicationsList, completion: @escaping (Result<ApplicationsList, NetworkErrorType>) -> Void)
}
