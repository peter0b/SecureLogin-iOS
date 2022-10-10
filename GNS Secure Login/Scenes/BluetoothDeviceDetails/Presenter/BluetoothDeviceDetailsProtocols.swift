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
    func presentEnrollmentAlertViewController(enrollAlertType: EnrollAlertType, badgeSerial: String?, completionAction: @escaping EnrollAlertCompletion)
    func navigateToFingerprintEnrollmentViewController(withBluetoothDevice ble: CBPeripheral, enrollAlertType: EnrollAlertType, badgeSerial: String, firstEnrollment: Bool)
    func navigateToFormatBadgeViewController()
    func navigateToUpdateBadgeViewController(dfuPeripheral: CBPeripheral)
    func naviagateToBadgeIdentifiersViewController(withIdentifier identifier: String)
}

protocol BluetoothDeviceDetailsInteractorInputProtocol: BaseInteractorInputProtocol {
    var presenter: BluetoothDeviceDetailsInteractorOutputProtocol? { get set }
    func getCheckEnrollmentCount(params: GetApplicationsList)
}

protocol BluetoothDeviceDetailsInteractorOutputProtocol: BaseInteractorOutputProtocol {
    func fetchingCheckBadgeEnrollmentCountSuccessfully(_ count: Int)
    func fetchingUpdateEnrollmentCountSuccessfully()
    func fetchingCheckBadeEnrollmentCountWithError(_ error: String)
}
