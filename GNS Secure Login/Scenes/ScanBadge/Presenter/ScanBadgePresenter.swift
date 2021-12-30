//
//  ScanBadgePresenter.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 25/07/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation

// MARK: ScanBadge Presenter -

class ScanBadgePresenter: BasePresenter {

    weak var view: ScanBadgeViewProtocol?
    private let interactor: ScanBadgeInteractorInputProtocol
    private let router: ScanBadgeRouterProtocol
    
    init(view: ScanBadgeViewProtocol, interactor: ScanBadgeInteractorInputProtocol, router: ScanBadgeRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ScanBadgePresenterProtocol
extension ScanBadgePresenter: ScanBadgePresenterProtocol {
    
    func viewDidLoad() {
        
    }
}

// MARK: - API
extension ScanBadgePresenter: ScanBadgeInteractorOutputProtocol {
    
}

// MARK: - Selector
extension ScanBadgePresenter {
    
    func performBack() {
        router.popoupToSplitRootViewViewController()
    }
    
    func performNext() {
        router.navigateToApplicationListViewController()
    }
}
