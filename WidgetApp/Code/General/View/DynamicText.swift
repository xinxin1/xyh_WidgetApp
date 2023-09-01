//
//  DynamicText.swift
//  WidgetApp
//
//  Created by HS-jianxin on 2023/8/3.
//

import Foundation
import SwiftUI


/// 文本处理
struct DynamicText: View {
    var singleContent: TextSingleModel
    var size: CGSize
    
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
    /// 获取显示内容
    func getTextContent() -> String {
        var str = ""
        
        switch singleContent.contentType {
            case .text: //普通文本
                str = singleContent.format ?? ""
            case .date, .time: //日期
                let dateFormater = DateFormatter()
//                dateFormater.setLocalizedDateFormatFromTemplate(singleContent.format!)
                dateFormater.dateFormat = singleContent.format
                str = dateFormater.string(from: Date())
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
//        if singleContent.contentType == .text {
            Text(getTextContent())
                .offset(x: ((getShareContent().offset?.first)! * size.width) as CGFloat, y: ((getShareContent().offset?.last)! * size.height) as CGFloat)
                .frame(width: (getShareContent().size?.first)! * size.width, height: (getShareContent().size?.last)! * size.height, alignment: getAlignment())
                .foregroundColor(Color(getTextColor()))
                .font(Font.custom(singleContent.font ?? "", size: singleContent.fontSize ?? 16))
                .lineLimit(singleContent.lineLimit)
                .minimumScaleFactor(singleContent.minScale ?? 0.5)
//        }
    }
}
