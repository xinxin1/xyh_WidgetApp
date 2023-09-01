//
//  WidgetFilePath.swift
//  WidgetApp
//
//  Created by 李昆明 on 2023/8/18.
//

import Foundation

class FileSystem {
    static let documentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.endIndex - 1]
    }()
    
    static let cacheDirectory: URL = {
        let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return urls[urls.endIndex - 1]
    }()

    static let downloadDirectory: URL = {
        let directory: URL = FileSystem.documentsDirectory.appendingPathComponent("Download")
        return directory
    }()
    static let audioDirectory: URL = {
        let directory: URL = FileSystem.documentsDirectory.appendingPathComponent("audio")
        return directory
    }()
    
}
fileprivate let folderName = "WidgetApp"
class WidgetFilePath: NSObject {
    override init() {}
    
    class func mainDBFile() -> String {
        guard let dbFile = getWidgetFileURL()?.appendingPathComponent("WidgetDataBase.db") else { return ""}
        print(dbFile.path)
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: dbFile.path) {
            return dbFile.path
        } else {
            if fileManager.createFile(atPath: dbFile.path, contents: nil) {
                return dbFile.path
            }
        }
        return ""
    }
    private class func getWidgetFileURL() -> URL? {

      let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AppGroup.defaultGroup.rawValue)

        let folderURL: URL? = groupURL?.appendingPathComponent(folderName, conformingTo: .directory)

      if !FileManager.default.fileExists(atPath: folderURL?.path ?? "") {

        do {
          try FileManager.default.createDirectory(at: folderURL!, withIntermediateDirectories: true, attributes: nil)
          
        } catch {
          // handle error
            print(error.localizedDescription)
        }

      }

      return folderURL

    }
}
