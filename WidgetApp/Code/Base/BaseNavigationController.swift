//
//  BaseNavigationController.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/7/31.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configAppearance()
    }
    
    func configAppearance() {
        
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = UIColor(named: "#F5F5F5")
        
        self.interactivePopGestureRecognizer?.isEnabled = false

        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont.init(name: "PingFangSC-Semibold", size: 18) ?? UIFont.systemFont(ofSize: 18,weight: .semibold), NSAttributedString.Key.foregroundColor : UIColor(named: "#333333")!]
        self.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor : UIColor(named: "#333333")!]
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [NSAttributedString.Key.font : UIFont.init(name: "PingFangSC-Semibold", size: 18)!, NSAttributedString.Key.foregroundColor : UIColor(named: "#333333")!]
        appearance.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor : UIColor(named: "#333333")!]
        appearance.backgroundColor = UIColor(hexString: "#F5F5F5")
        appearance.shadowColor = UIColor(hexString: "#F5F5F5")
        
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
    }

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    override func pushViewController(_ viewController: UIViewController, animated: Bool){
        if self.children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}
