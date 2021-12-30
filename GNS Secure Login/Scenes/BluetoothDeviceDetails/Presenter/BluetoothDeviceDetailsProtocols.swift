//
//  BluetoothDeviceDetailsProtocols.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 22/08/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation
import CoreBluetooth

// MARK: BluetoothDeviceDetails Protocols

protocol BluetoothDeviceDetailsViewProtocol: BaseViewProtocol {
    var presenter: BluetoothDeviceDetailsPresenterProtocol! { get set }
    
}

protocol BluetoothDeviceDetailsPresenterProtocol: BasePresenterProtocol {
    var view: BluetoothDeviceDetailsViewProtocol? { get set }
    
    func viewDidLoad()
    
    func performBack()
    func didSelectActionItem(withBluetoothDevice ble: CBPeripheral, bluetoothType: BluetoothType, index: Int)
}


protocol BluetoothDeviceDetailsRouterProtocol: BaseRouterProtocol {
    func navigateToFingerprintEnrollmentViewController(withBluetoothDevice ble: CBPeripheral)
    func navigateToFormatBadgeViewController()
}

protocol BluetoothDeviceDetailsInteractorInputProtocol: BaseInteractorInputProtocol {
    var presenter: BluetoothDeviceDetailsInteractorOutputProtocol? { get set }
    
}

protocol BluetoothDeviceDetailsInteractorOutputProtocol: BaseInteractorOutputProtocol {
    
    
}
