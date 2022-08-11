//
//  FloatExtensions.swift
//  Driver
//
//  Created by Peter Bassem on 27/12/2020.
//  Copyright © 2020 Eslam Maged. All rights reserved.
//

import Foundation

extension Float64 {
    
    func toInt() -> Int {
        return Int(self)
    }
}

extension Float {
 
    func toString() -> String {
        return String(self)
    }
    
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Self {
        let divisor = pow(10.0, Double(places))
        return Float((Double(self) * divisor).rounded() / divisor)
    }
    
    func toInt() -> Int {
        return Int(self)
    }
}
