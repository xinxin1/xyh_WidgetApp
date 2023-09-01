//
//  MoreMessageViewController.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/18.
//

import UIKit

class MoreMessageViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("消息", comment: "")
    }

    override func setupView() {
        self.addBackButton()
    }
}
