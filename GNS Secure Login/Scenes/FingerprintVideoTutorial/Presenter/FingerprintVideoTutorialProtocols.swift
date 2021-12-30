//
//  FingerprintVideoTutorialProtocols.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 29/08/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation

// MARK: FingerprintVideoTutorial Protocols

protocol FingerprintVideoTutorialViewProtocol: BaseViewProtocol {
    var presenter: FingerprintVideoTutorialPresenterProtocol! { get set }
    
}

protocol FingerprintVideoTutorialPresenterProtocol: BasePresenterProtocol {
    var view: FingerprintVideoTutorialViewProtocol? { get set }
    
    func viewDidLoad()
    
    func performDismiss()
}

protocol FingerprintVideoTutorialRouterProtocol: BaseRouterProtocol {
    
}

protocol FingerprintVideoTutorialInteractorInputProtocol: BaseInteractorInputProtocol {
    var presenter: FingerprintVideoTutorialInteractorOutputProtocol? { get set }
    
}

protocol FingerprintVideoTutorialInteractorOutputProtocol: BaseInteractorOutputProtocol {
    
}
