////
////  WidgetDBManager.swift
////  WidgetApp
////
////  Created by 李昆明 on 2023/8/9.
////
//
//import Foundation
//import RealmSwift
//
//fileprivate let schemaVersion : UInt64 = 2
//fileprivate let folderName = "WidgetApp"
///// Private Method
//class WidgetDBManager: Object {
//    // MARK: - 数据库文件路径
//    private class func getDBPath() -> URL? {
//        guard let realmPath = getWidgetFileURL()?.appendingPathComponent("\(folderName).realm") else { return nil}
//        print(realmPath.path)
//        let fileManager = FileManager.default
//        if fileManager.fileExists(atPath: realmPath.path) {
//            return realmPath
//        } else {
//            if fileManager.createFile(atPath: realmPath.path, contents: nil) {
//                return realmPath
//            }
//        }
//        return nil
//    }
//    // MARK: - 获取数据库
//    private class func getRealmDB() -> Realm {
//        let realm = try! Realm.init(configuration: Realm.Configuration.init(fileURL: getDBPath(),
//                                                                            readOnly: false,
//                                                                            schemaVersion: schemaVersion,
//                                                                            deleteRealmIfMigrationNeeded: false,
//                                                                            objectTypes: [WidgetDBModel.self]))
//        return realm
//    }
//
//}
//
///// Public Method
//extension WidgetDBManager {
////    public class func getWidgetFileURL() -> URL? {
////        let groupFileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AppGroup.defaultGroup.rawValue)
////        let folderURL : URL? = groupFileURL?.appendingPathComponent(folderName, conformingTo: .directory)
////        try! FileManager.default.createDirectory(at: folderURL!,
////                                                 withIntermediateDirectories: true,
////                                                 attributes: nil)
////        return folderURL
////    }
//    public class func getWidgetFileURL() -> URL? {
//
//      let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AppGroup.defaultGroup.rawValue)
//
//        let folderURL: URL? = groupURL?.appendingPathComponent(folderName, conformingTo: .directory)
//
//      if !FileManager.default.fileExists(atPath: folderURL?.path ?? "") {
//
//        do {
//          try FileManager.default.createDirectory(at: folderURL!, withIntermediateDirectories: true, attributes: nil)
//
//        } catch {
//          // handle error
//            print(error.localizedDescription)
//        }
//
//      }
//
//      return folderURL
//
//    }
//
//    // MARK: - 数据库初始化
//    public class func creatDataBase() {
//        var config = Realm.Configuration()
//        config.fileURL = getDBPath()
//        config.readOnly = false
//        config.schemaVersion = schemaVersion
//        config.encryptionKey = nil
//        Realm.Configuration.defaultConfiguration = config
//    }
//    // MARK: 增
//    public class func insertOneModel(model: WidgetDBModel) {
//        let realm = self.getRealmDB()
//        let querys = self.queryOneModel(model.identifier)
//        if querys.isEmpty {
//            try! realm.write({
//                realm.add(model)
//            })
//        } else {
//           print("Current model is Exit")
//        }
//    }
//    public class func insertModels(models: [WidgetDBModel]) {
//        let realm = self.getRealmDB()
//        try! realm.write({
//            realm.add(models)
//        })
//    }
//    // MARK: 查
//    public class func queryOneModel(_ widgetID: String) -> Results<WidgetDBModel> {
//        let realm = self.getRealmDB()
//        let query = realm.objects(WidgetDBModel.self)
//            .where { model in
//                model.identifier == widgetID
//            }
//        return query
//    }
//    public class func queryTransparentModel(_ displayKey: String) -> Results<WidgetDBModel> {
//        let realm = self.getRealmDB()
//        let query = realm.objects(WidgetDBModel.self)
//            .where { model in
//                model.displayKey == displayKey
//            }
//        return query
//    }
//
//    // MARK: 查
//    public class func queryAllModel() -> Results<WidgetDBModel> {
//        let realm = self.getRealmDB()
//        let query = realm.objects(WidgetDBModel.self)
//        return query
//    }
//    // MARK: 更新-如果存在相同的displayKey就更新，不存在就插入这个model
//    public class func updateTransparentModel(with displayKey: String, model: WidgetDBModel, _ isDark: Bool = false) {
//        let realm = self.getRealmDB()
//        let query = realm.objects(WidgetDBModel.self)
//            .where { model in
//                model.displayKey == displayKey
//            }
//        if query.count > 0,
//           let current = query.first {
//            // Udpate
//            try! realm.write {
//                if isDark {
//                    current.darkImageName = model.darkImageName
//                } else {
//                    current.imageName = model.imageName
//                }
//            }
//        } else {
//            // Insert
//            try! realm.write {
//                realm.add(model)
//            }
//        }
//    }
//
//    // MARK: 删除
//    public class func deleteAllModel() {
//        let realm = self.getRealmDB()
//        try! realm.write({
//            let stored = realm.objects(WidgetDBModel.self)
//            realm.delete(stored)
//        })
//    }
//}
//// MARK: 字段修改后Version必须升级
//class WidgetDBModel : Object {
//    // 唯一主键
//    @Persisted var identifier = ""
//    // 标签ID - 大类别
//    @Persisted var topTagId: Int?
//    // 分类ID - 小类型如热门等
//    @Persisted var categoryId: Int?
//    // 子标签ID- 同一种类型下的ID 不可复用自动加一
//    @Persisted var subTagID: Int?
//    // 组件类型
//    @Persisted var widgetType: Int?
//    // 组件搜索时显示的组件名字
//    @Persisted var widgetName = ""
//    // 组件搜素的时候显示的图片
//    @Persisted var widgetImage = Data()
//    // 时间戳
//    @Persisted var createTime = Date()
//    // 组件的内容json
//    @Persisted var contents: String?
//    // 透明组件的标识
//    @Persisted var displayKey: String?
//    // 透明组件图片-Light
//    @Persisted var imageName: String?
//    // 透明组件图片-Dark
//    @Persisted var darkImageName: String?
//    // 跳转ULR
//    @Persisted var navigationURL: String?
//
//    override class func primaryKey() -> String? {
//        return "identifier"
//    }
//
//// 如果默认加密请打开下面，并配置128位秘钥：Realm.Configuration(encryptionKey: key)
////    // 唯一主键
////    @Persisted(primaryKey: true) var identifier: ObjectId
////
////    // 透明组件显示名称
////    @Persisted var displayName = ""
////
////    // 透明组件标识
////    @Persisted var displayKey = ""
////
////    // 时间戳
////    @Persisted var createTime = Date()
////
////    // 图片Data
////    @Persisted var imagePath: String
////
////    // widgetName
////    @Persisted var widgetName = ""
////
////    // widgetID
////    @Persisted var widgetID = ""
//
//}
//
//// MARK: 获取加密Key
////func generate64ByteKey() -> Data {
////    let keyCount = 64
////    var keyData = Data(count: keyCount)
////    _ = keyData.withUnsafeMutableBytes { keyBytes in
////        SecRandomCopyBytes(kSecRandomDefault, keyCount, keyBytes.baseAddress!)
////    }
////    let hexString = keyData.map { String(format: "%02hhx", $0) }.joined()
////    print("秘钥:\(hexString)")
////    return keyData
////}
