//
//  Date+Extension.swift
//  WidgetApp
//
//  Created by HS-jianxin on 2023/8/6.
//

import Foundation

// MARK: - 时间加减运算
extension Date {
    /// 获取距离当前日期，几年几月几日的日期
    ///
    /// - Parameters:
    ///   - year: 距离当前日期的前/后几年  如：去年:-1   明年:1  今年:0
    ///   - month:  距离当前日期的前/后几个月  如：上个月:-1   下个月:1  这个月:0
    ///   - day:  距离当前日期的前/后几天 如：昨天:-1   明天:1   今天:0
    /// - Returns: 返回所要的日期
    func dateAdd(year: Int,month: Int, day: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        var comps: DateComponents?
        
        comps = calendar.dateComponents([.year,.month,.day], from: self)
        comps?.year = year
        comps?.month = month
        comps?.day = day
        return calendar.date(byAdding: comps!, to: self) ?? Date()
    }
    
    
    
    /// 比较两个时间差值
    /// - Parameters:
    ///   - startDate: 开始时间
    ///   - endDate: 结束时间
    ///   - units: 要比较的时间单位
    /// - Returns: 时间比较
    static func dateCompare(startDate: Date, endDate: Date, units: [Int]) -> DateComponents {
        let set = TimeEnum.parseUnitToComponent(units: units)
        let commponent: DateComponents = Calendar.current.dateComponents(set, from: startDate, to: endDate)
        return commponent
    }
}
