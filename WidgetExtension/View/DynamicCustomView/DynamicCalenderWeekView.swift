//
//  DynamicCalenderWeekView.swift
//  WidgetApp
//
//  Created by HS-jianxin on 2023/8/14.
//

import Foundation
import SwiftUI

struct CustomWeekCalendarView: View {
    var singleModel: CompositeViewModel
    var size: CGSize
    var widgetEnvironment: WidgetsEnvironment
    
    let calendar = Calendar.current
//    let daysOfWeek = ["日", "一", "二", "三", "四", "五", "六"]
    @State private var selectedDate: Date = Date()//.dateAdd(year: 0, month: 0, day: 7)
    

    var body: some View {
        let p = getContentAtt()["padding"] as? [CGFloat] ?? [0, 0, 0, 0]
        
        VStack {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7)) {
                ForEach(1...daysOfWeek().count, id: \.self) { day in
                    
                    if singleModel.contentAtt!.keys.contains("calendarDaySelectBg") {
                        Text(daysOfWeek()[day - 1])
                            .font(getFont())
                            .frame(width: getWH(), height: getWH(), alignment: .center)
                            .background(daySelectBgImage(for: day - 1))
                            .foregroundColor(dayForegroundColor(for: day - 1))
                            .clipShape(Circle())
                            .minimumScaleFactor(0.2)
                    }else {
                        Text(daysOfWeek()[day - 1])
                            .font(getFont())
                            .frame(width: getWH(), height: getWH(), alignment: .center)
                            .background(dayBackgroundColor(for: day - 1))
                            .foregroundColor(dayForegroundColor(for: day - 1))
                            .clipShape(Circle())
                            .minimumScaleFactor(0.2)
                    }
                    
                }
            }
            .padding(EdgeInsets(top: p[0], leading: p[1], bottom: p[2], trailing: p[3]))
        }
    }
    /// Att
    private func getContentAtt() -> [String: Any] {
        return singleModel.contentAtt!
    }
    /// 正常状态颜色，前景色，背景色
    private func getColors() -> [Color] {
        let colors = getContentAtt()["colors"] as! [[CGFloat]]
        let ncolor = colors[0]  //正常颜色 数组
        let fcolor = colors[1]  //选中前景色 数组
        let scolor = colors[2] //选中背景色 数组
        let titleNormalColor = colors.count > 3 ? colors[3] : ncolor //星期标题 正常前景色
        let titleSelectColor = colors.count > 4 ? colors[4] : fcolor //星期标题 选中前景色
        
        return [Color(UIColor(red: ncolor[0], green: ncolor[1], blue: ncolor[2], alpha: ncolor[3])),
                Color(UIColor(red: fcolor[0], green: fcolor[1], blue: fcolor[2], alpha: fcolor[3])),
                Color(UIColor(red: scolor[0], green: scolor[1], blue: scolor[2], alpha: scolor[3])),
                Color(UIColor(red: titleNormalColor[0], green: titleNormalColor[1], blue: titleNormalColor[2], alpha: titleNormalColor[3])),
                Color(UIColor(red: titleSelectColor[0], green: titleSelectColor[1], blue: titleSelectColor[2], alpha: titleSelectColor[3])),
        ]
    }
    /// 获取字体
    private func getFont() -> Font {
        let fontName = (getContentAtt()["font"] ?? "") as! String
        let fontSize = (getContentAtt()["fontSize"] ?? CGFloat(14.0)) as! CGFloat
        return Font(UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize))
    }
    
    // 获取 （本月天数，前方空白天数）
    private func daysInMonth(date: Date) -> (count: Int, space: Int) {
        guard let range = calendar.range(of: .day, in: .month, for: date) else {
            return (0, 0)
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        let newDateStr = formatter.string(from: date) + "-01"
        formatter.dateFormat = "yyyy-MM-dd"
        let pdate = formatter.date(from: newDateStr)!
        let space = calendar.component(.weekday, from: pdate) - 1
        return (range.count, space)
    }

    /// 日期选中的背景色
    private func dayBackgroundColor(for day: Int) -> Color {
        let sweekday = calendar.component(.weekday, from: selectedDate)
        let firstWeekday = getContentAtt()["unit"] as! Int
        let pindex = (sweekday + 7 - firstWeekday) % 7
        return day == pindex ? getColors()[2] : .clear
    }
    /// 日期选中的背景图
    private func daySelectBgImage(for day: Int) -> Image {
        let sweekday = calendar.component(.weekday, from: selectedDate)
        let firstWeekday = getContentAtt()["unit"] as! Int
        let pindex = (sweekday + 7 - firstWeekday) % 7
        
        if singleModel.contentAtt!.keys.contains("calendarDaySelectBg") { //由图片生成Color
//            if widgetEnvironment == .App { // 如果是APP展示，这里暂定从Documents拿
//                return day == pindex ? Image(uiImage: UIImage(contentsOfFile: NSHomeDirectory() + "/Documents/" + (getContentAtt()["calendarDaySelectBg"] as! String)) ?? UIImage()).resizable() : Image("")
//            }
//            else if widgetEnvironment == .Widget {  // 如果是widget，图片从group获取
//                daySelectBgColor = Color(UIColor(patternImage: UIImage(contentsOfFile: NSHomeDirectory() + "/Documents/" + (getContentAtt()["calendarDaySelectBg"] as! String)) ?? UIImage()))
//            }
            return Image(uiImage: UIImage(named: (getContentAtt()["calendarDaySelectBg"] as! String)) ?? UIImage())
        }
        return Image("")
    }
    /// 前景色
    private func dayForegroundColor(for day: Int) -> Color {
        let sweekday = calendar.component(.weekday, from: selectedDate)
        let firstWeekday = getContentAtt()["unit"] as! Int
        let pindex = (sweekday + 7 - firstWeekday) % 7
        return day == pindex ? getColors()[1] : getColors()[0]
    }

    /// 获取宽度 高度
    private func getWH() -> CGFloat {
        return (getContentAtt()["itemWH"] as? CGFloat ?? 0.0857) * size.height
    }
    
    
    /// 获取一周内文本
    private func daysOfWeek() -> [String] {
        return getContentAtt()["imageNames"] as! [String]
    }
    
    

    
    
}


