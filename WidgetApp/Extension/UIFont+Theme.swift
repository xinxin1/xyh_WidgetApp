//
//  UIFont+Theme.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/16.
//

import Foundation

extension UIFont {
    class func YouSheBiaoTiHei(with size: CGFloat) -> UIFont {
        return UIFont(name: "YouSheBiaoTiHei", size: size) ?? UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    
    class func kNYuanMo(with size: CGFloat) -> UIFont {
        return UIFont(name: "KingnamypeYuanmoSC", size: size) ?? UIFont.systemFont(ofSize: size, weight: .semibold)
    }
}
