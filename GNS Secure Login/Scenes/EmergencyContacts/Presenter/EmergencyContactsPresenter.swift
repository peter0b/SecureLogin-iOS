//
//  EmergencyContactsPresenter.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 25/07/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation

// MARK: EmergencyContacts Presenter -

class EmergencyContactsPresenter: BasePresenter {

    weak var view: EmergencyContactsViewProtocol?
    private let interactor: EmergencyContactsInteractorInputProtocol
    private let router: EmergencyContactsRouterProtocol
    
    init(view: EmergencyContactsViewProtocol, interactor: EmergencyContactsInteractorInputProtocol, router: EmergencyContactsRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - EmergencyContactsPresenterProtocol
extension EmergencyContactsPresenter: EmergencyContactsPresenterProtocol {
    
    func viewDidLoad() {
        
    }
}

// MARK: - API
extension EmergencyContactsPresenter: EmergencyContactsInteractorOutputProtocol {
    
}
