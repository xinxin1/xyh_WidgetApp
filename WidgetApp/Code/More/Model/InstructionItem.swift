//
//  InstructionItem.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/10.
//

import Foundation

struct InstructionItem {
    var image: String?
    var title: String?
    var content: String?
    
    init(title: String? = nil, image: String? = nil, content: String? = nil) {
        self.image = image
        self.title = title
        self.content = content
    }
    
    //组件限制说明
    static let widgetRestrictionItems = [
        InstructionItem(title: "组件数据和状态刷新不是实时的", image: "more_widget_restriction_refresh_icon", content: "ios14优化保护电池寿命机制导致\n\n主屏幕小组件由 ios系统自动刷新，添加到桌面的小组件(除时钟小组件外)，刷新状态可能存在延迟，且小组件的每日刷新存在上限。所以桌面小组件会有时看起来停止工作，或与系统更新不一致。受影响的功能包括蓝牙、WiFi、蜂窝数据及步数统计等。\n\n当再次进入APP后，桌面小组件会强制刷新。所以，当小小组件状态长时问未刷新时，请再次进入【灵动桌面】状态将会刷新。"),
        
        InstructionItem(title: "点击组件将打开APP的限制", image: "more_widget_restriction_tap_icon", content: "桌面小组件仅支持轻点打开APP操作\n\n根据ios系统要求，添加到桌面的小组件仅支持【点击并打开提供功能的APP】操作，故而每次轻触桌面小组件后，将会打开【灵动桌面】。"),
        
        InstructionItem(title: "小组件下方APP名称不可去除", image: "more_widget_restriction_edit_icon", content: "该名称不可更改或去掉\n\n在iOS系统中，使用 APP 名称来区分各小组件功能。苹果官方要求第三方组件必须显示软件 名称，故而APP名称在原则上是不可去除或更改的。")
    ]
    
    //常见问题
    static let problemSummaryItems = [
        InstructionItem(title: "常见问题", image: "more_question_common_icon"),
        InstructionItem(title: "图标手册", image: "more_question_iconBook_icon")]
    
    //常见问题
    static let problemDetailItems = [
        InstructionItem(title: "VIP权益的相关问题", image: "more_question_hot_icon",content: "尊敬的用户，您好。\n 本产品内的部分组件为VIP专享，如果您想无限制使用所有组件，可以升级为VIP会员，同时去除App内全部广告。\n最后，感谢您的信任和支持，我们将继续努力提供更好的产品服务。"),
        
        InstructionItem(title: "电池类组件与手机系统不同步", image: "more_question_hot_icon",content: "非常抱歉，由于iOS设备自身刷新频率限制，数据可能存在延迟，可尝试重启App或重新添加组件。"),
        
        InstructionItem(title: "时间类组件与手机系统不同步",content: "建议将升级手机系统至最新版本，或重新添加组件。"),
        
        InstructionItem(title: "小组件组件显示蓝屏",content: "建议取消组件的自定义背景，或重启手机。"),
        
        InstructionItem(title: "如何设置透明组件",content: "首先在App主页上方设置透明组件背景，设置成功之后回到桌面长按小组件编辑，选择透明背景进行设置\n取消：长按小组件一编辑-透明背景-跟随App"),
        
        InstructionItem(title: "壁纸上传提示尺寸错位",content: "解决步骤：通用-设置-显示及亮度-视图-设定为标准，然后重新截图上传。"),
        
        InstructionItem(title: "怎么修改桌面组件下方的名称",content: "应苹果官方要求：组件下方必须展示软件名称，所以无法去掉或者自定义"),
        
        InstructionItem(title: "组件内容没有刷新",content: "桌面添加过多个组件可能会导致刷新受限制，可以尝试从App-更多-清除缓存，或重启App后重新添加组件。 "),
        
        InstructionItem(title: "在桌面添加组件时找不到App",content: "在ios14.5 及以上系统，手机长时间开机会出现找不到App无法添加组件的情况，针对 iOS系统存在的这个问题，您可以\n 尝试以下两种方法：\n方法1：重启手机后-＞再打开一次本软件->前往桌面再次尝试添加\n方法2：打开手机设置->通用->还原->还原主屏幕布局->前往桌面再次尝试添加")
    ]
    
    static let iconBookItems = [
        InstructionItem(title: "快捷启动点击图标为什么需要二次跳转",content: "非常抱歉，由于iOS14.5 以后的系统，苹果修改了相关权限，我们无法通过快捷方式直接打开目标APP。" ),
        
        InstructionItem(title: "图标没有更新", content: "由于苹果系统刷新频率限制，可以尝试从App-更多-清除缓存，或重启App后重新添加组件。")
    ]
}
