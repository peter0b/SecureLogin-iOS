//
//  LocalAuthentication.swift
//  PasswordKeeper
//
//  Created by Herman Kwan on 6/10/18.
//  Copyright © 2018 Herman Kwan. All rights reserved.
//
import LocalAuthentication

class LocalAuthentication {
    
    static let shared = LocalAuthentication()
    let context = LAContext()

    enum BiometricType {
        case none
        case touchID
        case faceID
    }
    
    func biometricType() -> BiometricType {
        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        @unknown default:
            fatalError()
        }
    }
    
    func handleFaceTouchAuthentication(completion: @escaping(Bool) -> Void) {
        let context = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: LocalizationSystem.sharedInstance.localizedStringForKey(key: "userAuth", comment: "") /*"We need your touchID"*/) { (success, error) in
                
                if let error = error {
                    print("Error with evaluation", error)
                    completion(false); return
                }
                
                if success {
                    completion(true); return
                } else {
                    completion(true); return
                }
            }
        }
    }
}
