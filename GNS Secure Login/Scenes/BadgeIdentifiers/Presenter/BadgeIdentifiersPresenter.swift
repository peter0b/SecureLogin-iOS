//
//  BadgeIdentifiersPresenter.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 10/10/2022.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation
import UIKit

// MARK: BadgeIdentifiers Presenter -

class BadgeIdentifiersPresenter: BasePresenter {

    weak var view: BadgeIdentifiersViewProtocol?
    private let interactor: BadgeIdentifiersInteractorInputProtocol
    private let router: BadgeIdentifiersRouterProtocol
    private let badgeIdentifier: String
    
    init(view: BadgeIdentifiersViewProtocol, interactor: BadgeIdentifiersInteractorInputProtocol, router: BadgeIdentifiersRouterProtocol, badgeIdentifier: String) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.badgeIdentifier = badgeIdentifier
    }
}

// MARK: - BadgeIdentifiersPresenterProtocol
extension BadgeIdentifiersPresenter: BadgeIdentifiersPresenterProtocol {
    
    func viewDidLoad() {
        view?.displayBadgeIdentifier(badgeIdentifier)
    }
}

// MARK: - API
extension BadgeIdentifiersPresenter: BadgeIdentifiersInteractorOutputProtocol {
    
}

// MARK: - Selectors
extension BadgeIdentifiersPresenter {
    func performBack() {
        router.popupViewController()
    }
    
    func performCopy() {
        let badgeId = badgeIdentifier.components(separatedBy: ": ").last
        let copyText = badgeId ?? "UNKNOWN ID"
        UIPasteboard.general.string = copyText
    }
}
