//
//  EmergencyContactsProtocols.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 25/07/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation

// MARK: EmergencyContacts Protocols

protocol EmergencyContactsViewProtocol: BaseViewProtocol {
    var presenter: EmergencyContactsPresenterProtocol! { get set }
    
}

protocol EmergencyContactsPresenterProtocol: BasePresenterProtocol {
    var view: EmergencyContactsViewProtocol? { get set }
    
    func viewDidLoad()

}

protocol EmergencyContactsRouterProtocol: BaseRouterProtocol {
    
}

protocol EmergencyContactsInteractorInputProtocol: BaseInteractorInputProtocol {
    var presenter: EmergencyContactsInteractorOutputProtocol? { get set }
    
}

protocol EmergencyContactsInteractorOutputProtocol: BaseInteractorOutputProtocol {
    
    
}
