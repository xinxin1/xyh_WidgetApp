//
//  DynamicCalenderView.swift
//  WidgetApp
//
//  Created by HS-jianxin on 2023/8/8.
//

import Foundation
import SwiftUI

struct CustomMonthCalendarView: View {
    var singleModel: CompositeViewModel
    var size: CGSize
    var widgetEnvironment: WidgetsEnvironment
    
    let calendar = Calendar.current
    let daysOfWeek = ["日", "一", "二", "三", "四", "五", "六"]
    @State private var selectedDate: Date = Date() //.dateAdd(year: 0, month: 13, day: 0)
    

    var body: some View {
        VStack {
//            HStack {
//                Button(action: {
//                    navigateToPreviousMonth()
//                }) {
//                    Image(systemName: "chevron.left")
//                        .font(.headline)
//                }
//                .padding(.trailing, 8)
//
//                Text(monthYearFormatter.string(from: selectedDate))
//                    .font(.title)
//                    .padding(.bottom, 10)
//
//                Button(action: {
//                    navigateToNextMonth()
//                }) {
//                    Image(systemName: "chevron.right")
//                        .font(.headline)
//                }
//                .padding(.leading, 8)
//            }

            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7)) {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(getFont())
                        .frame(width: getWH(), height: getWH(), alignment: .center)
                        .foregroundColor(weekdayForegroundColor(for: day))
                }
            }

            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7)) {
                ForEach(1...daysInMonth(date: selectedDate).count + daysInMonth(date: selectedDate).space, id: \.self) { day in
                    
                    if singleModel.contentAtt!.keys.contains("calendarDaySelectBg") {
                        Text(day <= daysInMonth(date: selectedDate).space ? "" : "\(day - daysInMonth(date: selectedDate).space)")
                            .font(getFont())
    //                        .padding(8)
                            .frame(width: getWH(), height: getWH(), alignment: .center)
//                            .background(daySelectBgImage().resizable())
                            .background(daySelectBgImage(for: day - daysInMonth(date: selectedDate).space))
                            .foregroundColor(dayForegroundColor(for: day - daysInMonth(date: selectedDate).space))
                            .clipShape(Circle())
    //                        .onTapGesture {
    //                            selectDate(day: day)
    //                        }
                    }else {
                        Text(day <= daysInMonth(date: selectedDate).space ? "" : "\(day - daysInMonth(date: selectedDate).space)")
                            .font(getFont())
    //                        .padding(8)
                            .frame(width: getWH(), height: getWH(), alignment: .center)
                            .background(dayBackgroundColor(for: day - daysInMonth(date: selectedDate).space))
                            .foregroundColor(dayForegroundColor(for: day - daysInMonth(date: selectedDate).space))
                            .clipShape(Circle())
    //                        .onTapGesture {
    //                            selectDate(day: day)
    //                        }
                    }
                    
                }
            }
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
        
        let titleNormalColor = colors.count > 3 ? colors[3] : [0,0,0,1] //星期标题 正常前景色
        let titleSelectColor = colors.count > 4 ? colors[4] : [0,0,0,1] //星期标题 选中前景色
        
        
        
        
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
        let fontSize = (getContentAtt()["fontSize"] ?? 14.0) as! CGFloat
        return Font(UIFont(name: fontName, size: fontSize)!)
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
        let isCurrentMonth = calendar.isDate(selectedDate, equalTo: Date(), toGranularity: .month)
        let isSelected = calendar.isDate(selectedDate, equalTo: date(withDay: day), toGranularity: .day)
        return isCurrentMonth && isSelected ? getColors()[2] : .clear
    }
    /// 日期选中的背景图
    private func daySelectBgImage(for day: Int) -> Image {
        let isCurrentMonth = calendar.isDate(selectedDate, equalTo: Date(), toGranularity: .month)
        let isSelected = calendar.isDate(selectedDate, equalTo: date(withDay: day), toGranularity: .day)
        if singleModel.contentAtt!.keys.contains("calendarDaySelectBg") { //由图片生成Color
            if widgetEnvironment == .App { // 如果是APP展示，这里暂定从Documents拿
                return isCurrentMonth && isSelected ? Image(uiImage: UIImage(contentsOfFile: NSHomeDirectory() + "/Documents/" + (getContentAtt()["calendarDaySelectBg"] as! String)) ?? UIImage()).resizable() : Image("")
            }
            else if widgetEnvironment == .Widget {  // 如果是widget，图片从group获取
//                daySelectBgColor = Color(UIColor(patternImage: UIImage(contentsOfFile: NSHomeDirectory() + "/Documents/" + (getContentAtt()["calendarDaySelectBg"] as! String)) ?? UIImage()))
            }
        }
        return Image("")
    }
    /// 前景色
    private func dayForegroundColor(for day: Int) -> Color {
        let isCurrentMonth = calendar.isDate(selectedDate, equalTo: Date(), toGranularity: .month)
        let isSelected = calendar.isDate(selectedDate, equalTo: date(withDay: day), toGranularity: .day)
        return isCurrentMonth && isSelected ? getColors()[1] : getColors()[0]
    }
    /// 星期 前景色
    private func weekdayForegroundColor(for day: String) -> Color {
        let isCurrentMonth = calendar.isDate(selectedDate, equalTo: Date(), toGranularity: .month)
        let pindex = calendar.component(.weekday, from: selectedDate)
        let isSelected = daysOfWeek[pindex-1] == day
        return isCurrentMonth && isSelected ? getColors()[4] : getColors()[3]
    }
    /// 获取宽度 高度
    private func getWH() -> CGFloat {
        return (getContentAtt()["itemWH"] as? CGFloat ?? 0.105) * size.height
//        return 14.7
    }
    

    // 根据索引获取日期
    private func date(withDay day: Int) -> Date {
        var components = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        components.day = day
        return calendar.date(from: components) ?? Date()
    }
    
    
    
    
    //MARK: 以下暂时不用
    
    @State private var monthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }() //标题使用，这里无用

    // 选中日期 ： 这里无效，不用管
    private func selectDate(day: Int) {
        var components = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        components.day = day
        guard let updatedDate = calendar.date(from: components) else {
            return
        }
        selectedDate = updatedDate
    }
    
    // 上月，这里无用
    private func navigateToPreviousMonth() {
        guard let previousMonth = calendar.date(byAdding: .month, value: -1, to: selectedDate) else {
            return
        }
        selectedDate = previousMonth
    }
    // 下月，这里无用
    private func navigateToNextMonth() {
        guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: selectedDate) else {
            return
        }
        selectedDate = nextMonth
    }
}





