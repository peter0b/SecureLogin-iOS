//
//  DeviceFirmwareUpdatePresenter.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 30/12/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation

// MARK: DeviceFirmwareUpdate Presenter -

class DeviceFirmwareUpdatePresenter: BasePresenter {

    weak var view: DeviceFirmwareUpdateViewProtocol?
    private let interactor: DeviceFirmwareUpdateInteractorInputProtocol
    private let router: DeviceFirmwareUpdateRouterProtocol
    
    init(view: DeviceFirmwareUpdateViewProtocol, interactor: DeviceFirmwareUpdateInteractorInputProtocol, router: DeviceFirmwareUpdateRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - DeviceFirmwareUpdatePresenterProtocol
extension DeviceFirmwareUpdatePresenter: DeviceFirmwareUpdatePresenterProtocol {
    
    func viewDidLoad() {
        
    }
}

// MARK: - API
extension DeviceFirmwareUpdatePresenter: DeviceFirmwareUpdateInteractorOutputProtocol {
    
}

// MARK: - Selectors
extension DeviceFirmwareUpdatePresenter {
    
    func performBack() {
        router.popupViewController()
    }
}
