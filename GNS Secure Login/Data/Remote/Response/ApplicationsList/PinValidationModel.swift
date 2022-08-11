//
//  PinValidationModel.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 10/08/2022.
//

import Foundation

class PinValidationModel: Codable {
    let message: String?
    let success: Bool?
    let used: Bool?
    
    enum CodingKeys: String, CodingKey {

        case message = "Message"
        case success = "Sucsses"
        case used = "isUsed"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        used = try values.decodeIfPresent(Bool.self, forKey: .used)
    }
    
}
