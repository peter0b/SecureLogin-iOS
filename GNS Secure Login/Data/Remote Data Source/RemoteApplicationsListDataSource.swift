//
//  RemoteApplicationsListDataSource.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 03/08/2021.
//

import Foundation

class RemoteApplicationsListDataSource: BaseService {
    
    func getFromRemote(from apiRouter: APIRouter, completion: @escaping (Result<ApplicationsList, NetworkErrorType>) -> Void) {
        APIClient.performRequest(route: apiRouter).execute { (result) in
            completion(.success(result))
        } onFailure: { error in
            completion(.failure(error))
        }
    }
}
