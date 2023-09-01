//
//  ServiceConfig.swift
//  ChatAIAPP
//
//  Created by 吴琼 on 2023/5/11.
//

import UIKit
import HandyJSON
import RxSwift
import Moya
import Kingfisher

/// 环境类型
///
/// - Net_ENV_DEV: 测试 主要是针对内部测试 baseUrl
/// - Net_ENV_DIS: 发布 正式环境 baseUrl
/// - Net_ENV_LOCAL: 本地服务器
/// - Net_ENV_CUSTOM: 自定义输入域名
public enum NetEnvironment : String {
    /** 测试服 */
    case Net_ENV_DEV = " "
    /** 正式服 */
    case Net_ENV_DIS = "正式环境地址"
    /** 本地服 */
    case Net_ENV_LOCAL = "本地环境地址"
    
    case Net_Wavetech = "Net_Wavetech"
    //appstore
    case Net_Appstore = "Net_Appstore"

}


class ServiceConfig: NSObject {
    
    var netEnvironment: NetEnvironment!
    
    static let sharedInstance = ServiceConfig()
    
    private override init() {
        
        
    }
}

// MARK: - 数据解析
extension ObservableType where Element == Response {
    
    public func mapModel<T: HandyJSON>(_ type: T.Type) -> Observable<T> {
        
        return flatMap { response -> Observable<T> in
            
            return Observable.just(response.mapModel(T.self))
            
        }
        
    }
    
    public func mapDecodeModel<T: HandyJSON>(_ type: T.Type) -> Observable<T> {
        
        return flatMap { response -> Observable<T> in
            
            return Observable.just(response.mapDecodeModel(T.self))
            
        }
    }
    
    public func mapWQDecodeModel<T: HandyJSON>(_ type: T.Type) -> Observable<T> {
        
        return flatMap { response -> Observable<T> in
            
            return Observable.just(response.mapWQDecodeModel(T.self))
            
        }
        
    }
    
    
}

extension Response {
    
    func mapModel<T: HandyJSON>(_ type: T.Type) -> T {
        
        let jsonString = String.init(data: data, encoding: .utf8)
        
        return JSONDeserializer<T>.deserializeFrom(json: jsonString) ?? T.init()
        
    }
    
    
    func mapDecodeModel<T: HandyJSON>(_ type: T.Type) -> T {
        
        let jsonString = String.init(data: data, encoding: .utf8)
        
        let dd = DES.init().decryptUse(jsonString)

        if dd == "" || dd == nil {
            return T.deserialize(from: ["faild" : "error"]) ?? T.init()
        }
        
        return JSONDeserializer<T>.deserializeFrom(json: dd ) ?? T.init()
    }
    
    func mapWQDecodeModel<T: HandyJSON>(_ type: T.Type) -> T {
        
        let decodeData = try! NSData.init(data: data).decrypto("DES", secretKey: k_sc824).toData()
        
        let jsonString = String.init(data: decodeData , encoding: .utf8)
        
        if jsonString == "" {
            return T.deserialize(from: ["faild" : "error"])!
        }
        
        return JSONDeserializer<T>.deserializeFrom(json: jsonString) ?? T.init()
        
    }
    
    
}
