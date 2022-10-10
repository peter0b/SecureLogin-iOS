//
//  BadgeIdentifiersProtocols.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 10/10/2022.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation

// MARK: BadgeIdentifiers Protocols

protocol BadgeIdentifiersViewProtocol: BaseViewProtocol {
    var presenter: BadgeIdentifiersPresenterProtocol! { get set }
    func displayBadgeIdentifier(_ id: String)
}

protocol BadgeIdentifiersPresenterProtocol: BasePresenterProtocol {
    var view: BadgeIdentifiersViewProtocol? { get set }
    
    func viewDidLoad()

    func performBack()
    func performCopy()
}

protocol BadgeIdentifiersRouterProtocol: BaseRouterProtocol {
    
}

protocol BadgeIdentifiersInteractorInputProtocol: BaseInteractorInputProtocol {
    var presenter: BadgeIdentifiersInteractorOutputProtocol? { get set }
    
}

protocol BadgeIdentifiersInteractorOutputProtocol: BaseInteractorOutputProtocol {
    
}
