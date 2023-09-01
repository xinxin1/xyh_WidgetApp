//
//  MoreBackgroundDecorationView.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/8.
//

import UIKit

class MoreBackgroundDecorationView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
}

extension MoreBackgroundDecorationView {
    func configure() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 12
    }
}
