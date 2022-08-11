//
//  Icon.swift
//  MandoBee
//
//  Created by Peter Bassem on 17/06/2021.
//

import Foundation
import UIKit

extension DesignSystem {
    
    enum Icon: String {
        case background
        case logo
        case iconSuccess
        case iconError
        case error
        case success
        case visibilityOff = "visibility_off"
        case visibilityOn = "visibility_on"
        case fingerprint0 = "fingerprint0"
        case fingerprint1 = "fingerprint1"
        case fingerprint2 = "fingerprint2"
        case fingerprint3 = "fingerprint3"
        
        var image: UIImage {
            return UIImage(named: self.rawValue)!
        }
    }
}
