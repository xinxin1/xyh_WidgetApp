//
//  PermissionItem.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/10.
//

import Foundation

struct PermissionItem {

    var image: String?
    var title: String?
    var content: String?
    var state: StateType = .NotDetermined
    var type: PermissionType = .advertisment
    
    init(title: String? = nil, image: String? = nil, content: String? = nil, state: StateType = .NotDetermined, type: PermissionType = .advertisment) {
        self.image = image
        self.title = title
        self.content = content
        self.state = state
        self.type = type
    }
}

enum StateType: CustomStringConvertible {
    case NotDetermined, Denied, Authorized, Limited
    
    var description: String {
        switch self {
        case .NotDetermined:
            return "去设置"
        case .Denied:
            return "已拒绝"
        case .Authorized:
            return "已授权"
        case .Limited:
            return "部分授权"
        }
    }
    
    var color: UIColor {
        switch self {
        case .NotDetermined:
            return UIColor(hexString: "#644BFF")!
        case .Denied:
            return UIColor(hexString: "#F02D63")!
        case .Authorized:
            return UIColor(hexString: "#A9ABB8")!
        case .Limited:
            return UIColor.orange
        }
    }
}

enum PermissionType: CustomStringConvertible, CaseIterable {
    case location, camera, album, bluetooth, sportAndHealth, advertisment
    
    var displayName: String {
        switch self {
        case .location:
            return "定位"
        case .camera:
            return "相机"
        case .album:
            return "相册"
        case .bluetooth:
            return "蓝牙"
        case .sportAndHealth:
            return "运动与健康"
        case .advertisment:
            return "个性化广告"
        }
    }
    
    var description: String {
        switch self {
        case .location:
            return "用于获取地理位置展示当前天气信息，好友距离，周围商家信息，定位当前位置"
        case .camera:
            return "用于识别二维码，用于拍摄、录制"
        case .album:
            return "用于小组件个性化配图设置、透明背景设置、小应用照片上传"
        case .bluetooth:
            return "用于X-面板小组件展示蓝牙状态"
        case .sportAndHealth:
            return "用于展示您的步数到小组件、分享你的步数给好友"
        case .advertisment:
            return "若你不想接受个性化广告服务，你可以点击相应按钮进行关闭。若你选择关闭，你看到的广告数量不会减少，但本产品将不再向你展示个性化广告，你看到的广告可能将与你的偏好相关度降低。"
        }
    }
    
    var image: String {
        switch self {
        case .location:
            return "more_permission_location_icon"
        case .camera:
            return "more_permission_camera_icon"
        case .album:
            return "more_permission_album_icon"
        case .bluetooth:
            return "more_permission_bluetooth_icon"
        case .sportAndHealth:
            return "more_permission_health_icon"
        case .advertisment:
            return "more_permission_ad_icon"
        }
    }
    
    var state: StateType {
        switch self {
        case .location:
            return .NotDetermined
        case .camera:
            return .NotDetermined
        case .album:
            return .NotDetermined
        case .bluetooth:
            return .NotDetermined
        case .sportAndHealth:
            return .NotDetermined
        case .advertisment:
            return .NotDetermined
        }
    }
}

class PermissionManager {
    
    static func getPermissionData() -> [PermissionItem] {
        
        var items: [PermissionItem] = []
        
        for iCase in PermissionType.allCases {
            let item = PermissionItem(title: iCase.displayName,
                                      image: iCase.image,
                                      content: iCase.description,
                                      state: iCase.state,
                                      type: iCase)
            
            items.append(item)
        }
        
        return items
    }
}
