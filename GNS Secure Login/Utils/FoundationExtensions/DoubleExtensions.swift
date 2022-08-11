//
//  DoubleExtensions.swift
//  Driver
//
//  Created by Peter Bassem on 27/12/2020.
//  Copyright © 2020 Eslam Maged. All rights reserved.
//

import Foundation

extension Double {
    
    var string: String { .init(self) }
    
    func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: LocalizationHelper.isArabic() ? "ar" : "en")
        let formatter = DateComponentsFormatter()
        formatter.calendar = calendar
        formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
        formatter.unitsStyle = style
        guard let formattedString = formatter.string(from: self) else { return "" }
        return formattedString
    }
    
    func localized() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: LocalizationHelper.isArabic() ? "ar" : "en")
        formatter.maximumFractionDigits = 10
        
        let formatted = formatter.string(from: NSNumber(value: self))
        return formatted
    }
    
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func roundTo(decimalPlaces: Int) -> String {
//        return NSString(format: "%.\(decimalPlaces)f", self)
        return NSString(format: "%.\(decimalPlaces)f" as NSString, self) as String
    }
    
    func toFloat() -> Float {
        return Float(self)
    }
}

extension String {
    
//    func localized() -> String {
//        let path = Bundle.main.path(forResource: LocalizationHelper.getCurrentLanguage(), ofType: "lproj")
//        let bundle = Bundle(path: path!)
//        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
//    }
    
//    func isValidEmail() -> Bool {
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//        
//        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
//        return emailTest.evaluate(with: self)
//    }
//    
//    var isValidUrl: Bool {
//        guard !contains("..") else { return false }
//        let head     = "((http|https)://)?([(w|W)]{3}+\\.)?"
//        let tail     = "\\.+[A-Za-z]{2,3}+(\\.)?+(/(.)*)?"
//        let urlRegEx = head+"+(.)+"+tail
//        let urlTest = NSPredicate(format: "SELF MATCHES %@", urlRegEx)
//        return urlTest.evaluate(with: trimmingCharacters(in: .whitespaces))
//    }
}
