//
//  ScanBadgeProtocols.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 25/07/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation

// MARK: ScanBadge Protocols

protocol ScanBadgeViewProtocol: BaseViewProtocol {
    var presenter: ScanBadgePresenterProtocol! { get set }
    
}

protocol ScanBadgePresenterProtocol: BasePresenterProtocol {
    var view: ScanBadgeViewProtocol? { get set }
    
    func viewDidLoad()

    func performBack()
    func performNext()
}

protocol ScanBadgeRouterProtocol: BaseRouterProtocol {
    func navigateToApplicationListViewController()
}

protocol ScanBadgeInteractorInputProtocol: BaseInteractorInputProtocol {
    var presenter: ScanBadgeInteractorOutputProtocol? { get set }
    
}

protocol ScanBadgeInteractorOutputProtocol: BaseInteractorOutputProtocol {
    
    
}
