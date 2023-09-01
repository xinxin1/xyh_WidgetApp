//
//  DynamicView.swift
//  WidgetApp
//
//  Created by HS-jianxin on 2023/8/8.
//

import Foundation
import SwiftUI

/// 复合视图处理
struct DynamicView: View {
    var singleContent: CompositeViewModel
    var size: CGSize
    var widgetEnvironment: WidgetsEnvironment
    
    
    /// 获取共有属性模型
    func getShareContent() -> SharedAttModel{
        return singleContent.sharedContent!
    }
    
    
    var body: some View {
        
        if singleContent.contentType == .calendar {
            CustomMonthCalendarView(singleModel: singleContent, size: size, widgetEnvironment: widgetEnvironment)
                .cornerRadius(getShareContent().cornerRadius ?? 0)
                .offset(x: ((getShareContent().offset?.first)! * size.width) as CGFloat, y: ((getShareContent().offset?.last)! * size.height) as CGFloat)
                .frame(width: (getShareContent().size?.first)! * size.width, height: (getShareContent().size?.last)! * size.height)
                .rotationEffect(Angle(degrees: getShareContent().rotate ?? 0))
                .opacity(getShareContent().alpha ?? 0)
        }
        else if singleContent.contentType == .calendar_week {
            CustomWeekCalendarView(singleModel: singleContent, size: size, widgetEnvironment: widgetEnvironment)
                .cornerRadius(getShareContent().cornerRadius ?? 0)
                .offset(x: ((getShareContent().offset?.first)! * size.width) as CGFloat, y: ((getShareContent().offset?.last)! * size.height) as CGFloat)
                .frame(width: (getShareContent().size?.first)! * size.width, height: (getShareContent().size?.last)! * size.height)
                .rotationEffect(Angle(degrees: getShareContent().rotate ?? 0))
                .opacity(getShareContent().alpha ?? 0)
        }
        else if singleContent.contentType == .reminder {
            DynamicReminderListView(singleModel: singleContent, size: size, widgetEnvironment: widgetEnvironment)
//                .cornerRadius(getShareContent().cornerRadius ?? 0)
                .offset(x: ((getShareContent().offset?.first)! * size.width) as CGFloat, y: ((getShareContent().offset?.last)! * size.height) as CGFloat)
//                .frame(width: (getShareContent().size?.first)! * size.width, height: (getShareContent().size?.last)! * size.height)
                .rotationEffect(Angle(degrees: getShareContent().rotate ?? 0))
                .opacity(getShareContent().alpha ?? 0)
        }
    }
}


