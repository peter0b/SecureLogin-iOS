//
//  DictionaryExtensions.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 17/10/2021.
//

import Foundation
import CryptoSwift

extension Dictionary where Value: Equatable {
    
    func allKeys(forValue val: Value) -> [Key] {
        return self.filter { $1 == val }.map { $0.0 }
    }
    
    func key(forValue value: Value) -> Key {
        return self.filter { $1 == value }.map { $0.0 }[0]
    }
    
    func containsKey(key: Key) -> Bool {
        return !(self[key] == nil)
    }
}
