//
//  File.swift
//  WidgetApp
//
//  Created by HS-jianxin on 2023/8/2.
//

import Foundation
import HandyJSON


//MARK: 组件属性 相关类型

//MARK: - 桌面音频模型

/// 桌面音频
struct DesktopAudioModel: HandyJSON, Hashable {
    var isOpen: Bool?               //桌面音频是否打开
    var audioPath: String?          //音频地址
    var notifiTitle: String?        //通知标题
    var notifiContent: String?      //通知内容
    
    static func == (lhs: DesktopAudioModel, rhs: DesktopAudioModel) -> Bool {
        return false
    }
}




//MARK: - 公共属性 模型

/// 公共属性 模型
class SharedAttModel: HandyJSON, Hashable, Identifiable, ObservableObject {
//    let identifier: UUID = UUID()
    var offset: [CGFloat]?              //中心位置（%）[x,y]
    var size: [CGFloat]?                //大小（%）[w,h]
    var rotate: Double?                 //旋转角度(0~360)
    var alpha: Double?                  //透明度
    var cornerRadius: Double?           //圆角大小
    var shadow: shadowAttModel?              //阴影模型
    
    required init() {
        
    }
    
    var identifier: String {
        return UUID().uuidString
    }

    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    static func == (lhs: SharedAttModel, rhs: SharedAttModel) -> Bool {
        return false
    }
    
}



//MARK: - 阴影 模型
/// 阴影 模型
class shadowAttModel: HandyJSON, Hashable, Identifiable {

    var color: [[Double]]?               //颜色 [r,g,b,a]
//    var alpha: Double?
//    var cornerRadius: Double?           //圆角大小
    var radius: CGFloat?                //半径(%)
    var offset: [CGFloat]?              //偏移 [x,y]
    
    required init() {
        
    }
    
    var identifier: String {
        return UUID().uuidString
    }

    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    static func == (lhs: shadowAttModel, rhs: shadowAttModel) -> Bool {
        return false
    }
}
