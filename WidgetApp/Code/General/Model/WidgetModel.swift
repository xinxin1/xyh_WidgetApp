//
//  WidgetModel.swift
//  WidgetApp
//
//  Created by HS-jianxin on 2023/8/2.
//

import Foundation
import HandyJSON


//MARK: 组件 相关类型


//MARK: - 组件 模型
/// 组件 模型
class WidgetModel: HandyJSON, Hashable, Identifiable {
    var topTagId: Int?                          //顶部标签ID
    var categoryId: Int?                        //分类ID
    var widgetId: Int?                          //widget Id
    var widgetType: WidgetTypeEnum?             //widget类型 大中小等
    var desktopAudio: DesktopAudioModel?        //桌面音频
    var editCategory: [EditCategoryEnum]?       //编辑页面展示类别
    var navigationURL: String?                  //widget点击跳转
    var contents: [SuperSingleViewModel]?       //子视图列表
    
    required init() {
        
    }
    init(topTagId: Int? = nil, categoryId: Int? = nil, widgetId: Int? = nil, desktopAudio: DesktopAudioModel? = nil, editCategory: [EditCategoryEnum]? = nil, navigationURL: String? = nil, contents: [SuperSingleViewModel]? = nil) {
        self.topTagId = topTagId
        self.categoryId = categoryId
        self.widgetId = widgetId
        self.desktopAudio = desktopAudio
        self.editCategory = editCategory
        self.navigationURL = navigationURL
        self.contents = contents
    }
    
    class func parseJSON(str: String) -> WidgetModel {
        let model = WidgetModel()
        
        let data = str.data(using: .utf8)
        let dict = try? JSONSerialization.jsonObject(with: data!, options: .fragmentsAllowed)
        if dict != nil {
            let dic = dict as! [String: Any]
            model.topTagId = dic["topTagId"] as? Int
            model.categoryId = dic["categoryId"] as? Int
            model.widgetId = dic["widgetId"] as? Int
            model.widgetType = WidgetTypeEnum(rawValue: dic["widgetType"] as! Int)
            model.desktopAudio = DesktopAudioModel.deserialize(from: (dic["desktopAudio"] as? Dictionary))
            model.editCategory = EditCategoryEnum.parse(dic["editCategory"] as! [Int])
            model.navigationURL = dic["navigationURL"] as? String
            model.contents = SuperSingleViewModel.parse(arr: dic["contents"] as! [[String : Any]])
        }
        return model
    }
    
    
    
    var identifier: String {
        return UUID().uuidString
    }
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    static func == (lhs: WidgetModel, rhs: WidgetModel) -> Bool {
        return false
    }
}




//MARK: - 子视图 模型
/// 子视图 父类
class SuperSingleViewModel: HandyJSON, Hashable, Identifiable {
    
    var viewType: WidgetViewTypeEnum?           //视图类型：文本、图片或者其他
    var sharedContent: SharedAttModel?          //共有属性
    var contentType: WidgetContentTypeEnum?     //内容类型
    var contentAtt: [Any]?                      //内容类型所需要相关配置（待用，例如电量图片变化节点等）
    
    required init() {

    }
    init(viewType: WidgetViewTypeEnum? = nil, sharedContent: SharedAttModel? = nil, contentType: WidgetContentTypeEnum? = nil, contentAtt: [Any]?) {
        self.sharedContent = sharedContent
        self.contentType = contentType
        self.viewType = viewType
        self.contentAtt = contentAtt
    }
    
    
    
    class func parse(arr: [[String: Any]]) -> [SuperSingleViewModel] {
        var models = [SuperSingleViewModel]()
        arr.forEach { item in
            let viewType = WidgetViewTypeEnum(rawValue: item["viewType"] as! Int)
            var model: SuperSingleViewModel?
            if viewType == .color {
                model = ColorSingleModel.deserialize(from: item)
            }else if viewType == .gradient {
                model = GradientSingleModel.deserialize(from: item)
            }else if viewType == .photo {
                model = PhotoSingleModel.deserialize(from: item)
            }else if viewType == .text {
                model = TextSingleModel.deserialize(from: item)
            }else if viewType == .view {
                model = CompositeViewModel.deserialize(from: item)
//            }else if viewType == .layout {
//                model = GradientSingleModel.deserialize(from: item)
            }
            if model != nil {
                models.append(model!)
            }
        }
        return models
    }
    
    
    
    
    
    var identifier: String {
//        return UUID().uuidString
        return String(arc4random())
    }

    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    static func == (lhs: SuperSingleViewModel, rhs: SuperSingleViewModel) -> Bool {
        return false
    }
}



/// 图片 子视图模型
class PhotoSingleModel: SuperSingleViewModel {
    var photos: [String]?                   //图片地址/名称 列表
    var photosMaxCount: Int?                //图片列表最大限度
    var photosOrder: DisplayOrderEnum?      //图片滚动方向
    var intervalTime: Double?               //间隔时间（动画等需要）
}



/// 颜色 子视图模型
class ColorSingleModel: SuperSingleViewModel {
    var color: [[Double]]?                    //色值 rgba
}



/// 文本 子视图模型
class TextSingleModel: SuperSingleViewModel {
    var font: String?                           //字体名称
    var fontSize: CGFloat?                      //字号
    var textColor: [[Double]]?                  //字体颜色 [r,g,b,a],多个时，文本是渐变色
    var textAlignment: TextAlignmentEnum?        //对齐方式
    var lineLimit: Int?                         //行数
    var minScale: CGFloat?                      //字体最小缩放
    var format: String?                         //格式化样式（时间、日期等需要）
}



/// 渐变色 子视图模型
class GradientSingleModel: SuperSingleViewModel {
    var colors: [[Double]]?                     //颜色 [r,g,b,a]
    var points: [[CGFloat]]?                    //颜色始末点 [[0,0],[1,1]]
    
    /**
     // LinearGradient 线性渐变
     LinearGradient(
         colors: [.red, .blue, .green],
         startPoint: .top,
         endPoint: .bottom
     )
     
     
     - 渐变还有其他种类：
     
     径向渐变RadialGradient
     RadialGradient(
         colors: [.red, .blue, .green],
         center: .center,
         startRadius: 300,
         endRadius: 100
     )
     
     角渐变
     AngularGradient(
         colors: [.red, .blue, .green, .red],
         center: .center,
         startAngle: Angle(degrees: 0),
         endAngle: Angle(degrees: 360)
     )
     
     椭圆渐变
     EllipticalGradient(
         colors: [.red, .blue, .green],
         center: .center,
         startRadiusFraction: 0.5,
         endRadiusFraction: 0.5
     )
     */
}



/// 复合视图 复杂子视图模型
class CompositeViewModel: SuperSingleViewModel {
    // 主要考虑一些视图不好进行拆解，例如日历类，相互之间有关联性
}


