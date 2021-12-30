//
//  BluetoothDeviceDetailsPresenter.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 22/08/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation
import CoreBluetooth

// MARK: BluetoothDeviceDetails Presenter -

class BluetoothDeviceDetailsPresenter: BasePresenter {

    weak var view: BluetoothDeviceDetailsViewProtocol?
    private let interactor: BluetoothDeviceDetailsInteractorInputProtocol
    private let router: BluetoothDeviceDetailsRouterProtocol
    private let ble: CBPeripheral
    private let bluetoothType: BluetoothType
    
    init(view: BluetoothDeviceDetailsViewProtocol, interactor: BluetoothDeviceDetailsInteractorInputProtocol, router: BluetoothDeviceDetailsRouterProtocol, ble: CBPeripheral, bluetoothType: BluetoothType) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.ble = ble
        self.bluetoothType = bluetoothType
    }
}

// MARK: - BluetoothDeviceDetailsPresenterProtocol
extension BluetoothDeviceDetailsPresenter: BluetoothDeviceDetailsPresenterProtocol {
    
    func viewDidLoad() {
        
    }
}

// MARK: - API
extension BluetoothDeviceDetailsPresenter: BluetoothDeviceDetailsInteractorOutputProtocol {
    
}

// MARK: - Selectors
extension BluetoothDeviceDetailsPresenter {
    
    func performBack() {
        router.popupViewController()
    }
    
    func didSelectActionItem(withBluetoothDevice ble: CBPeripheral, bluetoothType: BluetoothType, index: Int) {
        switch bluetoothType {
        case .badges:
            switch BadgeActions.allCases[index] {
            case .fingerprintEnrollment:
                router.navigateToFingerprintEnrollmentViewController(withBluetoothDevice: ble)
            case.formatBadge: router.navigateToFormatBadgeViewController()
            }
        case .readers: router.navigateToFormatBadgeViewController()
        }
    }
}
