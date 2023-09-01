//
//  TimeEnum.swift
//  WidgetApp
//
//  Created by HS-jianxin on 2023/8/7.
//

import Foundation
import HandyJSON


enum TimeTypeEnum: Int, HandyJSONEnum, Hashable {
    case none = 0           //无效
    case year = 1           //年
    case month = 2          //月
    case day = 3            //日
    case hour = 4           //小时,24小时制
    case minute = 5         //分钟
    case second = 6         //秒钟
    case weekday = 7        //周
    case hour_0 = 8         //24小时制，例如12，这里是1
    case hour_1 = 9         //24小时制，例如12，这里是2
    case minute_0 = 10      //分钟第一位
    case minute_1 = 11      //分钟第二位
    case second_0 = 12      //秒第一位
    case second_1 = 13      //秒第二位
}


class TimeEnum {
    
    /// 将配置文件中的时间类型处理成标准格式
    static func parseUnitToComponent(unit: Int) -> Set<Calendar.Component>{
        var set = Set<Calendar.Component>()
        
        if TimeTypeEnum(rawValue: unit) == .weekday {
            set.insert(.weekday)
        }
        else if TimeTypeEnum(rawValue: unit) == .year {
            set.insert(.year)
        }
        else if TimeTypeEnum(rawValue: unit) == .month {
            set.insert(.month)
        }
        else if TimeTypeEnum(rawValue: unit) == .day {
            set.insert(.day)
        }
        else if TimeTypeEnum(rawValue: unit) == .hour {
            set.insert(.hour)
        }
        else if TimeTypeEnum(rawValue: unit) == .minute {
            set.insert(.minute)
        }
        else if TimeTypeEnum(rawValue: unit) == .second {
            set.insert(.second)
        }
        
        return set
    }
    
    /// 将配置文件中的时间类型处理成标准格式
    static func parseUnitToComponent(units: [Int]) -> Set<Calendar.Component>{
        var set = Set<Calendar.Component>()
        units.forEach { unit in
            if TimeTypeEnum(rawValue: unit) == .weekday {
                set.insert(.weekday)
            }
            else if TimeTypeEnum(rawValue: unit) == .year {
                set.insert(.year)
            }
            else if TimeTypeEnum(rawValue: unit) == .month {
                set.insert(.month)
            }
            else if TimeTypeEnum(rawValue: unit) == .day {
                set.insert(.day)
            }
            else if TimeTypeEnum(rawValue: unit) == .hour {
                set.insert(.hour)
            }
            else if TimeTypeEnum(rawValue: unit) == .minute {
                set.insert(.minute)
            }
            else if TimeTypeEnum(rawValue: unit) == .second {
                set.insert(.second)
            }
        }
        return set
    }
}


