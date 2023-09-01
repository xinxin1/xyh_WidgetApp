//
//  WidgetTool.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/7/31.
//  工具

import Foundation
import Toast_Swift

class WidgetTool {
    // 系统分享
    public func share(item : Array<Any>, currentVc : UIViewController,complete:((Bool)->())?)  {
        let activityController = UIActivityViewController.init(activityItems: item, applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView  = currentVc.view;
        activityController.popoverPresentationController?.sourceRect = CGRect.init(x: UIScreen.main.bounds.width / 2.0, y: UIScreen.main.bounds.height, width: 1.0, height: 1.0)
        
        activityController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                complete?(false)
                return
            }
            complete?(true)
        }
        currentVc.present(activityController, animated: true, completion: nil);
    }

    // 系统复制
    public func copy(message: String) {

        UIPasteboard.general.string = message
        UIWindow.getWindow().makeToast("Copy Success",position: .center)
    }

}


//MARK: 文本类编辑
extension WidgetTool {
    
}
