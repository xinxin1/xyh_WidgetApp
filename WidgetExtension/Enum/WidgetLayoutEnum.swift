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
    case layout = 1                 // 布局
    case photo = 2                  // 图片
    case color = 3                  // 颜色
    case text = 4                   // 文字
    case gradient = 5               // 渐变色
    case view = 6                   // 复合视图
    case circle = 7                 // 圆
}




//MARK: - 显示内容类型枚举
/// 显示内容类型枚举
enum WidgetContentTypeEnum: Int, HandyJSONEnum, Hashable {
    case none = 0                           //无关
    case singlePhoto = 1                    //单张图片
    case photos = 2                         //图片列表
    case scrollPhotos = 3                   //滚动图片列表
    case electricity = 4                    //电量
    case health = 5                         //健康与运动
    case distance = 6                       //距离（双人相距距离）
    case calendar = 7                       //常规日历
    case countdown = 8                      //倒计时
    case date = 9                           //日期
    case time = 10                          //时间
    case text = 11                          //正常文本
    case memorialday = 12                   //纪念日，正计时
    case textedit = 13                      //可编辑文本，可以在编辑页面输入改变文本内容
    case clock = 14                         //时钟
    case motto = 15                         //格言&星座，每日一句
    case calendar_week = 16                 //日历(周)
    case wifi = 17                          //wifi
    case bluetooth = 18                     //蓝牙
    case device = 19                        //设备信息
    case reminder = 20                      //提醒事项
    case horoscope = 21                     //星座预测
    case weather = 22                       //天气
}



//MARK: - 设备信息类型枚举
/// 设备信息类型枚举
enum DeviceInfoTypeEnum: Int, HandyJSONEnum, Hashable {
    case none = 0
    case storageTotal = 1                   //总内存
    case storageUsed = 2                    //内存已使用
    case storageFree = 3                    //内存剩余
    case iPhoneModel = 4                    //手机型号（例如：iPhone 12 Pro）
    case iOSVersion = 5                     //手机系统版本
}


//MARK: - 健康与运动类型 枚举
/// 健康与运动类型 枚举
enum HealthInfoTypeEnum: Int, HandyJSONEnum, Hashable {
    case none = 0
    case stepCount = 1                      //步数
    case distanceWalkingRunning = 2         //距离，走路跑步
    case energyBurned = 3                   //能量消耗，基础+运动
}



//MARK: - 星座类型 枚举
/// 星座类型 枚举
enum HoroscopeInfoTypeEnum: Int, HandyJSONEnum, Hashable {
    case none = 0
    case description = 1                    //长段描述信息
    case love = 2                           //爱情运势
    case career = 3                         //事业运势
    case wealth = 4                         //财富运势
    case health = 5                         //健康运势
    case luckyColor = 6                     //幸运颜色
    case luckyNumber = 7                    //幸运数字
    case luckyDirection = 8                 //幸运方位
    case nobleConstellation = 9             //贵人星座
    case constellationName = 10             //星座名称
}



//MARK: - 天气类型 枚举
/// 天气类型 枚举
enum WeatherInfoTypeEnum: Int, HandyJSONEnum, Hashable {
    case none = 0                           //无关
    case location = 1                       //地理位置
    case temperature = 2                    //当前温度
    case textOrIcon = 3                     //天气状况
    case tempMin = 4                        //当日最低温度
    case tempMax = 5                        //当日最高温度
    case timeText = 6                       //日期或时间 显示文本
    case windDirAndScale = 7                //风向与等级(东南风三级)
    case pm2_5 = 8                          //PM2.5
    case humidity = 9                       //湿度
    case ultraviolet = 10                   //紫外线
    case comfort = 11                       //舒适度
}
