//
//  MediumWidget.swift
//  WidgetExtensionExtension
//
//  Created by 李昆明 on 2023/8/9.
//

import WidgetKit
import SwiftUI
import Intents
import HandyJSON

struct MediumWidgetProvider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> MediumWidgetEntry {
        var contents: [SuperSingleViewModel] = []
        if let currentMediumSubTag = UserDefaults(suiteName: AppGroup.defaultGroup.rawValue)?.string(forKey: AppGroupConst.currentMediumSubTag),
           let dbModel = WidgetDataManager.shared.getUserSelectMediumWidget(subTagID: currentMediumSubTag) {
            let m = WidgetModel.parseJSON(str: dbModel.contents ?? "")
            if let localContents = m.contents {
                contents = localContents
            }
        }
        return MediumWidgetEntry(date: Date(), identifier: "", contents: contents)
    }

    func getSnapshot(for configuration: MediumConfigurationIntent, in context: Context, completion: @escaping (MediumWidgetEntry) -> ()) {
        var contents: [SuperSingleViewModel] = []
        if let displayString = configuration.widget?.displayString,
           let dbModel = WidgetDataManager.shared.getUserSelectMediumWidget(subTagID: displayString) {
            UserDefaults(suiteName: AppGroup.defaultGroup.rawValue)?.set(displayString, forKey: AppGroupConst.currentMediumSubTag)
            let m = WidgetModel.parseJSON(str: dbModel.contents ?? "")
            if let localContents = m.contents {
                contents = localContents
            }
        }
        let entry = MediumWidgetEntry(date: Date(), identifier: configuration.selection?.identifier ?? "", contents: contents)
        completion(entry)
    }

    func getTimeline(for configuration: MediumConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var contents: [SuperSingleViewModel] = []
        if let displayString = configuration.widget?.displayString,
           let dbModel = WidgetDataManager.shared.getUserSelectMediumWidget(subTagID: displayString) {
            // 第一步保存当前subTagID
            UserDefaults(suiteName: AppGroup.defaultGroup.rawValue)?.set(displayString, forKey: AppGroupConst.currentMediumSubTag)
            // 第二步将contents数据给数据模型MediumWidgetEntry
            let m = WidgetModel.parseJSON(str: dbModel.contents ?? "")
            if let localContents = m.contents {
                contents = localContents
            }
        }
//        let entry = MediumWidgetEntry(date: Date(), identifier: configuration.selection?.identifier ?? "", contents: contents)
//        let nextUpdate = Calendar.current.date(byAdding: DateComponents(second: 5), to: Date())!
//        let timeLine = Timeline(entries: [entry], policy: .after(nextUpdate))
//        completion(timeLine)
        
        var entries: [MediumWidgetEntry] = []
        let currentDate = Date()
        for secondOffset in 0 ..< 60 {
            let entryDate = Calendar.current.date(byAdding: .second, value: secondOffset, to: currentDate)!
            let entry = MediumWidgetEntry(date: entryDate, identifier: configuration.selection?.identifier ?? "", contents: contents)
            entries.append(entry)
        }
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct MediumWidgetEntry: TimelineEntry {
    var date: Date
    var identifier: String
    var contents: [SuperSingleViewModel]
}

struct MediumWidgetEntryView : View {
    var entry: MediumWidgetProvider.Entry
    private let isDark = UserDefaults(suiteName: AppGroup.defaultGroup.rawValue)?.bool(forKey: AppGroupConst.darkMode) ?? false
    private let currentMediumSubTag = UserDefaults(suiteName: AppGroup.defaultGroup.rawValue)?.string(forKey: AppGroupConst.currentMediumSubTag) ?? ""
    private let updateHomeWidget = UserDefaults(suiteName: AppGroup.defaultGroup.rawValue)?.bool(forKey: AppGroupConst.updateHomeWidget) ?? false
    let wmodel = WidgetModel.parseJSON(str: ViewController().testGetWidgetViewJson())
    var body: some View {
//        if updateHomeWidget {
//            if let dbModel = WidgetDataManager.shared.getCurrentMediumWidget() {
//                let m = WidgetModel.parseJSON(str: dbModel.contents ?? "")
//                if let contents = m.contents {
//                  DynamicWidgetView(widgetEnvironment: .Widget, contents: contents)
//                } else {
//                    Text("数据库没有获取到数据\n getCurrentMediumWidget")
//                }
//            }
//        } else {
            if let dbModel = WidgetDataManager.shared.getUserSelectMediumWidget(subTagID: currentMediumSubTag) {
                let m = WidgetModel.parseJSON(str: dbModel.contents ?? "")
                if let contents = m.contents {
                    DynamicWidgetView(widgetEnvironment: .Widget, contents: contents, entry: entry)
                } else {
                    Text("数据库没有获取到数据\n getUserSelectMediumWidget")
                }
            }
//        }
    }
}

//MARK:  测试
//struct MediumWidgetEntryView : View {
//    var entry: MediumWidgetProvider.Entry
//    private let isDark = UserDefaults(suiteName: AppGroup.defaultGroup.rawValue)?.bool(forKey: AppGroupConst.darkMode) ?? false
//    private let currentMediumSubTag = UserDefaults(suiteName: AppGroup.defaultGroup.rawValue)?.string(forKey: AppGroupConst.currentMediumSubTag) ?? ""
//    private let updateHomeWidget = UserDefaults(suiteName: AppGroup.defaultGroup.rawValue)?.bool(forKey: AppGroupConst.updateHomeWidget) ?? false
//    let wmodel = WidgetModel.parseJSON(str: ViewController().testGetWidgetViewJson())
//    var body: some View {
//        GeometryReader { geo in
//            DynamicWidgetView(widgetEnvironment: .Widget, contents: (wmodel.contents!), entry: entry)
//        }
//    }
//}




struct MediumWidget: Widget {
    let kind: String = "MediumWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: MediumConfigurationIntent.self, provider: MediumWidgetProvider()) { entry in
            MediumWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemMedium])
        .configurationDisplayName("中号")
        .description("选择你想要的组件尺寸添加到桌面")
    }
}
