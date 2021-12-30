//
//  ApplicationsListMetaData.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 03/08/2021.
//

import Foundation

struct ApplicationsListMetaData: Codable {
    let userName: String?
    let updated: Bool?
    let siteInfo: [SitesInfo]?
    
    enum CodingKeys: String, CodingKey {

        case userName = "UserName"
        case updated = "Updated"
        case siteInfo = "SiteInfos"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userName = try values.decodeIfPresent(String.self, forKey: .userName)
        updated = try values.decodeIfPresent(Bool.self, forKey: .updated)
        siteInfo = try values.decodeIfPresent([SitesInfo].self, forKey: .siteInfo)
    }
}
