//
//  EnrollAlertType.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 10/08/2022.
//

import Foundation

enum EnrollAlertType {
    case validateOTP,  addPIN, validatPIN
    
    var title: String {
        switch self {
        case .validateOTP:
            return "Enter your OTP"
        case .addPIN:
            return "Add your PIN"
        case .validatPIN:
            return "Enter your PIN"
        }
    }
}
