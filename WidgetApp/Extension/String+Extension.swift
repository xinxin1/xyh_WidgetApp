//
//  String+Extension.swift
//  WidgetApp
//
//  Created by HS-jianxin on 2023/8/15.
//

import Foundation

//MARK: - 内存计算
extension String {
    
    /// 将Byte转成其他单位数据
    static func intByteToString(diskSpace: Int64) -> String {
        // 计算规则 1000
        if diskSpace < 1000 {
            return "\(diskSpace) B"
        }
        else if diskSpace < 1000 * 1000 {
            return String(format: "%0.2f KB", Float(diskSpace)/1000)
        }
        else if diskSpace < 1000 * 1000 * 1000 {
            return String(format: "%0.2f MB", Float(diskSpace)/(1000*1000))
        }
        else if diskSpace < 1000 * 1000 * 1000 * 1000 {
            return String(format: "%0.2f GB", Float(diskSpace)/(1000*1000*1000))
        }
        return String(format: "%0.2f TB", Float(diskSpace)/(1000*1000*1000*1000))
    }
}
