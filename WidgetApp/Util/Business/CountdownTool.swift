//
//  CountdownTool.swift
//  WidgetApp
//
//  Created by HS-jianxin on 2023/8/4.
//

import Foundation

//MARK: 倒计时


//MARK: - 时间差值计算方式
class CountdownTool {
    
    /// 计算两个事件的差值
    /// - Parameters:
    ///   - startDate: 开始时间
    ///   - endDate: 结束时间
    ///   - components: 计算差异方式
    /// - Returns: 差值
    static func dateInterval(startDate: Date, endDate: Date, components: Set<Calendar.Component>) -> DateComponents {
        //比较的结果是NSDateComponents类对象
        let component = Calendar.current.dateComponents(components, from: startDate, to: endDate)
        return component
    }
    
    
    static func dateInterval(startDate: Date, endDate: Date, comp: [String], repeatType: [String]) -> DateComponents {
        var newStartDate = startDate //用户选定的时间，重复方式不一样，此值会变
        // 根据repeat重置startDate
        if repeatType.isEmpty == false {
            if endDate.compare(newStartDate) == ComparisonResult.orderedDescending {
                if repeatType.contains("year") {
//                    newStartDate =
                }
            }
        }
        
        
        //利用NSCalendar比较日期的差异
        var components: Set<Calendar.Component> = Set<Calendar.Component>()
        
        if comp.contains("year") {
            components.insert(.year)
        }
        if comp.contains("month") {
            components.insert(.month)
        }
        if comp.contains("day") {
            components.insert(.day)
        }
        if comp.contains("hour") {
            components.insert(.hour)
        }
        if comp.contains("minute") {
            components.insert(.minute)
        }
        if comp.contains("second") {
            components.insert(.second)
        }
        if comp.contains("weekday") {
            components.insert(.weekday)
        }
        
        //比较的结果是NSDateComponents类对象
        let component = Calendar.current.dateComponents(components, from: startDate, to: endDate)
        
        
        
        
        return component
    }
    
    
    
    
}






//MARK: - Widget编辑
extension CountdownTool {
    
    /// 改变倒计时时间
    /// - Parameters:
    ///   - model: 原widget模型
    ///   - countdownDate: 倒计时时间
    /// - Returns: 新widget模型
    static func changeCountdownDay(model: WidgetModel, countdownDate: Date) -> WidgetModel{
        let tmodel = model
        let contents = tmodel.contents
        contents?.forEach({ singleModel in
            if singleModel.contentType == .countdown { // 如果当前时间为倒计时
                var atts = singleModel.contentAtt
                atts?["countdownDate"] = countdownDate
                singleModel.contentAtt = atts
            }
        })
        return tmodel
    }
    
    
    /// 改变倒计时 重复规则
    /// - Parameters:
    ///   - model: 原widget模型
    ///   - repeatType: 重复类型
    /// - Returns: 新widget模型
    static func changeCountdownRepeatType(model: WidgetModel, repeatType: TimeTypeEnum) -> WidgetModel{
        let tmodel = model
        let contents = tmodel.contents
        contents?.forEach({ singleModel in
            if singleModel.contentType == .countdown { // 如果当前时间为倒计时
                var atts = singleModel.contentAtt
                atts?["unit"] = repeatType.rawValue
                singleModel.contentAtt = atts
            }
        })
        return tmodel
    }
}









//MARK: - json样式
/**
 {
     "topTagId":1,
     "categoryId":1,
     "widgetId":1,
     "widgetType":1,
     "desktopAudio":{
         "isOpen":false,
         "audioPath":"",
         "notifiTitle":"",
         "notifiContent":""
     },
     "editCategory":[
         1,
         2,
         3
     ],
     "navigationURL":"",
     "contents":[
         {
             "viewType":4,
             "sharedContent":{
                 "offset":[
                     0.1,
                     0.2
                 ],
                 "size":[
                     0.8,
                     0.2
                 ],
                 "rotate":0,
                 "alpha":1,
                 "cornerRadius":0,
                 "shadow":{
                     "color":[
                         [
                             1,
                             1,
                             1,
                             1
                         ]
                     ],
                     "radius":5,
                     "offset":[
                         5,
                         5
                     ]
                 }
             },
             "contentType":8,   ⚠️倒计时
             "contentAtt":{     ⚠️针对某一展示分类的相关配置
                viewUnits: [Int],        == 当前view要的时间类型
                unit: Int,            == 重复类型 TimeTypeEnum
                countdownDate,        == 纪念日时间
                formats: ["还有","已过"]         == 文本格式化，Date>选择时间取0，Date<选择时间取1
             },
             "font":"字体",
             "fontSize":16,
             "textColor":[
                 [
                     1,
                     0,
                     0,
                     1
                 ]
             ],
             "textAlignment":0,
             "lineLimit":0,
             "minScale":0.5,
             "format":"HH-mm:ss"
         }
     ]
 }
 */

