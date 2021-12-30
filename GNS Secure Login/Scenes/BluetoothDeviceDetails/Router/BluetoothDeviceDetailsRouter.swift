//
//  BluetoothDeviceDetailsRouter.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 22/08/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit
import CoreBluetooth

// MARK: BluetoothDeviceDetails Router -

class BluetoothDeviceDetailsRouter: BaseRouter, BluetoothDeviceDetailsRouterProtocol {
    
    static func createModule(withBluetooth ble: CBPeripheral, rssi: NSNumber, bluetoothType: BluetoothType) -> UIViewController {
        let view =  BluetoothDeviceDetailsViewController()
        view.ble = ble
        view.rssi = rssi
        view.bluetoothType = bluetoothType
        let interactor = BluetoothDeviceDetailsInteractor()
        let router = BluetoothDeviceDetailsRouter()
        let presenter = BluetoothDeviceDetailsPresenter(view: view, interactor: interactor, router: router, ble: ble, bluetoothType: bluetoothType)
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }

    func navigateToFingerprintEnrollmentViewController(withBluetoothDevice ble: CBPeripheral) {
        let fingerprintEnrollmentViewController = FingerprintEnrollmentRouter.createModule(withBluetooth: ble)
        viewController?.navigationController?.pushViewController(fingerprintEnrollmentViewController, animated: true)
    }
    
    func navigateToFormatBadgeViewController() {
        let formatBadgeViewController = FormatBadgeRouter.createModule()
        viewController?.navigationController?.pushViewController(formatBadgeViewController, animated: true)
    }
}
