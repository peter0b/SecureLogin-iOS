//
//  EditApplicationCredentialsPresenter.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 27/12/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation

// MARK: EditApplicationCredentials Presenter -

class EditApplicationCredentialsPresenter: BasePresenter {

    weak var view: EditApplicationCredentialsViewProtocol?
    private let interactor: EditApplicationCredentialsInteractorInputProtocol
    private let router: EditApplicationCredentialsRouterProtocol
    private let application: SitesInfo
    
    init(view: EditApplicationCredentialsViewProtocol, interactor: EditApplicationCredentialsInteractorInputProtocol, router: EditApplicationCredentialsRouterProtocol, application: SitesInfo) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.application = application
    }
}

// MARK: - EditApplicationCredentialsPresenterProtocol
extension EditApplicationCredentialsPresenter: EditApplicationCredentialsPresenterProtocol {
    
    func viewDidLoad() {
        let logoString = application.logo ?? ""
        guard let logoURL = URL(string: logoString.removeWhitespace()) else { return }
        view?.displayApplicationImage(fromImageURL: logoURL)
    }
    
    func performValidate(username: String?, password: String?) {
        let validateInputs = username?.isEmpty == false && password?.isEmpty == false
        validateInputs ? view?.enableSaveButton() : view?.disableSaveButton()
    }
}

// MARK: - API
extension EditApplicationCredentialsPresenter: EditApplicationCredentialsInteractorOutputProtocol {
    
}

// MARK: - Selectors
extension EditApplicationCredentialsPresenter {
    
    func performBack() {
        router.popupViewController()
    }
    
    func performSave(username: String?, password: String?) {
        let sites: [SiteVM] = [application].map { SiteVM(code: $0.siteCode, username: username, password: password, writeDone: false) }
        view?.writeApplicationCredentials(sites: sites)
    }
}
