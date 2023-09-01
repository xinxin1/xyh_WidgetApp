//
//  DynamicWidgetView.swift
//  WidgetApp
//
//  Created by HS-jianxin on 2023/8/3.
//

import Foundation
import SwiftUI
import WidgetKit


/// 动态生成的View
struct DynamicWidgetView: View {
//    var model: WidgetModel
    var contents: [SuperSingleViewModel]
    
    var body: some View {
        GeometryReader { geo in
            ForEach(contents) { model in
                if model.viewType == .text {
                    DynamicText(singleContent: (model as! TextSingleModel), size: geo.size)
                }
                else if model.viewType == .photo {
                    DynamicPhoto(singleContent: (model as! PhotoSingleModel), size: geo.size)
                }
                else if model.viewType == .color {
                    DynamicColor(singleContent: (model as! ColorSingleModel), size: geo.size)
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
