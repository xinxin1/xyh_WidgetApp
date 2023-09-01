//
//  IntentHandler.swift
//  DynamicWidget
//
//  Created by 吴琼 on 2023/7/31.
//

import Intents

class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any {
        return self
    }
}
extension IntentHandler: SmallConfigurationIntentHandling {
    func provideWidgetOptionsCollection(for intent: SmallConfigurationIntent, searchTerm: String?, with completion: @escaping (INObjectCollection<WidgetType>?, Error?) -> Void) {
        var widgets: [WidgetType] = []
        let smallWidgets = WidgetDataManager.shared.getAllWidgets(widgetType: 3)
        smallWidgets.forEach { model in
            if let subTagID = model.subTagID {
                widgets.append(WidgetType(
//                    identifier: "\(String(describing: model.identifier))",
                    identifier: subTagID,
                    display: subTagID
                ))
            }
        }
        completion(INObjectCollection(items: widgets), nil)
    }
    func defaultWidget(for intent: SmallConfigurationIntent) -> WidgetType? {
        return WidgetType(identifier: "default", display: "选择")
    }
    func provideTransparentOptionsCollection(for intent: SmallConfigurationIntent, searchTerm: String?, with completion: @escaping (INObjectCollection<SelectionType>?, Error?) -> Void) {
        
        var items: [SelectionType] = []
        if let allSmalls = TransparentData.getAllSmallPlist() {
            allSmalls.forEach { item in
                items.append(SelectionType(identifier: item.key , display: item.name))
            }
            completion(INObjectCollection(items: items), nil)
        }
    }
    func defaultTransparent(for intent: SmallConfigurationIntent) -> SelectionType? {
        return SelectionType(identifier: "default", display: "选择")
    }
}

extension IntentHandler: MediumConfigurationIntentHandling {
    
    func provideWidgetOptionsCollection(for intent: MediumConfigurationIntent, searchTerm: String?, with completion: @escaping (INObjectCollection<WidgetType>?, Error?) -> Void) {
        var widgets: [WidgetType] = []
        let allMediumWidgets = WidgetDataManager.shared.getAllWidgets(widgetType: 2)
        allMediumWidgets.forEach { model in
            if let subTagID = model.subTagID {
                widgets.append(WidgetType(
//                    identifier: "\(String(describing: model.identifier))",
                    identifier: subTagID,
                    display: subTagID
                ))
            }
        }
        completion(INObjectCollection(items: widgets), nil)
    }
    func defaultWidget(for intent: MediumConfigurationIntent) -> WidgetType? {
        return WidgetType(identifier: "default", display: "选择")
    }
    
    
    func provideSelectionOptionsCollection(for intent: MediumConfigurationIntent, searchTerm: String?, with completion: @escaping (INObjectCollection<SelectionType>?, Error?) -> Void) {
        
        var items: [SelectionType] = []
        if let allSmalls = TransparentData.getAllMediumPlist() {
            allSmalls.forEach { item in
                items.append(SelectionType(identifier: item.key , display: item.name))
            }
            completion(INObjectCollection(items: items), nil)
        }
    }
    func defaultSelection(for intent: MediumConfigurationIntent) -> SelectionType? {
        return SelectionType(identifier: "default", display: "选择")
    }
}
extension IntentHandler: LargeConfigurationIntentHandling {
    func provideWidgetOptionsCollection(for intent: LargeConfigurationIntent, searchTerm: String?, with completion: @escaping (INObjectCollection<WidgetType>?, Error?) -> Void) {
        var widgets: [WidgetType] = []
        let allLargeWidgets = WidgetDataManager.shared.getAllWidgets(widgetType: 1)
        allLargeWidgets.forEach { model in
            if let subTagID = model.subTagID {
                widgets.append(WidgetType(
                    identifier: subTagID,
                    display: subTagID
                ))
            }
        }
        completion(INObjectCollection(items: widgets), nil)
    }
    func defaultWidget(for intent: LargeConfigurationIntent) -> WidgetType? {
        return WidgetType(identifier: "default", display: "选择")
    }
    
    func provideSelectionOptionsCollection(for intent: LargeConfigurationIntent, searchTerm: String?, with completion: @escaping (INObjectCollection<SelectionType>?, Error?) -> Void) {
        
        var items: [SelectionType] = []
        if let allSmalls = TransparentData.getAllLargePlist() {
            allSmalls.forEach { item in
                items.append(SelectionType(identifier: item.key , display: item.name))
            }
            completion(INObjectCollection(items: items), nil)
        }
    }
    func defaultSelection(for intent: LargeConfigurationIntent) -> SelectionType? {
        return SelectionType(identifier: "default", display: "选择")
    }
}

