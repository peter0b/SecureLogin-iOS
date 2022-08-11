//
//  IntExtensions.swift
//  Driver
//
//  Created by Peter Bassem on 27/12/2020.
//  Copyright © 2020 Eslam Maged. All rights reserved.
//

import Foundation

extension Int {
    
    func localized() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: LocalizationHelper.isArabic() ? "ar" : "en")
        formatter.maximumFractionDigits = 10
        
        let formatted = formatter.string(from: NSNumber(value: self))
        return formatted
    }
    
    func toString() -> String {
        return String(self)
    }
    
    func toDouble() -> Double {
        return Double(self)
    }
    
    func toFloat() -> Float {
        return Float(self)
    }
    
    func toBool() -> Bool {
        return Bool(truncating: self as NSNumber)
    }
    
    func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
      var calendar = Calendar.current
      calendar.locale = Locale(identifier: LocalizationHelper.isArabic() ? "ar" : "en")
      let formatter = DateComponentsFormatter()
      formatter.calendar = calendar
      formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
      formatter.unitsStyle = style
      guard let formattedString = formatter.string(from: TimeInterval(self)) else { return "" }
      return formattedString
    }
}

extension Int {
    
    private func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func secondsToHoursMinutesSeconds() -> String {
        let (hour, minute, second) = secondsToHoursMinutesSeconds(seconds: self)
        if hour > 0 {
            return String(format: "%02d:%02d:%02d", hour, minute, second)
        } else {
            return String(format: "%02d:%02d", minute, second)
        }
    }
}
