//
//  MoyaPlugin.swift
//  ChatAIAPP
//
//  Created by 吴琼 on 2023/5/11.
//

import Foundation
import Moya


public final class MoyaPlugin : PluginType {
    
    public func willSend(_ request: RequestType, target: TargetType) {

        
    }
    
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
//        print("请求结果 === \(result)")
//        let re = try? result.get()
//        print("请求结果 === \(re?.statusCode)")
//        if re?.statusCode == 401 || K_access_token == "" || re == nil {
//            print("TOKEN 失效,需要重新获取Token")
//            AuthHelper.getNewToken(cmp: {
//
//            })
//        }
        
    }
    
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var mRequest = request
        mRequest.timeoutInterval = 60
        return mRequest
    }
    

}
