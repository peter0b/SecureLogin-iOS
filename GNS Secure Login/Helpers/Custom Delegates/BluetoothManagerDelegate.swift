//
//  BluetoothManagerDelegate.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 28/07/2021.
//

import Foundation
import SmartCardIO
import ACSSmartCardIO

class BluetoothManagerDelegate: BluetoothTerminalManagerDelegate {
    
    func bluetoothTerminalManagerDidUpdateState(_ manager: BluetoothTerminalManager) {
        print(manager.centralManager.state.rawValue)
    }
    
    func bluetoothTerminalManager(_ manager: BluetoothTerminalManager, didDiscover terminal: CardTerminal) {
        print(terminal)
    }
}
