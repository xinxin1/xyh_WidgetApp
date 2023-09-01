//
//  AppGroupConst.swift
//  WidgetApp
//
//  Created by 李昆明 on 2023/8/9.
//

import Foundation

public enum AppGroup: String {
    case defaultGroup = "group.com.smartclean.storagecleaner" // group.com.widget.top.WidgetApp
    
    public var containerURL: URL {
        switch self {
        case .defaultGroup:
            return FileManager.default.containerURL(
                forSecurityApplicationGroupIdentifier: self.rawValue)!
        }
    }
}
struct AppGroupConst {
    static let defaultSelect = "default"
    static let darkMode = "darkMode"
    static let currentSmallSubTag = "currentSmallSubTag"
    static let currentMediumSubTag = "currentMediumSubTag"
    static let currentLargeSubTag = "currentLargeSubTag"
    static let updateHomeWidget = "updateHomeWidget"

    static let smallTopLeft = "smallTopLeft"
    static let smallTopRight = "smallTopRight"
    static let smallCenterLeft = "smallCenterLeft"
    static let smallCenterRight = "smallCenterRight"
    static let smallBottomLeft = "smallBottomLeft"
    static let smallBottomRight = "smallBottomRight"
    
    static let mediumTop = "mediumTop"
    static let mediumCenter = "mediumCenter"
    static let mediumBottom = "mediumBottom"
    
    static let largeTop = "largeTop"
    static let largeBottom = "largeBottom"
}
