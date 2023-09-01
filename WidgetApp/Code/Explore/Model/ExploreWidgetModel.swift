//
//  ExploreWidgetModel.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/15.
//

import UIKit
import HandyJSON

struct ExploreWidgetModel: HandyJSON {
  
    // main info
    /// ID
    var widgetId: String = ""
    
    /// 名称
    var widgetName: String = ""
    
    /// 模版类型
    var viewType: String = ""
    
    ///大小类型
    var sizeType: Int = 0
    
    ///预览图
    var previewImage: String = ""
    
    ///采购类型： 0、免费，1、付费，2、广告
    var puarchaseType: String = ""
    
    ///资源地址
    var resourceUrl: String = ""
    
    ///素材大小
    var resourceSize: Double = 0.0
    
    ///封面角标
    var coverMark: String = ""
    
    ///是否推荐到首页（0、不推荐，1、推荐）
    var homeFlag: String = ""
    
    ///JSON格式配置信息
    var jsonConfig: String = ""
    
    ///标签ID列表
    var tagIds: [String]?
    
    // overhead info
    ///点击计数
    var clickCount: String = ""
    
    ///安装计数
    var installCount: String = ""
    
    ///排序
    var sortNum: String = ""
        
    ///使用状态（0、正常， 1、停用）
    var status: String = ""
    
    ///创建人
    var createBy: String = ""
    
    /// 创建时间
    var createTime: String = ""
    
    ///修改人
    var updateBy: String = ""
    
    /// 修改时间
    var updateTime: String = ""
    
    ///备注
    var remark: String = ""

    // calculate property
    ///对应组件种类
    var widgetType: GeneralWidgetType {
        return GeneralWidgetType.init(rawValue: sizeType) ?? .small
    }
    
    ///是否是vip资源
    var isVip: Bool {
        return !(puarchaseType == "0" || app_purchased)
    }
    
    // default instance
    static let defaultSmall = ExploreWidgetModel(widgetName: "倒数日", sizeType: 0, previewImage: "", puarchaseType: "0")
    
    static let defaultMedium = ExploreWidgetModel(widgetName: "照片墙", sizeType: 1, previewImage: "more_top_subscribe_bg", puarchaseType: "1")
    
    static let defaultLarge = ExploreWidgetModel(widgetName: "健康", sizeType: 2, previewImage: "more_friend_header_bg", puarchaseType: "1")
}


struct WidgetCategory: HandyJSON {
    var categoryId: String?
    var categoryName:String?
    var categorySection: [WidgetSection]?
}


struct WidgetSection: HandyJSON {
    var sectionName: String?
    var sectionImage: String?
    var sectionWidgets: [ExploreWidgetModel]?
}


