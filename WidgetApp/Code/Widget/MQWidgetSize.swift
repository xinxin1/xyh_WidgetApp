//
//  MQWidgetSize.swift
//  WidgetApp
//
//  Created by 李昆明 on 2023/8/9.
//

import Foundation
import UIKit
import SwiftUI
struct MQWidgetSize {
    // [设备尺寸]: [左1边、左2边、左3边 距离左侧边距；上1边、上2边、上3边距离上侧边距]
    let deviceWidgets:[String:Array<Double>] = [
        "320x568":[14,165,305,30,200,370], // 5 5s SE。小组件只能放4个，中组件2个，大组件1个
        "375x667":[27,200,348,30,206,382], // 6 6s 7 8 SE2
        "375x812":[23,197,352,71,261,451], // x xs 11pro 12mini
        "414x736":[33,224,381,38,232,428], // 6p 6sp 7p 8p   428
        
        "414x896":[27,218,387,76,286,496], // xr xsmax 11 11ProMax
        "428x926":[32,226,396,82,294,506], // 12 PM /13 PM /14 Pus
        "390x844":[26,206,364,77,273,469], // 12/13/ 14  469-470-469 clean
        // 158x158 338x158 338x354
        "393x852":[27,207,365,91,287,482], // 14 Pro [28,208,366,90,286,482]
        // 170x170,364x170,364x382
        "430x932":[33,227,397,94,306,518], // 14 Pro Max [33,227,397,94,306,518]
    ]
    enum WidgetSizeEnum {
        case small
        case medium
        case large
    }
    
    func getWidgetSize(_ widgetType: WidgetSizeEnum) -> CGSize {
        let wxh:String =  "\(Int(UIScreen.main.bounds.size.width))x\(Int(UIScreen.main.bounds.size.height))"
        // TODO 外层做异常处理。告知用户 “您的机型暂不支持透明组件”
        if !deviceWidgets.keys.contains(wxh) {
            return CGSize(width: -1, height: -1)
        }
        switch widgetType {
        case .small:
            let smallWidth = deviceWidgets[wxh]![2] - deviceWidgets[wxh]![1]
            return CGSize(width: smallWidth, height: smallWidth)
        case .medium:
            let mediumWidth = deviceWidgets[wxh]![2] - deviceWidgets[wxh]![0]
            let mediumHeight = deviceWidgets[wxh]![2] - deviceWidgets[wxh]![1]
            return CGSize(width: mediumWidth, height: mediumHeight)
        case .large:
            let largeWidth = deviceWidgets[wxh]![2] - deviceWidgets[wxh]![0]
            let largeHeight = deviceWidgets[wxh]![4] - deviceWidgets[wxh]![3] + deviceWidgets[wxh]![2] - deviceWidgets[wxh]![1]
            return CGSize(width: largeWidth, height: largeHeight)
        }
    }
    //小组件位置枚举
    enum SmallWidgetSizeEnum {
        case topLeft
        case topRight
        case middleLeft
        case middleRight
        case bottomLeft
        case bottomRight
    }
    // 小组件。获取在不同位置的x,y坐标
    func getSmallWidgetPosition(_ widgetPos: SmallWidgetSizeEnum)->CGPoint{
        let wxh:String =  "\(Int(UIScreen.main.bounds.size.width))x\(Int(UIScreen.main.bounds.size.height))"
        // TODO 外层做异常处理。告知用户 “您的机型暂不支持透明组件”
        if !deviceWidgets.keys.contains(wxh) {
            return CGPoint(x: -1, y: -1)
        }
        
        if(wxh == "320x568") {
            switch widgetPos {
            case .topLeft:
                return CGPoint(x: deviceWidgets[wxh]![0], y: deviceWidgets[wxh]![3])
            case .topRight:
                return CGPoint(x: deviceWidgets[wxh]![1], y: deviceWidgets[wxh]![3])
            case .middleLeft, .bottomLeft:
                return CGPoint(x: deviceWidgets[wxh]![0], y: deviceWidgets[wxh]![4])
            case .middleRight, .bottomRight:
                return CGPoint(x: deviceWidgets[wxh]![1], y: deviceWidgets[wxh]![4])
            }
        } else {
            switch widgetPos {
            case .topLeft:
                return CGPoint(x: deviceWidgets[wxh]![0], y: deviceWidgets[wxh]![3])
            case .topRight:
                return CGPoint(x: deviceWidgets[wxh]![1], y: deviceWidgets[wxh]![3])
            case .middleLeft:
                return CGPoint(x: deviceWidgets[wxh]![0], y: deviceWidgets[wxh]![4])
            case .middleRight:
                return CGPoint(x: deviceWidgets[wxh]![1], y: deviceWidgets[wxh]![4])
            case .bottomLeft:
                return CGPoint(x: deviceWidgets[wxh]![0], y: deviceWidgets[wxh]![5])
            case .bottomRight:
                return CGPoint(x: deviceWidgets[wxh]![1], y: deviceWidgets[wxh]![5])
            }
            
        }
    }
    
    //中组件位置枚举
    enum MediumWidgetSizeEnum {
        case top
        case middle
        case bottom
    }
    // 中组件。获取在不同位置的x,y坐标
    func getMiddleWidgetPosition(_ widgetPos: MediumWidgetSizeEnum)-> CGPoint{
        let wxh:String =  "\(Int(UIScreen.main.bounds.size.width))x\(Int(UIScreen.main.bounds.size.height))"
        // TODO 外层做异常处理。告知用户 “您的机型暂不支持透明组件”
        if !deviceWidgets.keys.contains(wxh) {
            return CGPoint(x: -1, y: -1)
        }
        
        switch widgetPos {
        case .top:
            return CGPoint(x: deviceWidgets[wxh]![0], y: deviceWidgets[wxh]![3])
        case .middle:
            return CGPoint(x: deviceWidgets[wxh]![0], y: deviceWidgets[wxh]![4])
        case .bottom:
            return wxh == "320x568"
            ? CGPoint(x: deviceWidgets[wxh]![0], y: deviceWidgets[wxh]![4])
            :CGPoint(x: deviceWidgets[wxh]![0], y: deviceWidgets[wxh]![5])
        }
    }
    
    //大组件位置枚举
    enum LargeWidgetSizeEnum {
        case top
        case bottom
        case unknown
    }
    // 大组件。获取在不同位置的x,y坐标
    func getLargeWidgetPosition(_ widgetPos: LargeWidgetSizeEnum)->CGPoint{
        let wxh:String =  "\(Int(UIScreen.main.bounds.size.width))x\(Int(UIScreen.main.bounds.size.height))"
        // TODO 外层做异常处理。告知用户 “您的机型暂不支持透明组件”
        if !deviceWidgets.keys.contains(wxh) {
            return CGPoint(x: -1, y: -1)
        }
        
        if(wxh == "320x568") {
            return CGPoint(x: deviceWidgets[wxh]![0], y: deviceWidgets[wxh]![3])
        } else {
            switch widgetPos {
            case .top:
                return CGPoint(x: deviceWidgets[wxh]![0], y: deviceWidgets[wxh]![3])
            case .bottom:
                return CGPoint(x: deviceWidgets[wxh]![0], y: deviceWidgets[wxh]![4])
            case .unknown:
                return CGPoint(x: 0, y: 0)
            }
        }
    }
    
    func getRectWithType(_ type: Int) -> (CGRect, String) {
        var rect = CGRect.zero
        var point = CGPoint.zero
        var size = CGSize.zero
        var currentType = ""
        if type == 1  {
            size = MQWidgetSize().getWidgetSize(.small)
            point = MQWidgetSize().getSmallWidgetPosition(.topLeft)
            currentType = AppGroupConst.smallTopLeft
        } else if type == 2  {
            size = MQWidgetSize().getWidgetSize(.small)
            point = MQWidgetSize().getSmallWidgetPosition(.topRight)
            currentType = AppGroupConst.smallTopRight
        } else if type == 3  {
            size = MQWidgetSize().getWidgetSize(.small)
            point = MQWidgetSize().getSmallWidgetPosition(.middleLeft)
            currentType = AppGroupConst.smallCenterLeft
        } else if type == 4  {
            size = MQWidgetSize().getWidgetSize(.small)
            point = MQWidgetSize().getSmallWidgetPosition(.middleRight)
            currentType = AppGroupConst.smallCenterRight
        } else if type == 5  {
            size = MQWidgetSize().getWidgetSize(.small)
            point = MQWidgetSize().getSmallWidgetPosition(.bottomLeft)
            currentType = AppGroupConst.smallBottomLeft
        } else if type == 6 {
            size = MQWidgetSize().getWidgetSize(.small)
            point = MQWidgetSize().getSmallWidgetPosition(.bottomRight)
            currentType = AppGroupConst.smallBottomRight
        } else if type == 7  {
            size = MQWidgetSize().getWidgetSize(.medium)
            point = MQWidgetSize().getMiddleWidgetPosition(.top) // getMiddleWidgetPosition
            currentType = AppGroupConst.mediumTop
        } else if type == 8  {
            size = MQWidgetSize().getWidgetSize(.medium)
            point = MQWidgetSize().getMiddleWidgetPosition(.middle) // getMiddleWidgetPosition
            currentType = AppGroupConst.mediumCenter
        } else if type == 9  {
            size = MQWidgetSize().getWidgetSize(.medium)
            point = MQWidgetSize().getMiddleWidgetPosition(.bottom) // getMiddleWidgetPosition
            currentType = AppGroupConst.mediumBottom
        } else if type == 10  {
            size = MQWidgetSize().getWidgetSize(.large)
            point = MQWidgetSize().getLargeWidgetPosition(.top) // getLargeWidgetPosition
            currentType = AppGroupConst.largeTop
        } else if type == 11  {
            size = MQWidgetSize().getWidgetSize(.large)
            point = MQWidgetSize().getLargeWidgetPosition(.bottom) // getLargeWidgetPosition
            currentType = AppGroupConst.largeBottom
        }
        rect = CGRect(x: point.x,
                      y: point.y,
                      width: size.width,
                      height: size.height)
        return (rect, currentType)
        
    }
}
