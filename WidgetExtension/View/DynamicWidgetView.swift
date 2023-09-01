//
//  DynamicWidgetView.swift
//  WidgetApp
//
//  Created by HS-jianxin on 2023/8/3.
//

import Foundation
import SwiftUI
import WidgetKit

enum WidgetsEnvironment {
    case App        // APP内
    case Widget     // widget上
}

/// 动态生成的View
struct DynamicWidgetView: View {
    var widgetEnvironment: WidgetsEnvironment
    var contents: [SuperSingleViewModel]
    var entry: TimelineEntry
    
    var body: some View {
        GeometryReader() { geo in
            ForEach(contents, id: \.self) { model in
                if model.viewType == .text {
                    DynamicText(singleContent: (model as! TextSingleModel), size: geo.size, widgetEnvironment: widgetEnvironment, entry: entry)
                }
                else
                if model.viewType == .photo {
                    if let photoModel = model as? PhotoSingleModel {
                        DynamicPhoto(singleContent: photoModel, size: geo.size, widgetEnvironment: widgetEnvironment, entry: entry)
                    } else {
                        Text("Photo转换失败")
                            .foregroundColor(.red)
                    }
                }
                else if model.viewType == .color {
                    if let colorModel = model as? ColorSingleModel {
                        DynamicColor(singleContent: colorModel, size: geo.size)
                    } else {
                        Text("Color转换失败")
                            .foregroundColor(.red)
                    }
                }
                else if model.viewType == .view {
                    if let compositeModel = model as? CompositeViewModel {
                        DynamicView(singleContent: compositeModel, size: geo.size, widgetEnvironment: widgetEnvironment)
//                        Text("CompositeModel转换成功")
                    } else {
                        Text("CompositeModel 转换时失败")
                            .foregroundColor(.red)
                    }
                }
                else if model.viewType == .circle {
                    if let circleModel = model as? ColorSingleModel {
                        DynamicCircle(singleContent: circleModel, size: geo.size)
                    } else {
                        Text("Circle转换失败")
                            .foregroundColor(.red)
                    }
                }
                else {
                    Text(verbatim: "ViewType Not match")
                }
            }
        }
        .ignoresSafeArea()
    }
    
    
}












//struct DynamicWidgetView_Preview: PreviewProvider {
//
//    static func getTestModel() -> WidgetModel {
//        let sss = "{\"topTagId\":1,\"categoryId\":1,\"widgetId\":1,\"widgetType\":1,\"desktopAudio\":{\"isOpen\":false,\"audioPath\":\"\",\"notifiTitle\":\"\",\"notifiContent\":\"\"},\"editCategory\":[1,2,3],\"navigationURL\":\"\",\"contents\":[{\"viewType\":4,\"sharedContent\":{\"offset\":[0.5,0.5],\"size\":[0.1,0.1],\"rotate\":0,\"alpha\":1,\"cornerRadius\":0,\"shadow\":{\"color\":[[1,1,1,1]],\"radius\":5,\"offset\":[5,5]}},\"contentType\":11,\"contentAtt\":[]}]}"
//
//        let wmodel = WidgetModel.deserialize(from: sss)
//        return wmodel!
//    }
//
//
//    static var previews: some View {
//        DynamicWidgetView(model: getTestModel())
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//
//    }
//}





//MARK: - json


/**
 框架
 {"topTagId":1,"categoryId":1,"widgetId":1,"widgetType":2,"desktopAudio":{"isOpen":false,"audioPath":"","notifiTitle":"","notifiContent":""},"editCategory":[1,2,3],"navigationURL":"","contents":[]}
 */

/**
 图片
 {"viewType":2,"sharedContent":{"offset":[0,0],"size":[1,1],"rotate":0,"alpha":1,"cornerRadius":0,"shadow":{"color":[[0,0,0,1]],"radius":5,"offset":[5,5]}},"contentType":7,"contentAtt":[["weekday7.png","weekday1.png","weekday2.png","weekday3.png","weekday4.png","weekday5.png","weekday6.png"],"weekday"],"photos":[],"photosMaxCount":1,"photosOrder":1,"intervalTime":0}
 */

/**
 颜色
 {"viewType":3,"sharedContent":{"offset":[0,0],"size":[1,1],"rotate":0,"alpha":1,"cornerRadius":0,"shadow":{"color":[[1,1,1,0]],"radius":0,"offset":[0,0]}},"contentType":0,"contentAtt":[],"color":[[0.09,0.637,0.551,1]]}
 */

/**
 文本
 {"viewType":4,"sharedContent":{"offset":[0.079,0.16],"size":[0.456,0.09],"rotate":0,"alpha":1,"cornerRadius":0,"shadow":{"color":[[0,0,0,1]],"radius":5,"offset":[5,5]}},"contentType":9,"contentAtt":[],"font":"TsangerYuYangT","fontSize":16,"textColor":[[0,0,0,1]],"textAlignment":0,"lineLimit":1,"minScale":0.2,"format":"yyyy.MM.dd"}
 */
