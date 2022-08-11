//
//  HomeProtocols.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 22/07/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation
import CoreBluetooth

// MARK: Home Protocols

protocol HomeViewProtocol: BaseViewProtocol {
    var presenter: HomePresenterProtocol! { get set }
    
}

protocol HomePresenterProtocol: BasePresenterProtocol {
    var view: HomeViewProtocol? { get set }
    var savedNFCCard: CBPeripheral? { get set }
    
    func viewDidLoad()

    var itemsCount: Int { get }
    func configureHomeItemCell(_ cell: HomeItemTableViewCellView, atIndex index: Int)
    func didSelectHomeItem(atIndex index: Int)
}

protocol HomeRouterProtocol: BaseRouterProtocol {
    func showScanBadgeViewController(withSavedCard card: CBPeripheral?)
    func showFormatBadgeViewController()
    func showEmergencyContactsViewController()
    func showSettingsViewController(withSavedReader reader: CBPeripheral?)
}

protocol HomeInteractorInputProtocol: BaseInteractorInputProtocol {
    var presenter: HomeInteractorOutputProtocol? { get set }
    
}

protocol HomeInteractorOutputProtocol: BaseInteractorOutputProtocol {
    
    
}
