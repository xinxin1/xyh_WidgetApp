//
//  ApiManager.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/7/31.
//

import UIKit
import Moya
import RxSwift
import HandyJSON
import CloudKit


let yunJiaSu = "https://cdn.wavetech.pro"

/// ApiManagerProvider endpointClosure 请求结束的回调 plugins 插件
let ApiManagerProvider = MoyaProvider<ApiManager>(endpointClosure : endpointClosure , plugins:[MoyaPlugin()])

/// dispose包
let disBag = DisposeBag()


/// URL端点映射
///
/// - Parameter target: 请求的TargetX
/// - Returns: Endpoint
private func endpointClosure<Target: TargetType>(target: Target) -> Endpoint {
    
    print("请求连接：\(target.baseURL)\(target.path) \n方法：\(target.method)\n参数：\(target.sampleData) ")
    
    return MoyaProvider.defaultEndpointMapping(for: target)
}

var K_access_token = "Bearer "
var k_sc824 = ""

public enum ApiManager {
    
    case getHomeBaseInfo

    // 获取组件列表
    case getWidgetsList(categoryId: String,
                        categoryName: String,
                        widgetName: String,
                        tags: String,
                        vip: String,
                        pageSize: String,
                        pageNum: String,
                        isAsc: String,
                        orderByColumn: String)
}


extension ApiManager: TargetType {
    
    //MARK: - BaseURL
    public var baseURL: URL {
        
        switch self {
    
        default:
            ServiceConfig.sharedInstance.netEnvironment = .Net_ENV_DEV;
        }
        return URL(string: ServiceConfig.sharedInstance.netEnvironment.rawValue)!
    }
    
    
    //MARK: - 请求路径
    public var path: String {
        
        switch self {
        default:
            return ""
        }
    }
        
    //MARK: - 请求方法
    public var method: Moya.Method {
        
        switch self {
        default:
            return .get
        }
    }
    
    //MARK: - 请求任务配置(添加参数，序列化)
    public var task: Moya.Task {
        
        switch self {
            
        default:
            return .requestParameters(parameters: parameters ?? [:], encoding: URLEncoding.default)
        }
    }
    
    //MARK: - 请求头
    public var headers: [String : String]? {
        
        switch self {


        default:
            return ["Content-Type" : "application/json"]
            
        }
    }
    
    
    //MARK: - 样本数据
    public var sampleData: Data {
        print("请求参数 \(String(describing: parameters))")
        return String(describing: parameters).data(using: String.Encoding.utf8)!
    }
    
    
    var parameters: [String: Any]? {
        switch self {
            
        case .getHomeBaseInfo:
            return nil
            
        case .getWidgetsList(categoryId: let categoryId, categoryName: let categoryName, widgetName: let widgetName, tags: let tags, vip: let vip, pageSize: let pageSize, pageNum: let pageNum, isAsc: let isAsc, orderByColumn: let orderByColumn):
            
            return ["categoryId": categoryId, "categoryName": categoryName, "tags": tags, "widgetName":widgetName , "vip": vip,"pageSize": pageSize,"pageNum": pageNum,"isAsc": isAsc,"orderByColumn": orderByColumn]
        }
    }
}


class AuthHelper {
    
    class func upDateToken(codeStr : String, cmp : @escaping (() -> ())) {
        if codeStr == "401" {
            AuthHelper.getNewToken {
                cmp()
            }
        }
    }

    class func getNewToken(cmp : @escaping (()-> ())) {

//        ApiManagerProvider.rx.request(.getToken(apiKey: kBundleId, secretKey: k_sc824, scope: "ios"),callbackQueue: .main)
//            .asObservable()
//            .mapWQDecodeModel(AuthModel.self)
//            .subscribe { res in
//                K_access_token = "Bearer \(res.data?.access_token ?? "")"
//                print(res)
//                cmp()
//            } onError: { Error in
//
//            } onCompleted: {
//
//            } onDisposed: {
//
//            }.disposed(by: disBag)
    }
}

struct AuthModel : HandyJSON {
    var msg : String?
    var code : String?
    var data : AuthDataModel?
}

struct AuthDataModel : HandyJSON {
    var token_type : String?
    var expires_in : String?
    var scope : String?
    var license : String?
    var access_token : String?
}

