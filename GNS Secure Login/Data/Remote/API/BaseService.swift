//
//  BaseService.swift
//  MandoBee
//
//  Created by Peter Bassem on 22/06/2021.
//

import Foundation

protocol BaseService {
    associatedtype CodableResponse: Codable
    func getFromRemote(from apiRouter: APIRouter, completion: @escaping (Result<CodableResponse, NetworkErrorType>) -> Void)
}
