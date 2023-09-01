//
//  WidgetLayoutEnum.swift
//  WidgetApp
//
//  Created by HS-jianxin on 2023/8/2.
//

import Foundation
import HandyJSON


//MARK: Widget布局 枚举


//MARK: - 视图类型枚举
/// 视图类型枚举
enum WidgetViewTypeEnum: Int, HandyJSONEnum, Hashable {
    case layout = 1             // 布局
    case photo = 2                  // 图片
    case color = 3                  // 颜色
    case text = 4                // 文字
    case gradient = 5               // 渐变色
    case view = 6                   // 复合视图
}




//MARK: - 显示内容类型枚举
/// 显示内容类型枚举
enum WidgetContentTypeEnum: Int, HandyJSONEnum, Hashable {
    case none = 0                       //无关
    case singlePhoto = 1                //单张图片
    case photos                         //图片列表
    case scrollPhotos                   //滚动图片列表
    case electricity                    //电量
    case stepCount                      //步数
    case distance                       //距离（双人相距距离）
    case calendar                       //常规日历
    case countdown                      //倒计时
    case date                           //日期
    case time                           //时间
    case text = 11                      //正常文本
}

