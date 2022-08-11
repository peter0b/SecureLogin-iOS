//
//  DeviceFirmwareUpdateRouter.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 30/12/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit
import CoreBluetooth

// MARK: DeviceFirmwareUpdate Router -

class DeviceFirmwareUpdateRouter: BaseRouter, DeviceFirmwareUpdateRouterProtocol {
    
    static func createModule(dfuPeripheral: CBPeripheral) -> UIViewController {
        let view =  DeviceFirmwareUpdateViewController(dfuPeripheral: dfuPeripheral)

        let interactor = DeviceFirmwareUpdateInteractor()
        let router = DeviceFirmwareUpdateRouter()
        let presenter = DeviceFirmwareUpdatePresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }

}
