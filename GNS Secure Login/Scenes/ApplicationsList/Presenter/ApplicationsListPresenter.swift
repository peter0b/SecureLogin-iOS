//
//  ApplicationsListPresenter.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 02/08/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation
import CoreBluetooth
import SmartCardIO

// MARK: ApplicationsList Presenter -

class ApplicationsListPresenter: BasePresenter {

    weak var view: ApplicationsListViewProtocol?
    private let interactor: ApplicationsListInteractorInputProtocol
    private let router: ApplicationsListRouterProtocol
    
    private var isSearching = false
    private var applications: [SitesInfo] = []
    private var filteredApplications: [SitesInfo] = []
    
    init(view: ApplicationsListViewProtocol, interactor: ApplicationsListInteractorInputProtocol, router: ApplicationsListRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    
    
}

// MARK: - ApplicationsListPresenterProtocol
extension ApplicationsListPresenter: ApplicationsListPresenterProtocol {
    
    func viewDidLoad() {
        
    }
    
    func getApplicationsList(withCardUID cardUID: String) {
        view?.showLoading()
//        let params = GetApplicationsList(
//            commandType: AuthCommandType.LoadingUserGNSSites.rawValue,
//            gnsLicense: "1PJYSP5-1VEF1E0-6Z4HVC-1VE83VG",
//            cardUID: cardUID
//        )
        let params = GetApplicationsList(
            commandType: AuthCommandType.LoadingUserGNSSites.rawValue,
            gnsLicense: GlobalConstants.gnsLicense.rawValue,
            cardUID: cardUID,
            badgeSerial: nil,
            metaData: nil
        )
        interactor.getApplications(withParams: params)
    }
    
    func performHideLoading() {
        view?.hideLoading()
    }
}

// MARK: - API
extension ApplicationsListPresenter: ApplicationsListInteractorOutputProtocol {
    
    func fetchingApplicationsSuccessfully(_ applications: [SitesInfo]) {
        self.applications = applications
        view?.refreshViewController()
        let sitesCodes = applications.map { $0.siteCode ?? "" }
        view?.saveSitesCodesToCard(sitesCodes)
        view?.hideLoading()
    }
    
    func fetchingApplicationsWithError(_ error: Error) {
        view?.hideLoading()
        print(error)
    }
}

// MARK: - Search
extension ApplicationsListPresenter {
    
    func updateIsSearching(_ isSearching: Bool) {
        self.isSearching = isSearching
    }
    
    func searchApplications(withSearchText searchText: String) {
        if searchText == "" {
            filteredApplications = applications
        } else {
            filteredApplications = applications.filter { ($0.name ?? "").lowercased().contains(searchText.lowercased()) }
        }
        view?.refreshViewController()
    }
}


// MARK: - Selectors
extension ApplicationsListPresenter {
    
    func performBack() {
        router.popupViewController()
    }
    
    func performSort() {
        applications = applications.sorted(by: { ($0.name ?? "").lowercased() < ($1.name ?? "").lowercased() })
        view?.refreshViewController()
    }
}

// MARK: - CollectionView
extension ApplicationsListPresenter {
    
    var applicationsCount: Int {
        return isSearching ? filteredApplications.count : applications.count
    }
    
    func configureApplicationItemCell(_ cell: ApplicationItemCollectionViewCellProtocol, atIndex index: Int, isGrid: Bool) {
        let application = isSearching ? filteredApplications[index] : applications[index]
        
        if isGrid {
            cell.updateContainerViewLeadingConstraintForGrid()
            cell.showApplicationNameLabel()
            cell.hideApplicaionImageView()
            cell.displayApplicationName(application.name?.capitalizingFirstLetter() ?? "")
        } else {
            cell.updateContainerViewLeadingConstraintForNonGrid()
            cell.hideApplicationNameLabel()
            cell.showApplicaionImageView()
            let logoString = application.logo ?? ""
            guard let logoURL = URL(string: logoString.removeWhitespace()) else { return }
//            print("logoURL \(index):", logoURL)
            cell.displayApplicationImage(fromImageURL: logoURL)
        }
    }
    
    func didSelectApplication(atIndex index: Int) {
        let application = isSearching ? filteredApplications[index] : applications[index]
        print(application)
        
//        let sites: [SiteVM] = [application].map { SiteVM(code: $0.siteCode, username: "", password: "", writeDone: false) }
//        view?.readApplicationCredentials(sites: sites)
        
        
        var url = application.loginUrl ?? ""
        if !url.contains("https") {
            url = "https://\(url)"
        }
        
//        print(url)
//        router.openURL(withUrl: url.removeWhitespace(), javascript: application.script ?? "")
        print(application.script ?? "")
//        view?.showWebPage(withUrl: url.removeWhitespace(), javascript: application.script ?? "")
    }
    
    func didEditApplication(atIndex index: Int, card: Card, mifareDesfireHelper: MiFareDesfireHelper) {
        let application = isSearching ? filteredApplications[index] : applications[index]
        let sites: [SiteVM] = [application].map { SiteVM(code: $0.siteCode, username: "", password: "", writeDone: false) }
        router.navigateToEditApplicationCredentialsViewController(card: card, mifareDesfireHelper: mifareDesfireHelper, application: application, sites: sites)
    }
}
