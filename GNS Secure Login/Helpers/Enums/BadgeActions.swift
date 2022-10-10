//
//  BadgeActions.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 22/08/2021.
//

import Foundation

enum BadgeActions: String, CaseIterable {
    case fingerprintEnrollment = "action.fingerprintEnrollment"
    case formatBadge = "action.formatBadge"
    case updateBadge = "action.dfu"
    case readBadgeIds = "action.readBadgeIds"
}
