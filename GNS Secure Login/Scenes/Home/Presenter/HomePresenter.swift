//
//  HomePresenter.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 22/07/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation
import CoreBluetooth

// MARK: Home Presenter -

class HomePresenter: BasePresenter {

    weak var view: HomeViewProtocol?
    private let interactor: HomeInteractorInputProtocol
    private let router: HomeRouterProtocol
    
    var savedNFCCard: CBPeripheral?
    
    init(view: HomeViewProtocol, interactor: HomeInteractorInputProtocol, router: HomeRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - HomePresenterProtocol
extension HomePresenter: HomePresenterProtocol {
    
}

// MARK: - API
extension HomePresenter: HomeInteractorOutputProtocol {
    
    func viewDidLoad() {
        
    }
}

// MARK: - Selectors
extension HomePresenter {
    
}

// MARK: - CollectionView
extension HomePresenter {
    
    var itemsCount: Int {
        return HomeItemsEnum.allCases.count
    }
    
    func configureHomeItemCell(_ cell: HomeItemTableViewCellView, atIndex index: Int) {
        cell.displayTitle(HomeItemsEnum.allCases[index].rawValue.localized())
    }
    
    func didSelectHomeItem(atIndex index: Int) {
//        print(HomeItemsEnum.allCases[index].rawValue.localized())
        switch HomeItemsEnum.allCases[index] {
        case .scanBadge:
            router.showScanBadgeViewController(withSavedCard: savedNFCCard)
//        case .formatBadge:
//            router.showFormatBadgeViewController()
//        case .emergencyContacts:
//            router.showEmergencyContactsViewController()
        case .settings:
            router.showSettingsViewController(withSavedReader: savedNFCCard)
        }
    }
}
