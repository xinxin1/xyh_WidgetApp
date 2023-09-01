//
//  GeneralPermissionAlertViewController.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/21.
//

import UIKit
import IBAnimatable

class GeneralPermissionAlertViewController: BaseViewController {
    
    @IBOutlet weak var alertContentView: AnimatableView!
    
    @IBOutlet weak var permissionImageView: UIImageView!
    
    @IBOutlet weak var permissionNameLabel: UILabel!
    
    @IBOutlet weak var permissionDescribeLabel: UILabel!
    
    var permissionItem:  PermissionItem?
    var openPermissionBlock: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func setupView() {
        self.permissionImageView.image = UIImage(named: permissionItem?.image ?? "")
        self.permissionNameLabel.text = permissionItem?.title
        self.permissionDescribeLabel.text = permissionItem?.content
    }

    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func bottomAction(_ sender: UIButton) {
        if sender.tag == 1 {
            openPermissionBlock?()
        }
        self.dismiss(animated: true)
    }
}


extension PermissionType {
    var settingUrl: String {
        switch self {
        case .location:
            return "App-prefs:root=LOCATION_SERVICES"
        case .camera:
            return "相机"
        case .album:
            return "相册"
        case .bluetooth:
            return "蓝牙"
        case .sportAndHealth:
            return "x-apple-health://app/"
        case .advertisment:
            return "个性化广告"
        }
    }
}
