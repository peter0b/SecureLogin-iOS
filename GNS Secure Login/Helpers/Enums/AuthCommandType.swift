//
//  AuthCommandType.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 03/08/2021.
//

import Foundation

enum AuthCommandType: Int {
    case GValidateLicense = 1
    case CreateUser = 2
    case ResetPassword = 3
    case LoadingGNSSites = 4
    case LicenseInformation = 5
    case GetUsersOfClient = 6
    case GetUserInformation = 7
    case EnrollUser = 8
    case ServerDateTime = 9
    case EncryptCardData = 10
    case DecryptCardData = 11
    case GetLicenseKeys = 12
    case UpdateUserRole = 13
    case ActivateCard = 14
    case LoadingUserGNSSites = 15
    case ValidateBadgeOTP = 16
    case checkEnrollmentCount = 18
    case changeEnrollmentCount = 19
    case AddToUserPIN = 20
    case ValidateUserPIN = 21
    case GetUserInformationByBadeSerial = 23
}
