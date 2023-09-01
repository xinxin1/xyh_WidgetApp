//
//  DynamicPhoto.swift
//  WidgetApp
//
//  Created by HS-jianxin on 2023/8/3.
//

import Foundation
import SwiftUI
import AFNetworking
import WidgetKit


#if DEBUG
let kGroupIdentifier = "group.com.smartclean.storagecleaner"
#else
let kGroupIdentifier = "group.com.widget.top.WidgetApp"
#endif



/// 图片处理
struct DynamicPhoto: View {
    @State var singleContent: PhotoSingleModel
    var size: CGSize
    var widgetEnvironment: WidgetsEnvironment
    var entry: TimelineEntry
    
//    @State private var currentDate: Date = Date() //.dateAdd(year: 0, month: 13, day: 0)
    @State private var calendar: Calendar = Calendar(identifier: .gregorian)
    
    /// 获取共有属性模型
    func getShareContent() -> SharedAttModel{
        return singleContent.sharedContent!
    }
    
    
    /// 根据展示类型 处理不同逻辑
    func kkk() -> Image {
        let timelinedate = {
            if widgetEnvironment == .Widget {
                return entry.date //Date(timeInterval: 1, since: entry.date)
            }else {
                return Date()//.addingTimeInterval(3600*24*4) //当前时间
            }
        }()
        
        //  单张图片 & 虚拟时钟
        if singleContent.contentType == .singlePhoto || singleContent.contentType == .clock {
            let imgName = singleContent.photos?.first ?? ""
            return getImageByName(environment: widgetEnvironment, imageName: imgName)
        }
        
        //  日历
        else if singleContent.contentType == .calendar {
            return getCalendar(timelinedate)
        }
        
        //  Wi-Fi
        else if singleContent.contentType == .wifi {
            // 判断是否连接Wi-Fi
            let isConnect = AFNetworkReachabilityManager.shared().networkReachabilityStatus == .reachableViaWiFi
            return getWiFiImage(isConnect: isConnect)
        }
        
        // 蓝牙
        else if singleContent.contentType == .bluetooth {
            // 获取蓝牙状态
            let isConnect = BluetoothAuthManager.requestBluetoothStateAction().1
            return getBluetoothImage(isConnect: isConnect)
        }
        
        // 电量
        else if singleContent.contentType == .electricity {
            return getElectricity()
        }
        
        // 星座预测
        else if singleContent.contentType == .horoscope {
            return getHoroscope()
        }
        // 天气
        else if singleContent.contentType == .weather {
            return getWeather()
        }
        
        
        return Image("")
    }
    
    
    
    var body: some View {
        
        
        if singleContent.contentType == .singlePhoto || singleContent.contentType == WidgetContentTypeEnum.none || singleContent.contentType == .calendar || singleContent.contentType == .wifi || singleContent.contentType == .bluetooth || singleContent.contentType == .electricity || singleContent.contentType == .horoscope || singleContent.contentType == .weather {
            kkk()
                .resizable()
                .offset(x: ((getShareContent().offset?.first)! * size.width) as CGFloat, y: ((getShareContent().offset?.last)! * size.height) as CGFloat)
                .frame(width: (getShareContent().size?.first)! * size.width, height: (getShareContent().size?.last)! * size.height)
        }
        else if singleContent.contentType == .clock { //根据时间调整
            kkk()
                .resizable()
                .rotationEffect(Angle(degrees: getAngleDegrees(getCurrentDate())), anchor: .center)
                .offset(x: ((getShareContent().offset?.first)! * size.width) as CGFloat, y: ((getShareContent().offset?.last)! * size.height) as CGFloat)
                .frame(width: (getShareContent().size?.first)! * size.width, height: (getShareContent().size?.last)! * size.height)
        }
        
    }
    
    private func getCurrentDate() -> Date {
        if widgetEnvironment == .Widget {
            return entry.date //Date(timeInterval: 1, since: entry.date)
        }else {
            return Date()//.addingTimeInterval(3600*24*4) //当前时间
        }
    }
    
    
    
    
    
    
    
    
    
    //MARK: - 天气
    private func getWeather() -> Image {
        //"contentType":22,"contentAtt":{"deviceInfoType":3,"unit":3,"progress":[2]},"photos":["w_100.png"]
        let photoName = singleContent.photos?.first ?? ""
        return getWeatherImageByName(imageName: photoName)
    }
    
    
    //MARK: - 日历
    private func getCalendar(_ currentDate: Date) -> Image {
        // contentAtt {"imageNames":["每日图片名称"], "unit":以什么为单位循环}
        let set: Set<Calendar.Component> = TimeEnum.parseUnitToComponent(unit: singleContent.contentAtt!["unit"] as! Int)
        if set.isEmpty == false {
            let comps = Calendar.current.dateComponents(set, from: currentDate)
            let imgNames = singleContent.contentAtt?["imageNames"] as! [String]
            let imgName = imgNames[(comps.weekday! - 1)]
            return getImageByName(environment: widgetEnvironment, imageName: imgName)
        }
        return Image("")
    }
    
    
    //MARK: - 星座预测
    private func getHoroscope() -> Image {
        let photos = singleContent.photos!
        let unit = singleContent.contentAtt?["unit"] ?? 1
        let imgName = photos[unit as! Int - 1]
        
        return getImageByName(environment: widgetEnvironment, imageName: imgName)
    }
    
    //MARK: - 电量
    private func getElectricity() -> Image {
        var imgName = ""
        let progress = singleContent.contentAtt!["progress"] as! [CGFloat]
        let photos = singleContent.photos!
        // 获取电量
        //开启isBatteryMonitoringEnabled
        UIDevice.current.isBatteryMonitoringEnabled = true
        //获得电量（返回的是Float格式，范围是0-1）
        let batteryElectricity = UIDevice.current.batteryLevel
        if batteryElectricity >= 0 {
            for i in 0 ..< progress.count {
                if batteryElectricity <= Float(progress[i]) {
                    imgName = photos[i+1]
                    break
                }
            }
        }else {
            imgName = photos[0]
        }
        
        return getImageByName(environment: widgetEnvironment, imageName: imgName)
    }
    
    //MARK: - Wi-Fi
    private func getWiFiImage(isConnect: Bool) -> Image {
        let imgName = (isConnect ? singleContent.photos?.first : singleContent.photos?.last) ?? ""
        return getImageByName(environment: widgetEnvironment, imageName: imgName)
    }
    
    
    
    //MARK: - 蓝牙
    private func getBluetoothImage(isConnect: Bool) -> Image {
        let imgName = (isConnect ? singleContent.photos?.first : singleContent.photos?.last) ?? ""
        return getImageByName(environment: widgetEnvironment, imageName: imgName)
    }
    
    
    
    //MARK: - 虚拟时钟
    /// 获取虚拟时钟角度
    private func getAngleDegrees(_ currentDate: Date) -> Double {
        let degrees: Double = 0.0
        if TimeTypeEnum(rawValue: singleContent.contentAtt!["unit"] as! Int) == .hour {
            return Double(calendar.component(.hour, from: currentDate) % 12) * 30 + Double(calendar.component(.minute, from: currentDate) % 60) * 0.5
        }else if TimeTypeEnum(rawValue: singleContent.contentAtt!["unit"] as! Int) == .minute {
            return Double(calendar.component(.minute, from: currentDate) % 60) * 6
        }else if TimeTypeEnum(rawValue: singleContent.contentAtt!["unit"] as! Int) == .second {
            return Double(calendar.component(.second, from: currentDate) % 60) * 6
        }
        return degrees
    }
    
    
    
    
    
    //MARK: - 图片获取
    /// 普通图片获取
    func getImageByName(environment: WidgetsEnvironment, imageName: String) -> Image {
        if widgetEnvironment == .App { // 如果是APP展示，这里暂定从Documents拿
            return Image(uiImage: UIImage(contentsOfFile: NSHomeDirectory()+"/Documents/"+imageName) ?? UIImage())
        }
        else if widgetEnvironment == .Widget {  // 如果是widget，图片从group获取
            let fileManager = FileManager.default
            let url = fileManager.containerURL(forSecurityApplicationGroupIdentifier: kGroupIdentifier)?.appendingPathComponent("/widgets/\(imageName)")
            return Image(uiImage: UIImage(contentsOfFile: (url?.path)!) ?? UIImage())
        }
        return Image(uiImage: UIImage(contentsOfFile: NSHomeDirectory()+"/Documents/"+imageName) ?? UIImage())
    }
    
    /// 获取天气图片
    func getWeatherImageByName(imageName: String) -> Image {
        return Image(uiImage: UIImage(named: imageName) ?? UIImage()) //⚠️这里可放置未知icon
    }
}





