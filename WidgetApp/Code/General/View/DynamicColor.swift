//
//  DynamicColor.swift
//  WidgetApp
//
//  Created by HS-jianxin on 2023/8/3.
//

import Foundation
import SwiftUI


/// 文本处理
struct DynamicColor: View {
    var singleContent: ColorSingleModel
    var size: CGSize
    
    
    /// 获取共有属性模型
    func getShareContent() -> SharedAttModel{
        return singleContent.sharedContent!
    }
    func getColor() -> UIColor {
        let r = singleContent.color?.first
        return UIColor(red: r![0], green: r![1], blue: r![2], alpha: r![3])
    }
    
    var body: some View {
        Color(getColor())
            .offset(x: ((getShareContent().offset?.first)! * size.width) as CGFloat, y: ((getShareContent().offset?.last)! * size.height) as CGFloat)
            .frame(width: (getShareContent().size?.first)! * size.width, height: (getShareContent().size?.last)! * size.height)
            .rotationEffect(Angle(degrees: getShareContent().rotate ?? 0))
            .opacity(getShareContent().alpha ?? 0)
            .cornerRadius(getShareContent().cornerRadius ?? 0)
    }
}
