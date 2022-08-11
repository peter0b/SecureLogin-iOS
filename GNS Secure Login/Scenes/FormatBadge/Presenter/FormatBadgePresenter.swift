//
//  FormatBadgePresenter.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 25/07/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation

// MARK: FormatBadge Presenter -

class FormatBadgePresenter: BasePresenter {

    weak var view: FormatBadgeViewProtocol?
    private let interactor: FormatBadgeInteractorInputProtocol
    private let router: FormatBadgeRouterProtocol
    
    init(view: FormatBadgeViewProtocol, interactor: FormatBadgeInteractorInputProtocol, router: FormatBadgeRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - FormatBadgePresenterProtocol
extension FormatBadgePresenter: FormatBadgePresenterProtocol {
    
    func viewDidLoad() {
        
    }
}

// MARK: - API
extension FormatBadgePresenter: FormatBadgeInteractorOutputProtocol {
    
}

// MARK: - API
extension FormatBadgePresenter {
    
    func performBack() {
        router.popupViewController()
    }
}
