//
//  SmallWidget.swift
//  SmallWidget
//
//  Created by 吴琼 on 2023/7/31.
//

import WidgetKit
import SwiftUI
import Intents

struct SmallWidgetProvider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> SmallWidgetEntry {
        SmallWidgetEntry(date: Date(), identifier: "", contents: [])
    }

    func getSnapshot(for configuration: SmallConfigurationIntent, in context: Context, completion: @escaping (SmallWidgetEntry) -> ()) {
        let entry = SmallWidgetEntry(date: Date(), identifier: configuration.transparent?.identifier ?? "", contents: [])
        completion(entry)
    }

    func getTimeline(for configuration: SmallConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var contents: [SuperSingleViewModel] = []
        if let displayString = configuration.widget?.displayString,
           let dbModel = WidgetDataManager.shared.getUserSelectSmallWidget(subTagID: displayString) {
            // 第一步保存当前subTagID
            UserDefaults(suiteName: AppGroup.defaultGroup.rawValue)?.set(displayString, forKey: AppGroupConst.currentSmallSubTag)
            // 第二步将contents数据给数据模型MediumWidgetEntry
            let m = WidgetModel.parseJSON(str: dbModel.contents ?? "")
            if let localContents = m.contents {
                contents = localContents
            }
        }
        let entry = SmallWidgetEntry(date: Date(), identifier: configuration.transparent?.identifier ?? "",contents: contents)
        let nextUpdate = Calendar.current.date(byAdding: DateComponents(second: 5), to: Date())!
        let timeLine = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeLine)
    }
}

struct SmallWidgetEntry: TimelineEntry {
    var date: Date
    var identifier: String
    var contents: [SuperSingleViewModel]
}

struct SmallWidgetEntryView : View {
    var entry: SmallWidgetProvider.Entry
    private let isDark = UserDefaults(suiteName: AppGroup.defaultGroup.rawValue)?.bool(forKey: AppGroupConst.darkMode) ?? false
    private let currentSmallSubTag = UserDefaults(suiteName: AppGroup.defaultGroup.rawValue)?.string(forKey: AppGroupConst.currentSmallSubTag) ?? ""

    var body: some View {
        if let dbModel = WidgetDataManager.shared.getUserSelectSmallWidget(subTagID: currentSmallSubTag) {
            let m = WidgetModel.parseJSON(str: dbModel.contents ?? "")
            if let contents = m.contents {
                DynamicWidgetView(widgetEnvironment: .Widget, contents: contents, entry: entry)
            } else {
                Text("数据库没有获取到数据\n getUserSelectMediumWidget")
            }
        }
    }
}


//struct SmallWidgetEntryView : View {
//    var entry: SmallWidgetProvider.Entry
//    private let isDark = UserDefaults(suiteName: AppGroup.defaultGroup.rawValue)?.bool(forKey: AppGroupConst.darkMode) ?? false
//    private let currentSmallSubTag = UserDefaults(suiteName: AppGroup.defaultGroup.rawValue)?.string(forKey: AppGroupConst.currentSmallSubTag) ?? ""
//
//    var body: some View {
//        Text("")
//    }
//}


struct SmallWidget: Widget {
    let kind: String = "SmallWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SmallConfigurationIntent.self, provider: SmallWidgetProvider()) { entry in
            SmallWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("小号")
        .description("选择你想要的组件尺寸添加到桌面")
    }
}



