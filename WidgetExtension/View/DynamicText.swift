//
//  DynamicText.swift
//  WidgetApp
//
//  Created by HS-jianxin on 2023/8/3.
//

import Foundation
import SwiftUI
import WidgetKit


/// 文本处理
struct DynamicText: View {
//    @State var singleContent: TextSingleModel
//    @State var size: CGSize
    @ObservedObject var singleContent: TextSingleModel
    var size: CGSize
    var widgetEnvironment: WidgetsEnvironment
    var entry: TimelineEntry
    
    /// 获取共有属性模型
    func getShareContent() -> SharedAttModel{
        return singleContent.sharedContent!
    }
    
    
    /// 获取文字对齐方式
    func getAlignment() -> Alignment {
        var t = Alignment.leading
        switch singleContent.textAlignment {
        case .center:
            t = .center
        case .trailing:
            t = .trailing
        default:
            t = .leading
        }
        return t
    }
    func getTextAlignment() -> TextAlignment {
        var t = TextAlignment.leading
        switch singleContent.textAlignment {
        case .center:
            t = .center
        case .trailing:
            t = .trailing
        default:
            t = .leading
        }
        return t
    }
    /// 获取显示内容
    func getTextContent() -> String {
        var str = ""
//        let contentAtt = singleContent.contentAtt!
        let timelinedate = {
            if widgetEnvironment == .Widget {
                return entry.date //Date(timeInterval: 1, since: entry.date)
            }else {
                return Date()//.addingTimeInterval(3600*24*4) //当前时间
            }
        }()
        
        switch singleContent.contentType {
            // 普通文本, 可编辑文本， 格言
            case .text, .textedit, .motto:
                str = singleContent.format ?? ""
            
            // 日期
            case .date:
                str = textGet_WithDateType(timelinedate)

            // 时间
            case .time:
                str = textGet_WithTimeType(timelinedate)
                
            // 倒计时，节日
            case .countdown, .memorialday: //倒计时，节日
                str = textGet_WithCountdownType(timelinedate)
            
            // 电量
            case .electricity: //电量
                str = textGet_WithElectricityType()
            
            // 日历
            case .calendar: //日历
                str = textGet_WithCalendarType(timelinedate)
            
            // 设备信息
            case .device:
                str = textGet_WithDeviceType()
            
            // 提醒事项
            case .reminder:
                return String(ReminderAuthManager.allReminders().count)
            
            // 健康健身
            case .health:
                str = textGet_WithHealthType()
            
            // 星座运势
            case .horoscope:
                str = textGet_WithHoroscopeType()
            
            // 天气
            case .weather:
                str = textGet_WithWeatherType(timelinedate)
            
            
            default:
                str = ""
        }
            
        return str
    }
    /// 获取文本颜色
    func getTextColor() -> UIColor {
        let r = singleContent.textColor?.first!
        return UIColor(red: r![0], green: r![1], blue: r![2], alpha: r![3])
    }
    
    
    
    var body: some View {
            Text(getTextContent())
                .offset(x: ((getShareContent().offset?.first)! * size.width) as CGFloat, y: ((getShareContent().offset?.last)! * size.height) as CGFloat)
                .frame(width: (getShareContent().size?.first)! * size.width, height: (getShareContent().size?.last)! * size.height, alignment: getAlignment())
                .lineLimit(singleContent.lineLimit == 0 ? nil : singleContent.lineLimit)
                .foregroundColor(Color(getTextColor()))
                .font(Font.custom(singleContent.font ?? "", size: singleContent.fontSize ?? 16))
                .multilineTextAlignment(getTextAlignment())
                .minimumScaleFactor(singleContent.minScale ?? 0.5)

    }
    
    
    // ---  链接跳转
//    var body: some View {
//        Link(destination: URL(string: "widget://hello?\(getTextContent())".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "widget://hello")!) {
//            Text(getTextContent())
//                .frame(width: (getShareContent().size?.first)! * size.width, height: (getShareContent().size?.last)! * size.height, alignment: getAlignment())
//                .lineLimit(singleContent.lineLimit == 0 ? nil : singleContent.lineLimit)
//                .foregroundColor(Color(getTextColor()))
//                .font(Font.custom(singleContent.font ?? "", size: singleContent.fontSize ?? 16))
//                .multilineTextAlignment(getTextAlignment())
//                .minimumScaleFactor(singleContent.minScale ?? 0.5)
//        }
//        .offset(x: ((getShareContent().offset?.first)! * size.width) as CGFloat, y: ((getShareContent().offset?.last)! * size.height) as CGFloat)
//    }
    
    
    
    
    
    
    
    
    
    
    
    //MARK: 日期
    /// 获取文本： 日期 类
    func textGet_WithDateType(_ timelinedate: Date) -> String {
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "zh_Hans_CN")
        dateFormater.dateFormat = singleContent.format
        return dateFormater.string(from: timelinedate)
    }
    
    
    //MARK: 时间
    /// 获取文本： 时间 类
    func textGet_WithTimeType(_ timelinedate: Date) -> String {
        var str = ""
        
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "zh_Hans_CN")
        dateFormater.dateFormat = singleContent.format
        str = dateFormater.string(from: timelinedate)
        guard let viewUnits: [Int] = singleContent.contentAtt!["viewUnits"] as? [Int] else { return str }
        let index = str.index(str.startIndex,offsetBy: viewUnits.first ?? 0)
        str = String(str[index])
        return str
    }
    
    
    //MARK: 倒计时、节日
    /// 获取文本： 倒计时、节日 类
    func textGet_WithCountdownType(_ timelinedate0: Date) -> String {
        var str = ""
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        let holidayDate = dateFormater.date(from: singleContent.contentAtt!["date"] as! String)! //获取指定时间
        let timelinedate = dateFormater.date(from: dateFormater.string(from: timelinedate0))!
        // 固定文本展示
        if singleContent.format?.isEmpty == true {
            if timelinedate.compare(holidayDate) == .orderedDescending {
                str = (singleContent.contentAtt!["formats"] as! [String])[1]
            }else {
                str = (singleContent.contentAtt!["formats"] as! [String])[0]
            }
        }
        // 只是展示时间数值
        else {
            let viewUnits = singleContent.contentAtt!["viewUnits"] as! [Int]

            if viewUnits.contains(0) {  // 如果没有viewUnits，只将时间展示出来
                dateFormater.dateFormat = singleContent.format
                str = dateFormater.string(from: holidayDate)
            }else {
                var commp: DateComponents
                if singleContent.contentType == .countdown {
                    commp = Date.dateCompare(startDate: timelinedate, endDate: holidayDate, units: singleContent.contentAtt!["viewUnits"] as! [Int])
                }else {
                    commp = Date.dateCompare(startDate: holidayDate, endDate: timelinedate, units: singleContent.contentAtt!["viewUnits"] as! [Int])
                }
                var p = commp.day
                if (singleContent.contentAtt!["viewUnits"] as! [Int]).contains(1) {
                    p = commp.year
                } else if (singleContent.contentAtt!["viewUnits"] as! [Int]).contains(2) {
                    p = commp.month
                }
                str = String(format: singleContent.format!, p!)
            }
        }
        return str
    }
    
    //MARK: 电量
    /// 获取文本： 电量 类
    func textGet_WithElectricityType() -> String {
        var str = ""
        //开启isBatteryMonitoringEnabled
        UIDevice.current.isBatteryMonitoringEnabled = true
        //获得电量（返回的是Float格式，范围是0-1，这里乘以100并且转换成整数形式）
        let level = UIDevice.current.batteryLevel
        if level >= 0 {
            str = String(format: singleContent.format ?? "%@", String(Int(level * 100)))
        }else {
            str = singleContent.format!
            str = str.replacingOccurrences(of: "%@", with: "").replacingOccurrences(of: "%%", with: "")
        }
        return str
    }
            
    
    //MARK: 日历
    /// 获取文本： 日历 类
    func textGet_WithCalendarType(_ timelinedate: Date) -> String {
        var str = ""
        // contentAtt [["每日文本"],"以什么为单位"]
        let set: Set<Calendar.Component> = TimeEnum.parseUnitToComponent(unit: singleContent.contentAtt!["unit"] as! Int)
        if set.isEmpty == false {
            let comps = Calendar.current.dateComponents(set, from: timelinedate)
            let strs = singleContent.contentAtt?["imageNames"] as? [String]
            str = strs?[(comps.weekday! - 1)] ?? ""
        }
        return str
    }
    
    //MARK: 星座运势
    /// 获取文本： 星座运势 类
    func textGet_WithHoroscopeType() -> String {
        let str = singleContent.format
        return str!
    }
    
    
    //MARK: 设备信息
    /// 获取文本： 设备信息 类
    func textGet_WithDeviceType() -> String {
        let str = ""
        let deviceInfoType = DeviceInfoTypeEnum(rawValue: singleContent.contentAtt!["deviceInfoType"] as! Int)
        // 总空间
        if deviceInfoType == .storageTotal {
            guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String), let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value else {
                return String.intByteToString(diskSpace: 0)
            }
            return String.intByteToString(diskSpace: space)
        }
        // 剩余空间
        else if deviceInfoType == .storageFree {
            if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
               return String.intByteToString(diskSpace: space)
           } else {
               return String.intByteToString(diskSpace: 0)
           }
        }
        // 已使用空间
        else if deviceInfoType == .storageUsed {
            var totalByte: Int64 = 0, freeByte: Int64 = 0
            guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String), let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value else {
                return String.intByteToString(diskSpace: 0)
            }
            totalByte = space
            if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
                freeByte = space
            } else {
                freeByte = 0
            }
            return String.intByteToString(diskSpace: (totalByte - freeByte))
        }
        // 手机型号
        else if deviceInfoType == .iPhoneModel {
            return UIDevice.current.modelName
        }
        // 当前系统的版本
        else if deviceInfoType == .iOSVersion {
            return UIDevice.current.systemVersion;//获取当前系统的版本
        }
        
        return str
    }
    
    
    //MARK:  健康健身
    /// 获取文本：健康健身 类
    func textGet_WithHealthType() -> String {
        var str = ""
        // 获取子类型
        let subType = HealthInfoTypeEnum(rawValue: singleContent.contentAtt!["deviceInfoType"] as! Int)
        let format = singleContent.format!
        
        // 展示为步数时
        if subType == .stepCount {
            str = String(format: format, HealthAuthManager.getStepCount())
        }
        // 展示距离时
        else if subType == .distanceWalkingRunning {
            str = String(format: format, HealthAuthManager.getDistance())
        }
        // 展示能量消耗时
        else if subType == .energyBurned {
            str = String(format: format, Int(HealthAuthManager.getEnergyBurned()))
        }
        
        return str
    }
    
    
    //MARK: 天气
    /// 获取文本： 天气 类
    func textGet_WithWeatherType(_ timelinedate: Date) -> String {
//        "contentType":22,"contentAtt":{"deviceInfoType":6,"unit":3,"progress":[2]}
        var str = ""
        
        let subType = WeatherInfoTypeEnum(rawValue: (singleContent.contentAtt?["deviceInfoType"] ?? 0) as! Int)
        let unit = TimeTypeEnum(rawValue: (singleContent.contentAtt?["unit"] ?? 0) as! Int)
        let progress = ((singleContent.contentAtt?["progress"] ?? [0]) as! [Int]).first
        
        switch subType {
        case .location, .temperature, .textOrIcon, .tempMin, .tempMax, .windDirAndScale, .pm2_5, .humidity, .ultraviolet, .comfort:
            str = singleContent.format ?? ""
        case .timeText:
            if unit == .day {
                let dateFormater = DateFormatter()
                dateFormater.locale = Locale(identifier: "zh_Hans_CN")
                dateFormater.dateFormat = "E"
                str = dateFormater.string(from: timelinedate.dateAdd(year: 0, month: 0, day: progress ?? 0))
            }
            else if unit == .hour {
                let dateFormater = DateFormatter()
                dateFormater.locale = Locale(identifier: "zh_Hans_CN")
                dateFormater.dateFormat = "HH"
                str = dateFormater.string(from: timelinedate.addingTimeInterval(3600.0 * Double(progress ?? 0))) + "时"
                
            }
        default:
            str = ""
        }
        
        
        
        return str
    }
    
    
}



/**
 contentAtt
 
 
 unit: Int 以什么为单位
 
 */
