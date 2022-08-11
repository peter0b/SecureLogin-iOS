//
//  DeviceFirmwareUpdateProtocols.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 30/12/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation

// MARK: DeviceFirmwareUpdate Protocols

protocol DeviceFirmwareUpdateViewProtocol: BaseViewProtocol {
    var presenter: DeviceFirmwareUpdatePresenterProtocol! { get set }
    
}

protocol DeviceFirmwareUpdatePresenterProtocol: BasePresenterProtocol {
    var view: DeviceFirmwareUpdateViewProtocol? { get set }
    
    func viewDidLoad()

    func performBack()
}

protocol DeviceFirmwareUpdateRouterProtocol: BaseRouterProtocol {
    
}

protocol DeviceFirmwareUpdateInteractorInputProtocol: BaseInteractorInputProtocol {
    var presenter: DeviceFirmwareUpdateInteractorOutputProtocol? { get set }
    
}

protocol DeviceFirmwareUpdateInteractorOutputProtocol: BaseInteractorOutputProtocol {
    
}
