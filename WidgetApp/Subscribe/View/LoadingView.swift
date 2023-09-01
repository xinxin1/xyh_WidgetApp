//
//  LoadingView.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/23.
//

import UIKit
import YYKit

class LoadingView: UIView {
    
    @IBOutlet weak var animateView: YYAnimatedImageView!
    
    override  func awakeFromNib() {
        animateView.layer.masksToBounds = true
        animateView.layer.cornerRadius = 25
        let loadPath = Bundle.main.url(forResource: "loading", withExtension: "gif")
        animateView.setImageWith(loadPath, options: YYWebImageOptions .ignoreDiskCache)
    }
}
