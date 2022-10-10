//
//  BadgeIdentifiersViewController.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 10/10/2022.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit

final class BadgeIdentifiersViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet private weak var badgeIdentifierLabel: SRCopyableLabel!
    
    // MARK: - Variables
	var presenter: BadgeIdentifiersPresenterProtocol!
    
    var _badgeIdentifierLabel: SRCopyableLabel {
        return badgeIdentifierLabel
    }

    // MARK: - Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        presenter.viewDidLoad()
    }
}

// MARK: - Helpers
extension BadgeIdentifiersViewController {
    
}

// MARK: - Selectors
extension BadgeIdentifiersViewController {
    @IBAction
    private func backButtonDidPressed(_ sender: UIButton) {
        presenter.performBack()
    }
    
    @IBAction
    private func copyButtonDidPressed(_ sender: UIButton) {
        presenter.performCopy()
    }
}
