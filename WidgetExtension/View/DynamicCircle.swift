//
//  DynamicCircle.swift
//  WidgetApp
//
//  Created by HS-jianxin on 2023/8/11.
//

import Foundation
import SwiftUI


/// 动态圆处理
struct DynamicCircle: View {
    var singleContent: ColorSingleModel
    var size: CGSize
    
    
    /// 获取共有属性模型
    func getShareContent() -> SharedAttModel{
        return singleContent.sharedContent!
    }
    func getColor() -> UIColor {
        let timelinedate = Date()//.addingTimeInterval(3600*24*4) //当前时间
        
        var r = [0.0,0.0,0.0,0.0]
        switch singleContent.contentType {
        case .calendar:
            // contentAtt {"colors":[每日颜色], "unit":以什么为单位循环}
            let set: Set<Calendar.Component> = TimeEnum.parseUnitToComponent(unit: singleContent.contentAtt!["unit"] as! Int)
            if set.isEmpty == false {
                let comps = Calendar.current.dateComponents(set, from: timelinedate)
                let colors = singleContent.contentAtt?["colors"] as! [[Double]]
                r = colors[(comps.weekday! - 1)]
            }
        default:
            r = (singleContent.color?.first)!
        }
        return UIColor(red: r[0], green: r[1], blue: r[2], alpha: r[3])
    }
    
    var body: some View {
        Circle()
            .fill(Color(getColor()))
            .offset(x: ((getShareContent().offset?.first)! * size.width) as CGFloat, y: ((getShareContent().offset?.last)! * size.height) as CGFloat)
            .frame(width: (getShareContent().size?.first)! * size.width, height: (getShareContent().size?.last)! * size.height)
            .opacity(getShareContent().alpha ?? 0)
    }
}
