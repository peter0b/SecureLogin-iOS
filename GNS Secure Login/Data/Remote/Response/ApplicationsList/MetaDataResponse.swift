//
//  MetaDataResponse.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 10/08/2022.
//

import Foundation

struct MetaDataResponse: Codable {
    let id: Int?
    let userName: String?
    let updated: Bool?
    let siteInfo: [SitesInfo]?
    let enrollmentCount: Int?
    let message: String?
    
    enum CodingKeys: String, CodingKey {

        case id = "Id"
        case userName = "UserName"
        case updated = "Updated"
        case siteInfo = "SiteInfos"
        case enrollmentCount = "EnrollmentCount"
        case message = "Message"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        userName = try values.decodeIfPresent(String.self, forKey: .userName)
        updated = try values.decodeIfPresent(Bool.self, forKey: .updated)
        siteInfo = try values.decodeIfPresent([SitesInfo].self, forKey: .siteInfo)
        enrollmentCount = try values.decodeIfPresent(Int.self, forKey: .enrollmentCount)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
}
