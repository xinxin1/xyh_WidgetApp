//
//  UIWindowExtensions.swift
//  EZSwiftExtensions
//
//  Created by Goktug Yilmaz on 3/1/16.
//  Copyright © 2016 Goktug Yilmaz. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit

extension UIWindow {
    /// EZSE: Creates and shows UIWindow. The size will show iPhone4 size until you add launch images with proper sizes. TODO: Add to readme
    public convenience init(viewController: UIViewController, backgroundColor: UIColor) {
        self.init(frame: UIScreen.main.bounds)
        self.rootViewController = viewController
        self.backgroundColor = backgroundColor
        self.makeKeyAndVisible()
    }
    
    
    public class func getWindow() -> UIWindow{
        
        var currentWindow = UIWindow()
        let windowArr = UIApplication.shared.windows
        for window in windowArr{
            if window.windowLevel == UIWindow.Level.normal{
                currentWindow = window
                break
            }
        }
        return currentWindow
    }
}

#endif
