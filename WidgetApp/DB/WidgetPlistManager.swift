//
//  WidgetPlistManager.swift
//  WidgetApp
//
//  Created by 李昆明 on 2023/8/9.
//

import Foundation
import UIKit

public struct TransparentData {
    static private func plist() -> AllWidgetSize? {
        var xmlFormat = PropertyListSerialization.PropertyListFormat.xml
        guard let path = Bundle.main.path(forResource: "transparents", ofType: "plist") else { return nil }
        guard let data = FileManager.default.contents(atPath: path) else { return nil }
        do {
            let dic = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: &xmlFormat)
            if let dict = dic as? [String: Any] {
                let jsonData = try JSONSerialization.data(withJSONObject: dict)
                let transparentOptions = try JSONDecoder().decode(AllWidgetSize.self, from: jsonData)
                return transparentOptions
            }
        } catch  {
            return nil
        }
        return nil
    }
    static public func getAllSmallPlist() -> [WidgetTransparentName]? {
        let plists = plist()?.allSmall
        return plists 
    }
    static public func getAllMediumPlist() -> [WidgetTransparentName]? {
        let plists = plist()?.allMedium
        return plists
    }
    static public func getAllLargePlist() -> [WidgetTransparentName]? {
        let plists = plist()?.allLarge
        return plists
    }
    // MARK: 通过identifier获取保存的Image
//    func getCurrentImage(identifier: String, isDark: Bool) -> UIImage? {
//        if let imageRealmModel = WidgetDBManager.queryOneModel(identifier).first {
////            return UIImage(contentsOfFile: isDark ? imageRealmModel.darkImageName : imageRealmModel.imageName)
//            let imagePath = isDark
//            ? getDBImageFullPath(imageName: imageRealmModel.darkImageName ?? "")
//            : getDBImageFullPath(imageName: imageRealmModel.imageName ?? "")
//            return UIImage(contentsOfFile: imagePath)
//        }
//        return nil
//    }
//    private func getDBImageFullPath(imageName: String) -> String {
//        let pathURL = WidgetDBManager.getWidgetFileURL()
//        guard let fileURL = pathURL?.appendingPathComponent(imageName) else { return "" }
//        if #available(iOS 16.0, *) {
//            return fileURL.path()
//        } else {
//            // Fallback on earlier versions
//            return fileURL.path
//        }
//    }
}
public struct AllWidgetSize: Codable {
    let allSmall: [WidgetTransparentName]
    let allMedium: [WidgetTransparentName]
    let allLarge: [WidgetTransparentName]
}
public struct WidgetTransparentName: Codable {
    let key: String
    let name: String
}
