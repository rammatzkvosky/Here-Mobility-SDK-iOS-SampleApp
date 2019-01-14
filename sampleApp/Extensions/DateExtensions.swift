//
// Copyright © 2018 HERE Global B.V. All rights reserved.
//

import Foundation

extension Date {

    private static let formatter = DateFormatter()

    var timeOfDay: String {

        let f = Date.formatter
        f.dateStyle = .none
        f.timeStyle = .short

        return f.string(from: self)
    }

    public var prettyShort: String {
        Date.formatter.dateFormat = "MMM dd, yyyy"
        return Date.formatter.string(from: self)
    }

    public var long: String {
        Date.formatter.dateFormat = "dd MMMM yyyy, HH:mm"
        return Date.formatter.string(from: self)
    }

    public var justTime: String {
        Date.formatter.dateFormat = "HH:mm"
        return Date.formatter.string(from: self)
    }

    public func midnight() -> Date? {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        return calendar.date(bySettingHour: 0, minute: 0, second: 0, of: self)
    }

    public static func secondsBetween(date1 d1:Date, date2 d2:Date) -> Int {
        let dc = Calendar.current.dateComponents([.second], from: d1, to: d2)
        return dc.second!
    }

    public static func minutesBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.minute], from: d1, to: d2)
        return dc.minute!
    }

    public static func hoursBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.hour], from: d1, to: d2)
        return dc.hour!
    }

    public static func daysBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.day], from: d1, to: d2)
        return dc.day!
    }

    public static func weeksBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.weekOfYear], from: d1, to: d2)
        return dc.weekOfYear!
    }

    public static func monthsBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.month], from: d1, to: d2)
        return dc.month!
    }

    public static func yearsBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.year], from: d1, to: d2)
        return dc.year!
    }

    //MARK- Computed Properties

    public var day: UInt {
        return UInt(Calendar.current.component(.day, from: self))
    }

    public var month: UInt {
        return UInt(NSCalendar.current.component(.month, from: self))
    }

    public var year: UInt {
        return UInt(NSCalendar.current.component(.year, from: self))
    }

    public var hour: UInt {
        return UInt(NSCalendar.current.component(.hour, from: self))
    }

    public var minute: UInt {
        return UInt(NSCalendar.current.component(.minute, from: self))
    }

    public var second: UInt {
        return UInt(NSCalendar.current.component(.second, from: self))
    }
}

