//
//  WidgetExtensionBundle.swift
//  WidgetExtension
//
//  Created by 吴琼 on 2023/7/31.
//

import WidgetKit
import SwiftUI

@main
struct WidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        SmallWidget()
        MediumWidget()
        LargeWidget()
        if #available(iOSApplicationExtension 16.1, *) {
            WidgetExtensionLiveActivity()
        }
    }
}
