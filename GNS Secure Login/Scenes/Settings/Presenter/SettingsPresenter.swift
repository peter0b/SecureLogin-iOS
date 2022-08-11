//
//  SettingsPresenter.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 25/07/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation
import CoreBluetooth

// MARK: Settings Presenter -

class SettingsPresenter: BasePresenter {

    weak var view: SettingsViewProtocol?
    private let interactor: SettingsInteractorInputProtocol
    private let router: SettingsRouterProtocol
    
    init(view: SettingsViewProtocol, interactor: SettingsInteractorInputProtocol, router: SettingsRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - SettingsPresenterProtocol
extension SettingsPresenter: SettingsPresenterProtocol {
    
    func viewDidLoad() {
        
    }
}

// MARK: - API
extension SettingsPresenter: SettingsInteractorOutputProtocol {
    
}

// MARK: - Selectors
extension SettingsPresenter {
    
    func performBack() {
        router.popupViewController()
    }
    
    func showBluetoothDeviceDetailsViewController(withBluetooth ble: CBPeripheral, rssi: NSNumber, bluetoothType: BluetoothType) {
        router.navigateToBluetoothDeviceDetails(withBluetooth: ble, rssi: rssi, bluetoothType: bluetoothType)
    }
}
