//
//  SubscribeManager.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/7/31.
//

import UIKit
import SwiftyStoreKit

let ProductSecret = "462063cc24e847a1912398e4cabd0d23"
let quarterProductID = "chataiweek3"
let yearProductID = "chataiyear2"
let pamanentProductID = ""

var app_purchased = false {
    didSet {
        //每次改变的时候发送全局消息
        NotificationCenter.default.post(name: .init(.init("app_purchased_Change")), object: app_purchased, userInfo: nil)
    }
}


class SubscribeManager: NSObject {
    
    public static let appPurchasedNotification = Notification.Name(rawValue: "SubscribeSuccessfully")

    static let shared = SubscribeManager()
    
    //完成的回调
    @objc public var finished: (() -> ())?
    
    //拉取订阅价格时候的loading
    lazy var loadingView: LoadingView = {
        loadingView = (Bundle.main.loadNibNamed("LoadingView", owner: nil,options: nil)?[0] as? LoadingView)!
        return loadingView
    }()
    
    //MARK: - 购买
    @objc public func purchaseProduct(productId:String){
        
        SwiftyStoreKit.purchaseProduct(productId) { (result) in
            switch result {
                
                case .success(let purchase):

                // MARK: - 统计
                let timeInterval:TimeInterval = Date().timeIntervalSince1970
                let orderID = "\(productId)\(timeInterval)"
                let deviceUUID = UIDevice.current.identifierForVendor?.uuidString
                MobClick.event("__finish_payment", attributes: [
                    "userid": deviceUUID ?? 0,
                    "orderid": orderID,
                    "item": purchase.product.productIdentifier,
                    "amount": "1"
                ])
                
                //购买完成后 再验证一次确保结果
                self.verifyProductWithLoad(productIds: [productId],res: { (b, receipt) in
                    app_purchased = b
                    UserDefaults.standard.set(b, forKey: "isPurchased")
                    if b == true {
                        //  第三方统计请求

        
                    }
                })
                    
                case .error(let error):
                    var errInfoStr  = ""
                
                    switch error.code {
                        
                        case .unknown:
                        errInfoStr = "Unknown error. Please contact support"
                        self.verifyProductWithLoad(productIds: [productId]) { b, item in
                            if b == true {
                               UserDefaults.standard.set(b, forKey: "isPurchased")
                               app_purchased = b;
                           } else {
                               UserDefaults.standard.set(b, forKey: "isPurchased")
                               app_purchased = b;
                           }
                        }
                        return
                        
                        case .clientInvalid: errInfoStr = "Not allowed to make the payment"
                        case .paymentCancelled:
                            errInfoStr = "User Cancelled"
                            self.verifyProductWithLoad(productIds: [productId]) { (b, v) in
                                if b == true {
                                    print("Restore Success: (results.restoredPurchases")
                                    UserDefaults.standard.set(b, forKey: "isPurchased")
                                    app_purchased = b;
                                } else {
                                    UserDefaults.standard.set(b, forKey: "isPurchased")
                                    app_purchased = b;
                                }
                            }
                        case .paymentInvalid: errInfoStr = "The purchase identifier was invalid"
                        case .paymentNotAllowed: errInfoStr = "The device is not allowed to make the payment"
                        case .storeProductNotAvailable: errInfoStr = "The product is not available in the current storefront"
                        case .cloudServicePermissionDenied: errInfoStr = "Access to cloud service information is not allowed"
                        case .cloudServiceNetworkConnectionFailed: errInfoStr = "Could not connect to the network"
                        case .cloudServiceRevoked: errInfoStr = "User has revoked permission to use this cloud service"
                        case .privacyAcknowledgementRequired:
                            errInfoStr = "privacy Acknowledgement Required"
                        case .unauthorizedRequestData:
                            errInfoStr = "unauthorized Request Data"
                        case .invalidOfferIdentifier:
                            errInfoStr = "invalid Offer Identifier"
                        case .invalidSignature:
                            errInfoStr = "invalid Signature"
                        case .missingOfferParams:
                            errInfoStr = "missing OfferParams"
                        case .invalidOfferPrice:
                            errInfoStr = "invalid Offer Price"
                        case .overlayCancelled:
                            errInfoStr = "overlay Cancelled"
                        case .overlayInvalidConfiguration:
                            errInfoStr = "overlay Invalid Configuration"
                        case .overlayTimeout:
                            errInfoStr = "overlay Timeout"
                        case .ineligibleForOffer:
                            errInfoStr = "ineligible ForOffer"
                        case .unsupportedPlatform:
                            errInfoStr = "unsupported Platform"
                        case .overlayPresentedInBackgroundScene:
                            errInfoStr = "overlay Presented In Background Scene"
                        
                    @unknown default:
                            errInfoStr = "error"
                    }
                    let message = errInfoStr
                
                //订阅错误提示
                self.subscribeCancel()
                UIWindow.getWindow().makeToast(message,position: .center)
            }
        }
    }
    
    //MARK: - Restore
    @objc func restoreProduct(weekProductId: String, yearProductId: String, res:@escaping (()->())) {
        
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                self.verifyProductWithLoad(productIds: [weekProductId,yearProductID]) { b, item in
                    if b == true {
                        print("Restore Success: (results.restoredPurchases")
                        UserDefaults.standard.set(true, forKey: "isPurchased")
                        app_purchased = true;
                        res()
                   } else {
                       UserDefaults.standard.set(false, forKey: "isPurchased");
                      app_purchased = false;
                      self.subscribeCancel()
                      UIWindow.getWindow().makeToast("Restore Failed",position: .center)
                   }
                }
            } else if results.restoredPurchases.count > 0 {
                // 验证一下确保结果正确
                self.verifyProductWithLoad(productIds:  [weekProductId,yearProductID]) { b, item in
                    if b == true {
                        print("Restore Success: (results.restoredPurchases")
                        UserDefaults.standard.set(true, forKey: "isPurchased")
                        app_purchased = true;
                        res()
                   } else {
                       UserDefaults.standard.set(false, forKey: "isPurchased");
                      app_purchased = false;
                      self.subscribeCancel()
                      UIWindow.getWindow().makeToast("Restore Failed",position: .center)
                   }
                }
            }
            else {
                print("Nothing to Restore")
                UserDefaults.standard.set(false, forKey: "isPurchased");
                app_purchased = false;
                self.subscribeCancel()
                UIWindow.getWindow().makeToast("Restore Failed",position: .center)
            }
        }
    }
    
    
    //MARK: - 产品验证
    func verifyProduct(res:@escaping ((_ b : Bool, _ item : ReceiptItem?)->())){
        
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: ProductSecret)
        
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(productIds: [yearProductID, quarterProductID, pamanentProductID], inReceipt: receipt)
                switch purchaseResult {
                case .purchased(_ , let receiptItem):
                    if self.finished != nil {
                        self.finished!()
                    }
                    UserDefaults.standard.set(true, forKey: "isPurchased");
                    res(true, receiptItem.first!)
                    app_purchased = true
                    
                case .notPurchased:
                    dPrint("The user has never purchased")
                        UserDefaults.standard.set(false, forKey: "isPurchased");
                        res(false,  ReceiptItem.init(receiptInfo: receipt))
                        app_purchased = false
                    
                case .expired(_,let items):
                    UserDefaults.standard.set(false, forKey: "isPurchased");
                    res(false, items.first)
                    app_purchased = false
                }
                
            case .error(let err):
                dPrint("Receipt verification failed: \(err)")
                UserDefaults.standard.set(false, forKey: "isPurchased");
                res(false, nil)
                app_purchased = false;
                self.subscribeCancel()
            }
        }
    }
    
    func verifyProductWithLoad(productIds: Set<String>,
                               res:@escaping ((_ b : Bool, _ item : ReceiptItem?)->())) {
        
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: ProductSecret)
        
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(productIds: productIds, inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(let expiryDate , let receiptItem):
                    if self.finished != nil {
                        self.finished!()
                    }
                    dPrint("subscriptionExpirationDate \(expiryDate)")
                    dPrint("Current \(Date())")
                    
                    UserDefaults.standard.set(true, forKey: "isPurchased");
                    res(true, receiptItem.first!)
                    app_purchased = true
                    
                case .notPurchased:
                    dPrint("The user has never purchased")
                    UserDefaults.standard.set(false, forKey: "isPurchased");
                    res(false,  ReceiptItem.init(receiptInfo: receipt))
                    app_purchased = false
                    
                case .expired(_,let items):
                    UserDefaults.standard.set(false, forKey: "isPurchased");
                    res(false, items.first)
                    app_purchased = false
                }
                
            case .error(let err):
                dPrint("Receipt verification failed: \(err)")
                UserDefaults.standard.set(false, forKey: "isPurchased");
                res(false, nil)
                app_purchased = false
                self.subscribeCancel()
                UIWindow.getWindow().makeToast("Verification Failed",position: .center)
            }
        }
    }
    
    // MARK: - ****需要在Appdelegates执行****
    @objc func  settingStoreKit() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                if purchase.transaction.transactionState == .purchased || purchase.transaction.transactionState == .restored {
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                }
            }
        }
    }
    
    //加载loading
    func subscribeLoading(){
        UIWindow.getWindow().addSubview(loadingView)
    }
    
    func subscribeCancel(){
        self.loadingView.removeFromSuperview()
    }
}

class SubscribeManagerEX: NSObject {
    
    typealias complate = () -> Void
    typealias cancel = () -> Void
    typealias getPayStatus = () -> Void
    
    class func decode(_ res: Any?) -> [AnyHashable : Any]? {
        if let aRes = res as? Data {
            return try! JSONSerialization.jsonObject(with: aRes, options: .allowFragments) as? [AnyHashable : Any]
        }
        return [:]
    }
    
    
    //检查产品是否订阅，未订阅则弹出订阅页面
    class func cheakProductPurchaseStatus(_ block: @escaping getPayStatus, currentVC currentVc: UIViewController?, cancel cancelblock: @escaping cancel) {
        
        if app_purchased == true {
            block()
            
        } else {
            
            let sVC = SubscribeViewController()
            sVC.modalPresentationStyle = .fullScreen
            sVC.subscribeFinish = {
                NotificationCenter.default.post(.init(name: SubscribeManager.appPurchasedNotification))
                block()
            }
            sVC.subscribeCancel = {
                cancelblock()
            }
            
            if (currentVc?.isKind(of: SubscribeViewController.self))! == false {
                currentVc?.present(sVC, animated: true) {}
            }
        }
    }
}
