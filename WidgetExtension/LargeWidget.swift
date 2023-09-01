//
//  LargeWidget.swift
//  WidgetExtensionExtension
//
//  Created by 李昆明 on 2023/8/9.
//

import WidgetKit
import SwiftUI
import Intents

struct LargeWidgetProvider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> LargeWidgetEntry {
        LargeWidgetEntry(date: Date(), identifier: "", contents: [])
    }

    func getSnapshot(for configuration: LargeConfigurationIntent, in context: Context, completion: @escaping (LargeWidgetEntry) -> ()) {
        let entry = LargeWidgetEntry(date: Date(), identifier: configuration.selection?.identifier ?? "", contents: [])
        completion(entry)
    }

    func getTimeline(for configuration: LargeConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        var entries: [LargeWidgetEntry] = []
//        let currentDate = Date()
//        for secondOffset in 0 ..< 60 {
//            let entryDate = Calendar.current.date(byAdding: .second, value: secondOffset, to: currentDate)!
//            let entry = LargeWidgetEntry(date: entryDate,identifier: configuration.selection?.identifier ?? "")
//            entries.append(entry)
//        }
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
        var contents: [SuperSingleViewModel] = []
        if let displayString = configuration.widget?.displayString,
           let dbModel = WidgetDataManager.shared.getUserSelectLargeWidget(subTagID: displayString) {
            // 第一步保存当前subTagID
            UserDefaults(suiteName: AppGroup.defaultGroup.rawValue)?.set(displayString, forKey: AppGroupConst.currentLargeSubTag)
            // 第二步将contents数据给数据模型
            let m = WidgetModel.parseJSON(str: dbModel.contents ?? "")
            if let localContents = m.contents {
                contents = localContents
            }
        }
        let entry = LargeWidgetEntry(date: Date(), identifier: configuration.selection?.identifier ?? "", contents: contents)
        let nextUpdate = Calendar.current.date(byAdding: DateComponents(second: 5), to: Date())!
        let timeLine = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeLine)
    }
}

struct LargeWidgetEntry: TimelineEntry {
    var date: Date
    var identifier: String
    var contents: [SuperSingleViewModel]
}

struct LargeWidgetEntryView : View {
    var entry: LargeWidgetProvider.Entry
    private let isDark = UserDefaults(suiteName: AppGroup.defaultGroup.rawValue)?.bool(forKey: AppGroupConst.darkMode) ?? false
    private let currentLargeSubTag = UserDefaults(suiteName: AppGroup.defaultGroup.rawValue)?.string(forKey: AppGroupConst.currentLargeSubTag) ?? ""

    var body: some View {
        if let dbModel = WidgetDataManager.shared.getUserSelectLargeWidget(subTagID: currentLargeSubTag) {
            let m = WidgetModel.parseJSON(str: dbModel.contents ?? "")
            if let contents = m.contents {
                DynamicWidgetView(widgetEnvironment: .Widget, contents: contents, entry: entry)
            } else {
                Text("数据库没有获取到数据")
            }
        }
    }
}

//struct LargeWidgetEntryView : View {
//    var entry: LargeWidgetProvider.Entry
//    private let isDark = UserDefaults(suiteName: AppGroup.defaultGroup.rawValue)?.bool(forKey: AppGroupConst.darkMode) ?? false
//
//    let wmodel = WidgetModel.parseJSON(str: ViewController().testGetWidgetViewJson())
//    var body: some View {
//        GeometryReader { geo in
//            DynamicWidgetView(widgetEnvironment: .Widget, contents: (wmodel.contents!), entry: entry)
//        }
//    }
//}

struct LargeWidget: Widget {
    let kind: String = "LargeWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: LargeConfigurationIntent.self, provider: LargeWidgetProvider()) { entry in
            LargeWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemLarge])
        .configurationDisplayName("大号")
        .description("选择你想要的组件尺寸添加到桌面")
    }
}
