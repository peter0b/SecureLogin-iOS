//
//  FormatBadgeProtocols.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 25/07/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation

// MARK: FormatBadge Protocols

protocol FormatBadgeViewProtocol: BaseViewProtocol {
    var presenter: FormatBadgePresenterProtocol! { get set }
    
}

protocol FormatBadgePresenterProtocol: BasePresenterProtocol {
    var view: FormatBadgeViewProtocol? { get set }
    
    func viewDidLoad()

    func performBack()
}

protocol FormatBadgeRouterProtocol: BaseRouterProtocol {
    
}

protocol FormatBadgeInteractorInputProtocol: BaseInteractorInputProtocol {
    var presenter: FormatBadgeInteractorOutputProtocol? { get set }
    
}

protocol FormatBadgeInteractorOutputProtocol: BaseInteractorOutputProtocol {
    
    
}
