//
//  GeneralTabBarController.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/8.
//

import UIKit

class GeneralTabBarController: BaseTabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupChildVc()
        self.setupTabBar()
        self.delegate = self
    }

    func setupChildVc() {
        
        let exploreVC = ExploreViewController()
        let eNavi = BaseNavigationController(rootViewController: exploreVC)
        eNavi.tabBarItem = UITabBarItem(title: "探索", image: UIImage(named: "tabbar_explore_normal_icon"), selectedImage: UIImage(named: "tabbar_explore_selected_icon"))
        self.addChild(eNavi)

        let moreVC = MoreViewController()
        let mNavi = BaseNavigationController(rootViewController: moreVC)
        mNavi.tabBarItem = UITabBarItem(title: "更多", image: UIImage(named: "tabbar_more_normal_icon"), selectedImage: UIImage(named: "tabbar_more_selected_icon"))
        self.addChild(mNavi)
        
        self.selectedIndex = 0
    }
    
    func setupTabBar() {

        self.tabBar.unselectedItemTintColor = UIColor(hexString: "#A9ABB8")
        self.tabBar.tintColor = UIColor(hexString: "#644BFF")

        let appearance = UITabBarAppearance()
        appearance.backgroundImage = UIImage.init()
        appearance.backgroundColor = UIColor.white
        appearance.shadowColor = UIColor(hexString: "#E0E7F6")
        
        self.tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            self.tabBar.scrollEdgeAppearance = appearance
        } else {
            
        }
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if self.selectedViewController != viewController {
//            InterstitialAdManager.share().showInterstitialAd(vc: self) {}
        }
        return true
    }
}
