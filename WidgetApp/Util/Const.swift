//
//  Const.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/7/31.
//

import Foundation
import UIKit

@_exported import SHFullscreenPopGestureSwift
@_exported import SnapKit

//IAP
let IAPSecret = ""
let kWeekProductID = ""

let kAppStoreID = ""

/// 获取设备语言
let language = UIDevice.deviceLanguage()

/// 获取bundle identifier
let kBundleId = Bundle.main.bundleIdentifier ?? ""

/// 获取bundle name
let kBundleName = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String ?? ""

/// 获取app名
let kAppName = "Widget"

/// 获取Build
let kBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as! String

/// 获取Veision
let kVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String

/// 获取屏幕尺寸
let ScreenBounds = UIScreen.main.bounds

/// 获取屏宽
let ScreenWidth: CGFloat = ScreenBounds.width

/// 获取屏高
let ScreenHeight: CGFloat = ScreenBounds.height

/// 获取缩放比例
let ScreenScale = UIScreen.main.scale

/// navigationBar 的静态高度
let NavigationBarHeight: CGFloat = 44

/// 工具类
let tool = WidgetTool()

func dPrint(_ item: @autoclosure () -> Any) {
    #if DEBUG
    print(item())
    #endif
}



//MARK: - Key

let kTransparentWidgetAppearance = "kAllowDarkAppearanceCapture"
