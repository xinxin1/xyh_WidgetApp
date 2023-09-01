//
//  DynamicColor.swift
//  WidgetApp
//
//  Created by HS-jianxin on 2023/8/3.
//

import Foundation
import SwiftUI


/// 动态颜色处理
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
//            .cornerRadius(10)
            .cornerRadius(getShareContent().cornerRadius ?? 0)
            .offset(x: ((getShareContent().offset?.first)! * size.width) as CGFloat, y: ((getShareContent().offset?.last)! * size.height) as CGFloat)
            .frame(width: (getShareContent().size?.first)! * size.width, height: (getShareContent().size?.last)! * size.height)
            .rotationEffect(Angle(degrees: getShareContent().rotate ?? 0))
            .opacity(getShareContent().alpha ?? 0)
//            .background(RoundedCorners(color: .red, tl: getShareContent().cornerRadius ?? 0, tr: getShareContent().cornerRadius ?? 0, bl: getShareContent().cornerRadius ?? 0, br: getShareContent().cornerRadius ?? 0))
    }
}



struct RoundedCorners: View {
    var color: Color = .clear
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0
    var bl: CGFloat = 0
    var br: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let w = geometry.size.width
                let h = geometry.size.height
                
                let tr = min(min(self.tr, h/2), w/2)
                let tl = min(min(self.tl, h/2), w/2)
                let bl = min(min(self.bl, h/2), w/2)
                let br = min(min(self.br, h/2), w/2)
                
                path.move(to: CGPoint(x: w/2.0, y: 0))
                path.addLine(to: CGPoint(x: w - tr, y: 0))
                path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
                path.addLine(to: CGPoint(x: w, y: h - br))
                path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
                path.addLine(to: CGPoint(x: bl, y: h))
                path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
                path.addLine(to: CGPoint(x: 0, y: tl))
                path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
            }
            .fill(self.color)
        }
    }
}
