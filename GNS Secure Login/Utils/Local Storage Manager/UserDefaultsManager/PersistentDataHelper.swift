//
//  PersistentDataHelper.swift
//  Incadre
//
//  Created by Peter Bassem on 9/13/20.
//  Copyright © 2020 Peter Bassem. All rights reserved.
//

import Foundation
import CoreBluetooth

// MARK: - UserDefaultsKeys
enum UserDefaultsKeys: String {
    case readerConnected = "READER_PERIFPHERAL_CONNECTED"
    case readerIdentifier = "READER_PERIPHERAL_IDENTIFIER"
}

// MARK: - UserDefaults
let userDefaults = UserDefaults.standard

let encoder = JSONEncoder()
let decoder = JSONDecoder()

// MARK: -
class PersistentDataHelper {
    
    static let shared = PersistentDataHelper()
    
    private init() { }
    
    var readerConnected: Bool {
        get { return userDefaults.bool(forKey: UserDefaultsKeys.readerConnected.rawValue) }
        set { userDefaults.set(newValue, forKey: UserDefaultsKeys.readerConnected.rawValue)}
    }
    
    var readerPeripheral: String? {
        get { return userDefaults.string(forKey: UserDefaultsKeys.readerIdentifier.rawValue) }
        set { userDefaults.set(newValue, forKey: UserDefaultsKeys.readerIdentifier.rawValue) }
    }
    
    // MARK: - Clear UserDefaults
    func clear() {
        let domain = Bundle.main.bundleIdentifier!
        userDefaults.removePersistentDomain(forName: domain)
        userDefaults.synchronize()
    }
}

extension PersistentDataHelper {
    
    func set<T: Codable>(_ value: T?, type: T.Type, forKey key: UserDefaultsKeys) {
        let encodedT = try? encoder.encode(value)
        userDefaults.set(encodedT, forKey: key.rawValue)
    }
    
    func set(_ value: Any?, forKey key: UserDefaultsKeys) {
        userDefaults.set(value, forKey: key.rawValue)
    }
    
    func get<T: Codable>(forKey key: UserDefaultsKeys, withType type: T.Type) -> T? {
        guard let savedEncodedObject = userDefaults.object(forKey: key.rawValue) as? Data else { return nil }
        return try? decoder.decode(T.self, from: savedEncodedObject)
    }
}
