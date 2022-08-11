//
//  EditApplicationCredentialsProtocols.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 27/12/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation

// MARK: EditApplicationCredentials Protocols

protocol EditApplicationCredentialsViewProtocol: BaseViewProtocol {
    var presenter: EditApplicationCredentialsPresenterProtocol! { get set }
    
    func displayApplicationImage(fromImageURL imageUrl: URL)
    func enableSaveButton()
    func disableSaveButton()
    
    func writeApplicationCredentials(sites: [SiteVM])
}

protocol EditApplicationCredentialsPresenterProtocol: BasePresenterProtocol {
    var view: EditApplicationCredentialsViewProtocol? { get set }
    
    func viewDidLoad()
    func performValidate(username: String?, password: String?)

    func performBack()
    func performSave(username: String?, password: String?)
}

protocol EditApplicationCredentialsRouterProtocol: BaseRouterProtocol {
    
}

protocol EditApplicationCredentialsInteractorInputProtocol: BaseInteractorInputProtocol {
    var presenter: EditApplicationCredentialsInteractorOutputProtocol? { get set }
    
}

protocol EditApplicationCredentialsInteractorOutputProtocol: BaseInteractorOutputProtocol {
    
}
