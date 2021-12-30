//
//  APIClient.swift
//  Attendance
//
//  Created by Peter Bassem on 12/16/19.
//  Copyright © 2019 iMac. All rights reserved.
//

import Foundation
import Alamofire
import PromisedFuture

enum NetworkErrorType: String, Error {
    case noInternet = "error.no_internet"
    case serverError = "error.error_in_server"
    case couldNotParseJson = "error.decoding_error"
    case empty = "error.empty"
    case authenicationRequired = "error.authentication_required"
}

class APIClient {
    
    //MARK: - peroformRequest without Completion Handler
//        @discardableResult
//    static func performRequest<T:Decodable>(route:APIConfiguration, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<T, Error>)->Void) -> DataRequest {
//        AF.request(route)
//            .validate(statusCode: 200...3000)
//            .responseDecodable(decoder: decoder) { (response: AFDataResponse<T>) in
//                switch response.result {
//                case .success(let value):
//                    completion(.success(value))
//                case .failure(let error):
//                    if let data = response.data {
//                        do {
//                            let value = try JSONDecoder().decode(T.self, from: data)
//                            completion(.success(value))
//                        } catch let error {
//                            completion(.failure(error))
//                        }
//                    } else {
//                        completion(.failure(error))
//                    }
//                }
//            }
//    }
    
    // MARK: - peroformRequest with Future
    @discardableResult
    static func performRequest<T: Decodable>(route: APIConfiguration, decoder: JSONDecoder = JSONDecoder()) -> Future<T, NetworkErrorType> {
        guard NetworkManager.isConnectedToInternet else {
            let future = Future<T, NetworkErrorType> { completion in
                completion(.failure(NetworkErrorType.noInternet))
            }
            return future
        }
        return Future(operation: { (completion) in
            AF.request(route)
                .validate(statusCode: 200...300)
                .responseDecodable(decoder: decoder, completionHandler: { (response: DataResponse<T,AFError>) in
//                    print(response.response?.statusCode ?? -1)
//                    print(response.result)
                    switch response.result {
                    case .success(let value):
                        completion(.success(value))
                    case .failure(_):
                        if let data = response.data {
                            do {
                                let value = try JSONDecoder().decode(T.self, from: data)
                                completion(.success(value))
                            } catch {
                                completion(.failure(NetworkErrorType.couldNotParseJson))
                            }

                        } else {
                            completion(.failure(NetworkErrorType.serverError))
                        }
                    }
                })
        })
    }
    
    
    static func uploadImage<T: Codable>(endUrl endPoint: String, token: String, imageData: Data?, imageFileName: String?, parameters: [String: Any], type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
        let url = String(format: "%@%@", K.ProductionServer.baseURL, endPoint)
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-type": "multipart/form-data",
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Accept-Encoding": "gzip, deflate, br"
        ]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            if let data = imageData, let name = imageFileName {
                multipartFormData.append(data, withName: "\(name)", fileName: "\(name).jpeg", mimeType: "image/jpg")
            }
        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: headers).uploadProgress(queue: .main) { (_) in

        }.responseJSON(queue: .main) { (response) in
            print("upload image \(imageFileName ?? "") finished:", response)
        }.responseDecodable { (response: DataResponse<T, AFError>) in
            if let error = response.error {
                completion(.failure(error))
                return
            }
            guard let value = response.value else { return }
            completion(.success(value))
        }
    }
    
    class func loadImage(fromUrl url: URL, callback: @escaping (UIImage) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let imageData = try? Data(contentsOf: url)
            if let data = imageData {
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        callback(image)
                    }
                    
                }
            }
        }
    }
}
