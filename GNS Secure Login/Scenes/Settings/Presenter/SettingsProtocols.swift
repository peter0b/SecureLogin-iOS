//
//  SettingsProtocols.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 25/07/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation
import CoreBluetooth

// MARK: Settings Protocols

protocol SettingsViewProtocol: BaseViewProtocol {
    var presenter: SettingsPresenterProtocol! { get set }
    
}

protocol SettingsPresenterProtocol: BasePresenterProtocol {
    var view: SettingsViewProtocol? { get set }
    
    func viewDidLoad()

    func performBack()
    func showBluetoothDeviceDetailsViewController(withBluetooth ble: CBPeripheral, rssi: NSNumber, bluetoothType: BluetoothType)
}

protocol SettingsRouterProtocol: BaseRouterProtocol {
    func navigateToBluetoothDeviceDetails(withBluetooth ble: CBPeripheral, rssi: NSNumber, bluetoothType: BluetoothType)
}

protocol SettingsInteractorInputProtocol: BaseInteractorInputProtocol {
    var presenter: SettingsInteractorOutputProtocol? { get set }
    
}

protocol SettingsInteractorOutputProtocol: BaseInteractorOutputProtocol {
    
    
}
