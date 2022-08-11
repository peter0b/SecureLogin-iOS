//
//  NetworkManager.swift
//  MandoBee
//
//  Created by Peter Bassem on 20/06/2021.
//

import Foundation
import Alamofire

class NetworkManager {
    
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    class func observeInternetConnectionStatus(completion: @escaping (NetworkReachabilityManager.NetworkReachabilityStatus) -> Void) {
        NetworkReachabilityManager()?.startListening(onUpdatePerforming: { networkStatusListener in
            completion(networkStatusListener)
        })
    }
}
