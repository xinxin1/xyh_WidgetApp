//
//  GeneralEnum.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/17.
//

import Foundation

enum GeneralWidgetType: Int,CustomStringConvertible {
    case small, medium, large, extraLarge, inline, circular, rectangular
    
    var imageSize: CGSize {
        switch self {
        case .inline:
            return CGSize(width: ScreenWidth - 40, height: (ScreenWidth - 40) * 45 / 335)
            
        case .small:
            return CGSize(width: (ScreenWidth - 80) / 3, height: (ScreenWidth - 80) / 3)

        case .medium:
            return CGSize(width: (ScreenWidth - 80) * 2 / 3 + 20, height: (ScreenWidth - 80) / 3)
        case .large:
            return CGSize(width: (ScreenWidth - 55) / 2, height: (ScreenWidth - 55) / 2)

        case .extraLarge:
            return CGSize(width: (ScreenWidth - 55) / 2, height: (ScreenWidth - 55) / 2)
            
        case .circular:
            return CGSize(width: (ScreenWidth - 70) / 4, height: (ScreenWidth - 70) / 4)
            
        case .rectangular:
            return CGSize(width: ScreenWidth / 2 - 20, height: (ScreenWidth - 70) / 4)
        }
    }
    
    var description: String {
        switch self {
        case .small:
            return "小号"
        case .medium:
            return "中号"
        case .large:
            return "大号"
        case .extraLarge:
            return "特大号"
        case .inline:
            return "圆形"
        case .circular:
            return "矩形"
        case .rectangular:
            return "条形"
        }
    }
}
