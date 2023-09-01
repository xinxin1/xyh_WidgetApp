//
//  UIDevice+Extension.swift
//  WidgetApp
//
//  Created by HS-jianxin on 2023/8/15.
//

import Foundation
import UIKit


//MARK: - 手机型号
extension UIDevice {
    //获取设备具体详细的型号
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let platform = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
         
        switch platform {
            case "iPhone1,1": return "iPhone 2G"
            case "iPhone1,2": return "iPhone 3G"
            case "iPhone2,1": return "iPhone 3GS"
            
            case "iPhone3,1", "iPhone3,2", "iPhone3,3": return "iPhone 4"
            case "iPhone4,1": return "iPhone 4S"
            
            case "iPhone5,1", "iPhone5,2": return "iPhone 5"
            case "iPhone5,3", "iPhone5,4": return "iPhone 5C"
            case "iPhone6,1", "iPhone6,2": return "iPhone 5S"
            
            case "iPhone7,1": return "iPhone 6 Plus"
            case "iPhone7,2": return "iPhone 6"
            case "iPhone8,1": return "iPhone 6S"
            case "iPhone8,2": return "iPhone 6S Plus"
            
            case "iPhone8,4", "iPhone12,8", "iPhone14,6": return "iPhone SE"
            
            case "iPhone9,1": return "iPhone 7"
            case "iPhone9,2": return "iPhone 7 Plus"
            
            case "iPhone10,1", "iPhone10,4": return "iPhone 8"
            case "iPhone10,2", "iPhone10,5": return "iPhone 8 Plus"
            
            case "iPhone10,3", "iPhone10,6": return "iPhone X"
            
            case "iPhone11,2": return "iPhone XS"
            case "iPhone11,4", "iPhone11,6": return "iPhone XS Max"
            
            case "iPhone11,8": return "iPhone XR"
            
            case "iPhone12,1": return "iPhone 11"
            case "iPhone12,3": return "iPhone 11 Pro"
            case "iPhone12,5": return "iPhone 11 Pro Max"
            
            case "iPhone13,1": return "iPhone 12 mini"
            case "iPhone13,2": return "iPhone 12"
            case "iPhone13,3": return "iPhone 12 Pro"
            case "iPhone13,4": return "iPhone 12 Pro Max"
            
            case "iPhone14,2": return "iPhone 13 Pro"
            case "iPhone14,3": return "iPhone 13 Pro Max"
            case "iPhone14,4": return "iPhone 13 mini"
            case "iPhone14,5": return "iPhone 13"
            
            case "iPhone14,7": return "iPhone 14"
            case "iPhone14,8": return "iPhone 14 Plus"
            case "iPhone15,2": return "iPhone 14 Pro"
            case "iPhone15,3": return "iPhone 14 Pro Max"
            
            
            
            
            
            
            case "iPod1,1": return "iPod Touch 1G"
            case "iPod2,1": return "iPod Touch 2G"
            case "iPod3,1": return "iPod Touch 3G"
            case "iPod4,1": return "iPod Touch 4G"
            case "iPod5,1": return "iPod Touch 5G"
            case "iPod7,1": return "iPod Touch 6G"
            
            
            
            
            
            case "iPad1,1": return "iPad 1"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return "iPad 2"
            case "iPad2,5", "iPad2,6", "iPad2,7": return "iPad Mini 1"
            case "iPad3,1", "iPad3,2", "iPad3,3": return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6": return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3": return "iPad Air"
            case "iPad4,4", "iPad4,5", "iPad4,6": return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9": return "iPad Mini 3"
            case "iPad5,1", "iPad5,2": return "iPad Mini 4"
            case "iPad5,3", "iPad5,4": return "iPad Air 2"
            case "iPad6,3", "iPad6,4": return "iPad Pro 9.7"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4", "iPad8,9", "iPad8,10", "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7": return "iPad Pro 11"
            case "iPad6,7", "iPad6,8", "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8", "iPad8,11", "iPad8,12", "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11": return "iPad Pro 12.9"
            case "iPad11,1", "iPad11,2", "iPad14,1", "iPad14,2": return "iPad Mini"
            
            
            
            
            
            
            
            case "AppleTV2,1": return "Apple TV 2"
            case "AppleTV3,1", "AppleTV3,2": return "Apple TV 3"
            case "AppleTV5,3": return "Apple TV 4"
            
            
            
            
            
            case "i386": return "iPhone Simulator"
            case "x86_64": return "iPhone Simulator"
        default:
            return "unknown iPhone"
        }
    }
}
