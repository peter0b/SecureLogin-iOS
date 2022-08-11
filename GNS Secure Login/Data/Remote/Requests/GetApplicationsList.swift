//
//  GetApplicationsList.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 03/08/2021.
//

import Foundation

struct GetApplicationsList: Codable {
    let commandType: Int?
    let gnsLicense: String?
    let cardUID: String?
    let badgeSerial: String?
    let metaData: String?
}
