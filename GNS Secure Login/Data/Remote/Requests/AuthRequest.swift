//
//  AuthRequest.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 12/01/2022.
//

import Foundation

struct AuthRequest: Codable {
    let username: String?
    let password: String?
}
