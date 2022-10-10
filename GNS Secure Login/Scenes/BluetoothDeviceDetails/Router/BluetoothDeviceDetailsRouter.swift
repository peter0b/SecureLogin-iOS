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
        let interactor = BluetoothDeviceDetailsInteractor(
            useCase: ApplicationsListUseCase(
                applicationsListRepository: ApplicationsListRepositryImp()
            )
        )
        let router = BluetoothDeviceDetailsRouter()
        let presenter = BluetoothDeviceDetailsPresenter(view: view, interactor: interactor, router: router, ble: ble, bluetoothType: bluetoothType)
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }
    
    func presentEnrollmentAlertViewController(enrollAlertType: EnrollAlertType, badgeSerial: String?, completionAction: @escaping EnrollAlertCompletion) {
        let enrollmentAlertViewController = EnrollmentAlertRouter.createModule(enrollAlertType: enrollAlertType, badgeSerial: badgeSerial, completionAction: completionAction)
        enrollmentAlertViewController.modalPresentationStyle = .overFullScreen
        enrollmentAlertViewController.modalTransitionStyle = .crossDissolve
        viewController?.present(enrollmentAlertViewController, animated: true)
    }

    func navigateToFingerprintEnrollmentViewController(withBluetoothDevice ble: CBPeripheral, enrollAlertType: EnrollAlertType, badgeSerial: String, firstEnrollment: Bool) {
        let fingerprintEnrollmentViewController = FingerprintEnrollmentRouter.createModule(withBluetooth: ble, enrollAlertType: enrollAlertType, badgeSerial: badgeSerial, firstEnrollment: firstEnrollment)
        viewController?.navigationController?.pushViewController(fingerprintEnrollmentViewController, animated: true)
    }
    
    func navigateToFormatBadgeViewController() {
        let formatBadgeViewController = FormatBadgeRouter.createModule()
        viewController?.navigationController?.pushViewController(formatBadgeViewController, animated: true)
    }
    
    func navigateToUpdateBadgeViewController(dfuPeripheral: CBPeripheral) {
        let updateBadgeViewController = DeviceFirmwareUpdateRouter.createModule(dfuPeripheral: dfuPeripheral)
        viewController?.navigationController?.pushViewController(updateBadgeViewController, animated: true)
    }
    
    func naviagateToBadgeIdentifiersViewController(withIdentifier identifier: String) {
        let badgeIdentifiersViewController = BadgeIdentifiersRouter.createModule(badgeIdentifier: identifier)
        viewController?.navigationController?.pushViewController(badgeIdentifiersViewController, animated: true)
    }
}
