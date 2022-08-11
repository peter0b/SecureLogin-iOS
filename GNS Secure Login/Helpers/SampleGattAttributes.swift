//
//  SampleGattAttributes.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 25/08/2021.
//

import Foundation
import CoreBluetooth

class SampleGattAttributes {
    
    private static let GENERAL_SERVICE_UUID = "27bc59ce-f74f-4a7b-aa6b-2ea2d0f4b905"
    private static let DFU_SERVICE_UUID = "0000fe59-0000-1000-8000-00805f9b34fb"
    private static let BATTERY_SERVICE_UUID = "0000180f-0000-1000-8000-00805f9b34fb"
    private static let BATTERY_LEVEL_UUID = "00002a19-0000-1000-8000-00805f9b34fb"
    private static let BADGE_ID_UUID = "59D9"
    
    static let BLE_GENERAL_SERVICE_UUID = CBUUID(string: GENERAL_SERVICE_UUID)
    static let BLE_BATTERY_SERVICE_UUID = CBUUID(string: BATTERY_SERVICE_UUID)
    static let BLE_BATTERY_LEVEL_UUID = CBUUID(string: BATTERY_LEVEL_UUID)
    static let BLE_BAGE_ID_UUID = CBUUID(string: BADGE_ID_UUID)
    
    private static let STSAFE_UNLOCK = "554e4c4f434b2034373445353335343532353535333534353334353433353535323439353435390a"
    static let BLE_STSAFE_UNLOCK = CBUUID(string: STSAFE_UNLOCK)
    
    static var attributes: [String: String] = [:]
    
    static var batteryCharacteristic: CBCharacteristic!
    
    static func lookup(uuid: String, defaultName: String) -> String {
        
        attributes.removeAll()
        attributes[SampleGattAttributes.GENERAL_SERVICE_UUID] = "General Service UUID"
        attributes[SampleGattAttributes.DFU_SERVICE_UUID] = "DFU Service UUID"
        attributes[SampleGattAttributes.BATTERY_SERVICE_UUID] = "Battery Service UUID"
        attributes["00002a19"] = "Battery Status Characteristic UUID"
        attributes["000059db"] = "Enroll characteristic UUID"
        attributes["000059de"] = "Enroll Feedback characteristic UUID"
        attributes["000059d9"] = "Badge ID Characteristic UUID"
        
        var values: [String] = []
        for (key, value) in attributes {
            if key.lowercased() == uuid.lowercased() || key.lowercased().contains(uuid.lowercased()) {
                values.append(value)
            }
        }
        if !values.isEmpty {
            return values.first ?? ""
        } else {
            return defaultName
        }
    }
}
