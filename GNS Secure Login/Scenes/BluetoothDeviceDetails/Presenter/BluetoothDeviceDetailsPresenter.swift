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
    
    private var badgeSerial: String?
    private var firstEnrollment: Bool!
    private var enrollAlertType: EnrollAlertType!
    
    init(view: BluetoothDeviceDetailsViewProtocol, interactor: BluetoothDeviceDetailsInteractorInputProtocol, router: BluetoothDeviceDetailsRouterProtocol, ble: CBPeripheral, bluetoothType: BluetoothType) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.ble = ble
        self.bluetoothType = bluetoothType
    }
    
    func titleForUUID(_ uuid:CBUUID) -> String {
        var title = uuid.description
        if (title.hasPrefix("Unknown")) {
            title = uuid.uuidString
        }
        return title
    }
}

// MARK: - BluetoothDeviceDetailsPresenterProtocol
extension BluetoothDeviceDetailsPresenter: BluetoothDeviceDetailsPresenterProtocol {
    
    func viewDidLoad() {
        NotificationCenter.default.addObserver(forName: .BadgeIdValue, object: nil, queue: .main) { [weak self] notification in
            let badgeId = notification.userInfo?["badgeId"] as? String
            self?.badgeSerial = badgeId
        }
    }
}

// MARK: - API
extension BluetoothDeviceDetailsPresenter: BluetoothDeviceDetailsInteractorOutputProtocol {
    func fetchingCheckBadgeEnrollmentCountSuccessfully(_ count: Int) {
        print("First Enrollment:", count == 0)
        firstEnrollment = count == 0
        view?.hideLoading()
        router.presentEnrollmentAlertViewController(enrollAlertType: count == 0 ? .validateOTP : .validatPIN, badgeSerial: badgeSerial) { [unowned self] enrollAlertType in
            self.enrollAlertType = enrollAlertType
            BluetoothManager.startEnrollment = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.router.navigateToFingerprintEnrollmentViewController(withBluetoothDevice: self.ble, enrollAlertType: self.enrollAlertType, badgeSerial: self.badgeSerial ?? "", firstEnrollment: self.firstEnrollment)
            }
        }
    }
    
    func fetchingUpdateEnrollmentCountSuccessfully() {
        print("Incremented!")
    }
    
    func fetchingCheckBadeEnrollmentCountWithError(_ error: String) {
        view?.hideLoading()
        router.presentAlertControl(title: "", message: error, actionTitle: "Okay", action: nil)
    }
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
                view?.showLoading()
                let params = GetApplicationsList(
                    commandType: AuthCommandType.checkEnrollmentCount.rawValue,
                    gnsLicense: GlobalConstants.gnsLicense.rawValue,
                    cardUID:  nil,
                    badgeSerial: badgeSerial,
                    metaData: nil
                )
                interactor.getCheckEnrollmentCount(params: params)
                
//                router.navigateToFingerprintEnrollmentViewController(withBluetoothDevice: ble)
            case .formatBadge: router.navigateToFormatBadgeViewController()
            case .updateBadge: router.navigateToUpdateBadgeViewController(dfuPeripheral: ble)
            case .readBadgeIds:
                ble.discoverServices([SampleGattAttributes.BLE_GENERAL_SERVICE_UUID])
                ble.delegate = self
            }
        case .readers:
            switch ReaderActions.allCases[index] {
            case .formatBadge:
                router.navigateToFormatBadgeViewController()
            case .readBadgeIds:
                let bluetoothManager = BluetoothManager.getInstance()
                let cardChannel = bluetoothManager.getChardChannel()
                if cardChannel != nil {
                    print("Trying to read badge ids...")
                    
                    let mifareDesfireHelper = MiFareDesfireHelper(card: cardChannel!.card, mifareNFCCardManager: ApduCommandExecuter())
                    mifareDesfireHelper.getUid { [weak self] response, error in
                        if let error = error {
                            print("Failed to get badge NFC ID", error)
                            return
                        }
                        let nfcCardUID = MifareUtils.toHexString(buffer: response!.responseData).removeWhitespace()
                        print("nfcCardUID:", nfcCardUID)
                        self?.router.naviagateToBadgeIdentifiersViewController(withIdentifier: "NFC ID: \(nfcCardUID)")
                    }
                } else {
                    view?.showBottomMessage("Please insert card to format.")
                }
            }
        }
    }
}

extension BluetoothDeviceDetailsPresenter: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Failed to discover services:", error)
            return
        }
        let services = peripheral.services ?? []
        services.forEach { service in
            if titleForUUID(service.uuid).lowercased().contains(SampleGattAttributes.BLE_GENERAL_SERVICE_UUID.uuidString.lowercased()) {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if SampleGattAttributes.BLE_GENERAL_SERVICE_UUID.uuidString.contains(service.uuid.uuidString) {
            let characteristics = service.characteristics ?? []
            characteristics.forEach {
                if $0.uuid.isEqual(SampleGattAttributes.BLE_BAGE_ID_UUID) {
                    peripheral.readValue(for: $0)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if SampleGattAttributes.BLE_BAGE_ID_UUID.isEqual(characteristic.uuid) {
            if let value = characteristic.value {
                    let badgeId = value.hexString //"215950110018246"
                    // TODO: add ids viewcontroller
                    
                router.naviagateToBadgeIdentifiersViewController(withIdentifier: "BLE-ID: \(badgeId)")
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        
    }
}
