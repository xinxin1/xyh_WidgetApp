//
//  WidgetEnum.swift
//  WidgetApp
//
//  Created by HS-jianxin on 2023/8/2.
//

import Foundation
import HandyJSON

//MARK: 小部件相关枚举


//MARK: - widget类型枚举

/// Widget类型
enum WidgetTypeEnum: Int, HandyJSONEnum {
    case systemSmall = 1            //桌面小部件
    case systemMedium               //桌面中型部件
    case systemLarge                //桌面大型部件
    case accessoryCircular          //锁屏圆形部件
    case accessoryRectangular       //锁屏矩形部件
    case accessoryInline            //锁屏条形部件
    case systemExtraLarge           //桌面超大部件（iPad）
}




//MARK: - 编辑分类枚举

/// Widget编辑页面 展示的分类
enum EditCategoryEnum: Int, HandyJSONEnum {
    case background = 1     //背景
    case font               //字体
    case desktopAudio       //桌面音频
    
    static func parse(_ t: [Int]) -> [EditCategoryEnum] {
        var arr = [EditCategoryEnum]()
        t.forEach { dd in
            arr.append(EditCategoryEnum(rawValue: dd) ?? .background)
        }
        return arr
    }
}



//MARK: - 图片顺序

/// 图片排序
enum DisplayOrderEnum: Int, HandyJSONEnum {
    case normal = 1         //正序（正向）
    case inverse            //倒序（反向）
}




//MARK: - 文本类
/// 文本 对齐方式
enum TextAlignmentEnum: Int, HandyJSONEnum {
    case leading = 0        //居左
    case center             //居中
    case trailing           //居右
}
