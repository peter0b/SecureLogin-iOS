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
}

// MARK: - BluetoothDeviceDetailsPresenterProtocol
extension BluetoothDeviceDetailsPresenter: BluetoothDeviceDetailsPresenterProtocol {
    
    func viewDidLoad() {
        NotificationCenter.default.addObserver(forName: .BadgeIdValue, object: nil, queue: .main) { [unowned self] notification in
            let badgeId = notification.userInfo?["badgeId"] as? String
            self.badgeSerial = badgeId
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
            }
        case .readers: router.navigateToFormatBadgeViewController()
        }
    }
}
