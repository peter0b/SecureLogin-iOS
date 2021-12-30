//
//  SitesInfo.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 03/08/2021.
//

import Foundation

struct SitesInfo: Codable {
    let iD: Int?
    let siteId: Int?
    let name: String?
    let logo: String?
    let loginUrl: String?
    let us: String?
    let script: String?
    let siteCode: String?
    
    enum CodingKeys: String, CodingKey {

        case iD = "ID"
        case siteId = "SiteId"
        case name = "Name"
        case logo = "Logo"
        case loginUrl = "Login_Url"
        case us = "US"
        case script = "Script"
        case siteCode = "SiteCode"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        iD = try values.decodeIfPresent(Int.self, forKey: .iD)
        siteId = try values.decodeIfPresent(Int.self, forKey: .siteId)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        logo = try values.decodeIfPresent(String.self, forKey: .logo)
        loginUrl = try values.decodeIfPresent(String.self, forKey: .loginUrl)
        us = try values.decodeIfPresent(String.self, forKey: .us)
        script = try values.decodeIfPresent(String.self, forKey: .script)
        siteCode = try values.decodeIfPresent(String.self, forKey: .siteCode)
    }
}
