//
//  DateFormatter+Extension.swift
//  WidgetApp
//
//  Created by 李昆明 on 2023/8/14.
//

import Foundation

extension DateFormatter {
    
    public convenience init(format: String) {
        self.init()
        self.locale = Locale(identifier: "zh_CN")
        self.locale = Locale(identifier: "en_US")
        self.dateStyle = .medium
        self.dateFormat = format
    }
    
    // common
    static public let year = DateFormatter(format: "yyyy")
    static public let fullPretty = DateFormatter(format: "yyyy-MM-dd HH:mm:ss")
    static public let fullPretty1 = DateFormatter(format: "yyyy/MM/dd HH:mm:ss")
    static public let yearMonthDay = DateFormatter(format: "yyyy-MM-dd")
    static public let yearMonthDay1 = DateFormatter(format: "dd/MM/yyyy")

    static public let monthDay = DateFormatter(format: "MM-dd")
    static public let dayHour = DateFormatter(format: "dd:HH")
    static public let hourMinute = DateFormatter(format: "HH:mm")
    static public let hourMinuteSecond = DateFormatter(format: "HH:mm:ss")
    // use "EEE" for Fri, use "MM" for 11, MMM for Nov, MMMM for November
    static public let weekDay = DateFormatter(format: "EEEE,MMM dd") // Thursday,Nov 11
    
    // zh
    static public let zhFullPretty = DateFormatter(format: "yyyy年MM月dd HH:mm:ss")
    static public let zhYearMonthDay = DateFormatter(format: "yyyy年MM年dd")
    static public let zhMonthDay = DateFormatter(format: "MM月dd日")
}
// MARK: - Constants
extension Date {
    func toLocalTimeZone(_ timeZone: TimeZone?) -> Date {
        let timezone = timeZone ?? TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}
extension Date {
    public enum Constant {
        static let daysOneWeek: Int = 7
        static let secondsOneMinute: Double = 60
        static let minutesOneHour: Double = 60
        static let hoursOneDay: Double = 24
        static let millisecondsOneSecond: Double = 1000
        static let secondsOnHour: Double = secondsOneMinute * minutesOneHour
        static let secondsOneDay: Double = secondsOneMinute * minutesOneHour * hoursOneDay
        static let millisecondsOneDay: Double = secondsOneDay * millisecondsOneSecond
    }
}

extension Date {
    // MARK: 24H前
    var tweentyHoursAgoDate: Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: -1, to: Date())
    }
    // MARK: 一周前
    var weekAgoDate: Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: -7, to: Date())
    }
    // MARK: 一个月前
    var monthAgoDate: Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: -1, to: Date())
    }
    // MARK: 一年前
    var yearAgoDate: Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .year, value: -1, to: Date())
    }
    // MARK: 当日开始时间
    var startOfDay : Date {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.year, .month, .day])
        let components = calendar.dateComponents(unitFlags, from: self)
        return calendar.date(from: components)!
    }
    // MARK: 当日结束时间
    var endOfDay : Date {
        var components = DateComponents()
        components.day = 1
        let date = Calendar.current.date(byAdding: components, to: self.startOfDay)
        return (date?.addingTimeInterval(-1))!
    }
    // MARK: 当周开始时间
    var startOfWeek: Date {
        Calendar.current.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
    }
    // MARK: 当周结束时间
    var endOfWeek: Date {
        var components = DateComponents()
        components.weekOfYear = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfWeek)!
    }
    // MARK: 当月开始时间
    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
        return Calendar.current.date(from: components)!
    }
    // MARK: 当月结束时间
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }
    // MARK: 当年开始时间
    var startOfTheYear : Date {
        let components = Calendar.current.dateComponents([.year], from: startOfDay)
        return Calendar.current.date(from: components)!
    }
    // MARK: 当年结束时间
    var endOfTheYear: Date {
        var components = DateComponents()
        components.year = 1
        return Calendar.current.date(byAdding: components, to: startOfTheYear)!
    }
}


extension Date {
    
    // MARK: - Timestamp format string
    public func localDate() -> Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}
        
        return localDate
    }
    
//    public func localTomorraw() -> Date {
//        let now = localDate()
//        let tomorrow = DateComponents(year: now.year, month: now.month, day: now.day + 1)
//        return Calendar.current.date(from: tomorrow)!
//    }

    public var secondTimestampIntValue: Int {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        return Int(timeInterval)
    }
    
    public var secondTimestampStringValue: String {
        return "\(secondTimestampIntValue)"
    }
    
    public var millisecondTimestampIntValue: Int {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        return Int(timeInterval * Constant.millisecondsOneSecond)
    }
    
    public var millisecondTimestampStringValue: String {
        return "\(millisecondTimestampIntValue)"
    }
    
    public func hourMinuteFormatString(from millsecondTimestamp: Int) -> String {
        return formatString(from: millsecondTimestamp, withFormat: "HH:mm")
    }
    
    public func yearMonthDayFormatString(from millsecondTimestamp: Int) -> String {
        return formatString(from: millsecondTimestamp, withFormat: "yyyy-MM-dd")
    }
    
    public func fullFormatString(from millsecondTimestamp: Int) -> String {
        return formatString(from: millsecondTimestamp, withFormat: "yyyy-MM-dd HH:mm:ss")
    }
    
    public func formatString(from millsecondTimestamp: Int, withFormat format: String) -> String {
        return DateFormatter(format: format).string(from: Date(timeIntervalSince1970: TimeInterval(Double(millsecondTimestamp) / Constant.millisecondsOneSecond)))
    }
    
    // MARK: - Format string
    
    public var agoFormatString: String {
        var ret: String = ""
        var distance = Double(Date().timeIntervalSince(self))
        
        if distance <= Constant.secondsOneMinute {
            ret = "刚刚"
        } else if distance < Constant.secondsOnHour {
            distance /= Constant.secondsOneMinute
            ret = "\(Int(distance))分钟前"
        } else if distance < Constant.secondsOneDay {
            distance = distance / (Constant.secondsOnHour)
            ret = "\(Int(distance))小时前"
        } else {
            return self.monthDayFormatString
        }
        return ret
    }
    
    public var yearFormatString: String {
        return DateFormatter.year.string(from: self)
    }
    
    public var fullPrettyFormatString: String {
        return DateFormatter.fullPretty.string(from: self)
    }
    
    public var yearMonthDayFormatString: String {
        return DateFormatter.yearMonthDay.string(from: self)
    }
    public var yearMonthDay1FormatString: String {
        return DateFormatter.yearMonthDay1.string(from: self)
    }
    
    public var monthDayFormatString: String {
        return DateFormatter.monthDay.string(from: self)
    }
    
    public var dayHourFormatString: String {
        return DateFormatter.dayHour.string(from: self)
    }
    
    public var hourMinuteFormatString: String {
        return DateFormatter.hourMinute.string(from: self)
    }
    
    public var hourMinuteSecondFormatString: String {
        return DateFormatter.hourMinuteSecond.string(from: self)
    }

    public var weekDayFormatString: String {
        return DateFormatter.weekDay.string(from: self)
    }
    
    public func formatString(with format: String) -> String {
        return DateFormatter(format: format).string(from: self)
    }
}
