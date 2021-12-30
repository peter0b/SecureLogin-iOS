//
//  DateExtensions.swift
//  Driver
//
//  Created by Peter Bassem on 27/12/2020.
//  Copyright © 2020 Eslam Maged. All rights reserved.
//

import Foundation

extension Date {
    static func getIntervalWithSettingSeconds(interval: Int64) -> Int64 {
        var date = Date(milliseconds: interval)
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        date = Calendar.current.date(bySettingHour: components.hour ?? 0, minute: components.minute ?? 0, second: 0, of: date) ?? Date()
        return date.millisecondsSince1970
    }

    static func switchFormateOf(date: String?, fromFormate: String = DateFormates.dateTimeFormate.rawValue, toFormate: String) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.pmSymbol = "pmLong".localized()
        dateFormatter.amSymbol = "amLong".localized()
        dateFormatter.dateFormat = fromFormate
        guard let convertedDate = dateFormatter.date(from: date) else { return "" }
        dateFormatter.dateFormat = toFormate

        let timeStamp = dateFormatter.string(from: convertedDate)
        return timeStamp
    }

    static func switchEnglishFormateOf(date: String?, fromFormate: String = DateFormates.dateTimeFormate.rawValue, toFormate: String) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "EN")
        dateFormatter.pmSymbol = "pmLong".localized()
        dateFormatter.amSymbol = "amLong".localized()
        dateFormatter.dateFormat = fromFormate
        guard let convertedDate = dateFormatter.date(from: date) else { return "" }
        dateFormatter.dateFormat = toFormate

        let timeStamp = dateFormatter.string(from: convertedDate)
        return timeStamp
    }

    init?(from date: String?, fromFormate: String = DateFormates.dateTimeFormate.rawValue) {
        guard let date = date else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormate
        if let date = dateFormatter.date(from: date) {
            self = date
        } else {
            return nil
        }
    }

    func getDateString(formate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = formate
        let dateString = formatter.string(from: self)
        return dateString
    }

    func isAm() -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "a"
        let dateString = formatter.string(from: self)
        return dateString.contains("amShort".localized())
    }

    func getDurationTill(date: Date?) -> String {
        guard let dateString = date else {
            return ""
        }
        var durationString = ""
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self, to: dateString)
        if let years = components.year, years > 0 {
            durationString += "\(years) \("years".localized()) "
        }
        if let months = components.month, months > 0 {
            durationString += "\(months) \("months".localized()) "
        }
        if let days = components.day, days > 0 {
            durationString += "\(days) \("days".localized()) "
        }
        if let hours = components.hour, hours > 0 {
            durationString += "\(hours) \("hours".localized()) "
        }
        if let minutes = components.minute, minutes > 0 {
            durationString += "\(minutes) \("minutes".localized())"
        }
        return durationString
    }

    func getTime() -> String {
        let components = Calendar.current.dateComponents([.day], from: self, to: self)
        if let days = components.day, days > 0 {
            return self.getDateString(formate: DateFormates.dayMonthYear.rawValue)
        }
        return self.getDateString(formate: DateFormates.time.rawValue)
    }

    var millisecondsSince1970: Int64 {
        return Int64((timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }

    func age(dateString: String?) -> String? {
        guard let dateString = dateString else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormates.dateOfBirth.rawValue
        if let birthday = dateFormatter.date(from: dateString) {
            let components = Calendar.current.dateComponents([.year], from: birthday, to: self)
            if let age = components.year {
                return "\(age)"
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func yearsBetweenDate(endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: self, to: endDate)
        return components.year!
    }

    init?(dateString: String?, formate: String = DateFormates.dateOfBirth.rawValue) {
        guard let date = dateString else {
            return nil
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        if let date = dateFormatter.date(from: date) {
            self = date
        } else {
            return nil
        }
    }
    
    func getCurrentMillis() -> Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }

}
