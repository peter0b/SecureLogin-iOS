//
//  BadgeIdentifiersViewController+Delegates.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 10/10/2022.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit

extension BadgeIdentifiersViewController: BadgeIdentifiersViewProtocol {
    
    func displayBadgeIdentifier(_ id: String) {
        _badgeIdentifierLabel.text = id
    }
}