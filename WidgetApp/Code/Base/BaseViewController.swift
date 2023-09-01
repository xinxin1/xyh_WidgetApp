//
//  BaseViewController.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/7/31.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    func setupView() {
        self.view.backgroundColor = UIColor(hexString: "#F5F5F5")
    }
    
    func addBackgroundImage() {
        let bgImageView = UIImageView(image: UIImage(named: "general_app_background_img"))
        bgImageView.contentMode = .scaleAspectFill
        
        self.view.insertSubview(bgImageView, at: 0)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
    }
    
    func addBackButton() {
        let backItem = UIBarButtonItem(image: UIImage(named: "general_back_icon"), style: .plain, target: self, action: #selector(backAction))
        self.navigationItem.leftBarButtonItem = backItem
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
