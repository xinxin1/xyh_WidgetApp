//
//  DynamicPhoto.swift
//  WidgetApp
//
//  Created by HS-jianxin on 2023/8/3.
//

import Foundation
import SwiftUI


/// 文本处理
struct DynamicPhoto: View {
    var singleContent: PhotoSingleModel
    var size: CGSize
    
    /// 获取共有属性模型
    func getShareContent() -> SharedAttModel{
        return singleContent.sharedContent!
    }
    
    
    /// 根据展示类型 处理不同逻辑
    func kkk() -> any Equatable {
        if singleContent.contentType == .singlePhoto {
            return Image(singleContent.photos?.first ?? "")
        }
        
        return Image("")
    }
    
    var body: some View {
        if singleContent.contentType == .singlePhoto {
            Image(singleContent.photos?.first ?? "")
                .resizable()
                .offset(x: ((getShareContent().offset?.first)! * size.width) as CGFloat, y: ((getShareContent().offset?.last)! * size.height) as CGFloat)
                .frame(width: (getShareContent().size?.first)! * size.width, height: (getShareContent().size?.last)! * size.height)
        }
        
    }
}

