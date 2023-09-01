//
//  DynamicReminderListView.swift
//  WidgetApp
//
//  Created by HS-jianxin on 2023/8/16.
//

import Foundation
import SwiftUI
import EventKit

//MARK: 提醒事项 列表
struct DynamicReminderListView: View {
    var singleModel: CompositeViewModel
    var size: CGSize //widget大小
    var widgetEnvironment: WidgetsEnvironment
    
//    @State private var reminders = [EKReminder]()
    
    
    
    var body: some View {
        let reminders = reminderList()
        let shareContent = singleModel.sharedContent!
        let color = getColor()
        let lineColor = getLineColor()
        let font = (singleModel.contentAtt?["font"] ?? "") as! String
        let fontSize = (singleModel.contentAtt?["fontSize"] ?? 9) as! CGFloat
        let padding = (singleModel.contentAtt?["padding"] ?? [0,0,0,0]) as! [CGFloat]
        let height = ((singleModel.contentAtt?["itemWH"] ?? 0.0714) as! CGFloat) * size.height
        
        
        ForEach(0..<reminders.count, id: \.self) { index in
            let reminderTitle = reminders[index].title!

            if index != 0 {
                Color(lineColor)
                    .offset(x: 0, y:(height * CGFloat(index)) as CGFloat)
                    .frame(width: (shareContent.size?.first)! * size.width, height: 1)
            }

            Text(reminderTitle)
                .offset(x: 0, y: (height * CGFloat(index)) as CGFloat)
                .frame(width: (shareContent.size?.first)! * size.width, height: height, alignment: .leading)
                .foregroundColor(color)
                .font(Font.custom(font, size: fontSize))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .padding(EdgeInsets(top: padding[0], leading: padding[1], bottom: padding[2], trailing: padding[3]))
            
        }
    }
    
    
    
    // 按需获取提醒事项列表
    func reminderList() -> [EKReminder]{
        // 给定最多展示多少条数据
        let count: Int = (singleModel.contentAtt?["unit"] ?? 5) as! Int
        // 获取提醒事项
        return Array(ReminderAuthManager.allReminders().prefix(count))
    }
    // 获取文字颜色
    func getColor() -> Color {
        let scolor = ((singleModel.contentAtt?["colors"] as? [[CGFloat]])?.first ?? [1,1,1,1])
        return Color(UIColor(red: scolor[0], green: scolor[1], blue: scolor[2], alpha: scolor[3]))
    }
    // 获取分割线颜色
    func getLineColor() -> UIColor {
        let scolor = ((singleModel.contentAtt?["colors"] as? [[CGFloat]])?.first ?? [1,1,1,1])
        return UIColor(red: scolor[0], green: scolor[1], blue: scolor[2], alpha: scolor[3]*0.3)
    }
    
    
    
    
}
