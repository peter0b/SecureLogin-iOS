//
//  Constants.swift
//  Driver
//
//  Created by Peter Bassem on 12/24/20.
//  Copyright © 2020 Peter Bassem. All rights reserved.
//

import UIKit
import ACSSmartCardIO
import CoreBluetooth

// MARK: - ViewControllerID
enum ViewControllerID: String {
    case splashViewController
}

// MARK: -
enum StoryboardID: String {
    case splash
}

// MARK: - Language
enum LanguageConstants: String {
    case appleLanguage = "AppleLanguages"
    case englishLanguage = "en"
    case arabicLanguage = "ar"
}

// MARK: - Date Formats
let dateFormatter = DateFormatter()
enum DateFormates: String {
    case parkingDateFormate = "dd.MM.yyyy / hh:mm a"
    case dateSlashTime = "dd.MM.yyyy / hh:mm"
    case dateTimeFormate = "yyyy-MM-dd'T'HH:mm:ss"
    case monthYear = "MMM yyyy"
    case dayMonthYear = "dd MMM yyyy"
    case time = "hh:mm a"
    case month = "MM"
    case monthString = "MMM"
    case dateOfBirth = "yyyy/MM/dd"
    case monthSlashYear = "MM/yyyy"
    case daySlashMonthSlashYear = "dd/MM/yyyy"
    case daySlashMonthSlashShortYear = "dd/MM/yy"
    case yearMonthDateShortFormat = "yyMMdd"
}

// MARK: - Global Constants
enum GlobalConstants: String {
    case kSuccess = "success"
    case gnsLicense = "1PJYSP5-1VEF1E0-6Z4HVC-1VE83VG"
}

//let manager = BluetoothSmartCard.shared.manager
//let factory = BluetoothSmartCard.shared.factory
//let cardStateMonitor = CardStateMonitor.shared
//let bluetoothManager = CBCentralManager(delegate: nil, queue: nil)

typealias EnrollAlertCompletion = (EnrollAlertType) -> Void

// MARK: - NotificationCenter.Name
extension Notification.Name {
    static let BadgeIdValue = Notification.Name("badgeIdValue")
    static let BadgeBatteryStatus = Notification.Name("badgeBatteryStatus")
    static let EnrollmentValue = Notification.Name("enrollmentValue")
    static let NfcBatteryStatus = Notification.Name("nfcBatteryStatus")
    static let VideTutorialSkipButton = Notification.Name("videTutorialSkipButton")
    static let VideTutorialCancelButton = Notification.Name("videTutorialCanceButton")
}

// MARK: - GATT Services
let ENROLL_CHARACTERISTIC_UID = "Enroll characteristic UUID"
let ENROLL_FEEDBACK_CHARACTERISTIC_UID = "Enroll Feedback characteristic UUID"

// MARK: -
var keyWindow: UIWindow? {
    if #available(iOS 13.0, *) {
        return UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
    } else {
        return UIApplication.shared.keyWindow
    }
}

let appDelegate = UIApplication.shared.delegate as? AppDelegate

@available(iOS 13.0, *)
let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
