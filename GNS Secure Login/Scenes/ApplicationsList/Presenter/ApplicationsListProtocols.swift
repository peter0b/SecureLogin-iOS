//
//  ApplicationsListProtocols.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 02/08/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation
import CoreBluetooth
import SmartCardIO

// MARK: ApplicationsList Protocols

protocol ApplicationsListViewProtocol: BaseViewProtocol {
    var presenter: ApplicationsListPresenterProtocol! { get set }
    
    func refreshViewController()
    func saveSitesCodesToCard(_ sitesCodes: [String])
    
    func readApplicationCredentials(sites: [SiteVM])
    func writeApplicationCredentials(sites: [SiteVM])
    func showWebPage(withUrl urlString: String, javascript: String)
}

protocol ApplicationsListPresenterProtocol: BasePresenterProtocol {
    var view: ApplicationsListViewProtocol? { get set }
    
    func viewDidLoad()
    func getApplicationsList(withCardUID cardUID: String)
    
    func updateIsSearching(_ isSearching: Bool)
    func searchApplications(withSearchText searchText: String)
    
    var applicationsCount: Int { get }
    func configureApplicationItemCell(_ cell: ApplicationItemCollectionViewCellProtocol, atIndex index: Int, isGrid: Bool)
    func didSelectApplication(atIndex index: Int)
    func didEditApplication(atIndex index: Int, card: Card, mifareDesfireHelper: MiFareDesfireHelper)

    func performHideLoading()
    func performBack()
    func performSort()
}

protocol ApplicationsListRouterProtocol: BaseRouterProtocol {
    func openURL(withUrl urlString: String, javascript: String)
    func navigateToEditApplicationCredentialsViewController(card: Card, mifareDesfireHelper: MiFareDesfireHelper, application: SitesInfo, sites: [SiteVM])
}

protocol ApplicationsListInteractorInputProtocol: BaseInteractorInputProtocol {
    var presenter: ApplicationsListInteractorOutputProtocol? { get set }
    
    func getApplications(withParams params: GetApplicationsList)
}

protocol ApplicationsListInteractorOutputProtocol: BaseInteractorOutputProtocol {
    func fetchingApplicationsSuccessfully(_ applications: [SitesInfo])
    func fetchingApplicationsWithError(_ error: Error)
}
