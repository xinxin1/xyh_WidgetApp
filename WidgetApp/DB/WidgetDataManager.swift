//
//  WidgetDataManager.swift
//  WidgetApp
//
//  Created by 李昆明 on 2023/8/18.
//

import Foundation
import WCDBSwift

final class WidgetDBModel: TableCodable {
    var identifier: Int? // 主键
    var show_in_app: Bool? // 是否在App内展示
    var isCurrent: Bool? // 当前是否展示中
    var isCurrentShow: String?
    var topTagId: Int? //  标签ID - 大类别
    var subTagID: String? // 系统标签下的子标签ID 唯一不可重复
    var categoryId: Int? // 分类
    var widgetId: Int? // 组件ID
    var widgetType: Int?  // 组件类型 大中小
    var widgetName: String? // 组件名称
    var widgetImage: Data? // 桌面组件图片名称
    var contents: String? // 本地JOSN配置文件
    var transparentKey: String? // 透明组件的标识
    var lightImageName: String? // 透明组件图片-Light模式
    var darkImageName: String? // 透明组件图片-Dark模式
    var navigationURL: String? // 整个Widget跳转的URL
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = WidgetDBModel
        case identifier = "id"
        case show_in_app
        case isCurrent = "is_current"
        case isCurrentShow = "is_current_show"
        case topTagId = "top_tag_id"
        case subTagID = "sub_tag_id"
        case categoryId = "category_id"
        case widgetId = "widget_id"
        case widgetType = "widget_type"
        case widgetName = "widget_name"
        case widgetImage = "widget_image"
        case contents
        case transparentKey = "trans_key"
        case lightImageName = "light_image"
        case darkImageName = "dark_image"
        case navigationURL = "navigation_url"
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(identifier, isPrimary: true)
        }
    }
    
    var isAutoIncrement: Bool = true // 用于定义是否使用自增的方式插入
    var lastInsertedRowID: Int64 = 0 // 用于获取自增插入后的主键值
}


let WidgetTable = "WidgetTable"

class WidgetDataManager: NSObject {
    public static let shared = WidgetDataManager()
    override init() {}
    public func mainDBFile() -> String {
        let path = WidgetFilePath.mainDBFile()
        print(path)
        return path
    }
    public func deleteTable() {
        let db = Database(at: mainDBFile())
        do {
            guard try db.isTableExists(WidgetTable) else { return }
            try db.delete(fromTable: WidgetTable)
            
        } catch  {
            print("delete failed: \(error)")
        }
    }
   
    public func createTable() {
        let db = Database(at: mainDBFile())
        print("db.paths: \(db.path)")
        do {
            try db.create(table: WidgetTable, of: WidgetDBModel.self)
        } catch  {
            print("create table failed:\(error)")
        }
    }
    /// 插入一条数据
    public func insertWidgetModel(model: WidgetDBModel) {
        let dataBase = Database(at: mainDBFile())
        do {
            try dataBase.insert(model, intoTable: WidgetTable)
        } catch  {
            print("inset one model failed: \(error)")
        }
    }
    /// 同时插入大量数据
    public func insertWidgetModesl(models: [WidgetDBModel]) {
        let dataBase = Database(at: mainDBFile())
        do {
            try dataBase.run(transaction: {_ in
                for model in models {
                    try dataBase.insert(model, intoTable: WidgetTable)
                }
            })
        } catch  {
            print("insert models failed: \(error)")
        }
    }
    /// App内全部需要展示的Widget
    public func getAllWidgets(widgetType: Int) -> [WidgetDBModel] {
        let dataBase = Database(at: mainDBFile())
        do {
            let allObjects: [WidgetDBModel] = try dataBase.getObjects(
                fromTable: WidgetTable,
//                on: [WidgetDBModel.Properties.widgetType], fromTable: WidgetTable,
                orderBy: [WidgetDBModel.Properties.identifier]
            ).filter({ $0.widgetType == widgetType })
            return allObjects.filter({ $0.show_in_app ?? true })
        } catch  {
            print("get failed: \(error)")
        }
        return []
    }
    /// 全部相同的WidgetID- 包含不可展示的
    public func getSameWidgets(with widetID: Int) -> Int {
        let dataBase = Database(at: mainDBFile())
        do {
            let allObjects: [WidgetDBModel] = try dataBase.getObjects(
                fromTable: WidgetTable,
                where: WidgetDBModel.Properties.widgetId == widetID
            )
            return allObjects.count
        } catch  {
            print("get failed: \(error)")
        }
        return 0
    }
    /// 当前展示的Small类型组件
    public func getCurrentSmallWidget() -> WidgetDBModel? {
        let dataBase = Database(at: mainDBFile())
        do {
            let cur: WidgetDBModel? = try dataBase.getObject(
                fromTable: WidgetTable,
                where: WidgetDBModel.Properties.isCurrent == true
                && WidgetDBModel.Properties.widgetType == 3
            )
            return cur
        } catch  {
            print("get failed: \(error)")
        }
        return nil
    }
    /// 通过subTagID确定 当前展示的SmallWidget
    public func getUserSelectSmallWidget(subTagID: String) -> WidgetDBModel? {
        let dataBase = Database(at: mainDBFile())
        do {
            let cur: WidgetDBModel? = try dataBase.getObject(
                fromTable: WidgetTable,
                where: WidgetDBModel.Properties.subTagID == subTagID && WidgetDBModel.Properties.widgetType == 3,
                orderBy: [WidgetDBModel.Properties.identifier.order(.descending)]
                
            )
            return cur
        } catch  {
            print("get failed: \(error)")
        }
        return nil
    }
    public func updateSmallWidget(model: WidgetDBModel) {
        let db = Database(at: mainDBFile())
        do {
            try db.update(table: WidgetTable,
                          on: [WidgetDBModel.Properties.isCurrent, WidgetDBModel.Properties.isCurrentShow],
                          with: model,
                          where: WidgetDBModel.Properties.widgetType == 3
            )
        } catch {
            print("update failed:\(error.localizedDescription)")
        }
    }
    //MARK: Medium类型组件
    public func getCurrentMediumWidget() -> WidgetDBModel? {
        let dataBase = Database(at: mainDBFile())
        do {
            let cur: WidgetDBModel? = try dataBase.getObject(
                fromTable: WidgetTable,
                where: WidgetDBModel.Properties.isCurrent == true
                && WidgetDBModel.Properties.widgetType == 2
            )
            return cur
        } catch  {
            print("get failed: \(error)")
        }
        return nil
    }
    
    /// 通过subTagID确定 当前展示的MediumWidget
    public func getUserSelectMediumWidget(subTagID: String) -> WidgetDBModel? {
        let dataBase = Database(at: mainDBFile())
        do {
            let cur: WidgetDBModel? = try dataBase.getObject(
                fromTable: WidgetTable,
                where: WidgetDBModel.Properties.subTagID == subTagID && WidgetDBModel.Properties.widgetType == 2,
                orderBy: [WidgetDBModel.Properties.identifier.order(.descending)]
            )
            return cur
        } catch  {
            print("get failed: \(error)")
        }
        return nil
    }
    
    public func updateMediumWidget(model: WidgetDBModel) {
        let db = Database(at: mainDBFile())
        do {
            try db.update(table: WidgetTable,
                          on: [WidgetDBModel.Properties.isCurrent, WidgetDBModel.Properties.isCurrentShow],
                          with: model,
                          where: WidgetDBModel.Properties.widgetType == 2
            )
        } catch {
            print("update failed:\(error.localizedDescription)")
        }
    }
    
    // MARK: Large类型组件
    public func getCurrentLargeWidget() -> WidgetDBModel? {
        let dataBase = Database(at: mainDBFile())
        do {
            let cur: WidgetDBModel? = try dataBase.getObject(
                fromTable: WidgetTable,
                where: WidgetDBModel.Properties.isCurrent == true
                && WidgetDBModel.Properties.widgetType == 1
            )
            return cur
        } catch  {
            print("get failed: \(error)")
        }
        return nil
    }
    
    /// 通过subTagID确定 当前展示的MediumWidget
    public func getUserSelectLargeWidget(subTagID: String) -> WidgetDBModel? {
        let dataBase = Database(at: mainDBFile())
        do {
            let cur: WidgetDBModel? = try dataBase.getObject(
                fromTable: WidgetTable,
                where: WidgetDBModel.Properties.subTagID == subTagID && WidgetDBModel.Properties.widgetType == 1,
                orderBy: [WidgetDBModel.Properties.identifier.order(.descending)]
            )
            return cur
        } catch  {
            print("get failed: \(error)")
        }
        return nil
    }
    
    public func updateLargeWidget(model: WidgetDBModel) {
        let db = Database(at: mainDBFile())
        do {
            try db.update(table: WidgetTable,
                          on: [WidgetDBModel.Properties.isCurrent, WidgetDBModel.Properties.isCurrentShow],
                          with: model,
                          where: WidgetDBModel.Properties.widgetType == 1
            )
        } catch {
            print("update failed:\(error.localizedDescription)")
        }
    }
    
}
