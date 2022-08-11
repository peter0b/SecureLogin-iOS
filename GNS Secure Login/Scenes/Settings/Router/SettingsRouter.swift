//
//  SettingsRouter.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 25/07/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit
import CoreBluetooth

// MARK: Settings Router -

class SettingsRouter: BaseRouter, SettingsRouterProtocol {
    
    static func createModule(withSavedReader reader: CBPeripheral?) -> UIViewController {
        let view =  SettingsViewController()
        view.savedReader = reader

        let interactor = SettingsInteractor()
        let router = SettingsRouter()
        let presenter = SettingsPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }
    
    func navigateToBluetoothDeviceDetails(withBluetooth ble: CBPeripheral, rssi: NSNumber, bluetoothType: BluetoothType) {
        let bluetoothDeviceDetailsViewController = BluetoothDeviceDetailsRouter.createModule(withBluetooth: ble, rssi: rssi, bluetoothType: bluetoothType)
        
        viewController?.navigationController?.pushViewController(bluetoothDeviceDetailsViewController, animated: true)
    }
}
