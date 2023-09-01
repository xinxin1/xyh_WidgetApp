//
//  MoreMyFriendsDeleteViewController.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/11.
//

import UIKit

class MoreMyFriendsDeleteViewController: BaseViewController {
    var deleteBlock: (()->())?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func setupView() {

    }

    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func bottomAction(_ sender: Any) {
        let tag = (sender as! UIButton).tag
        if tag == 1 {
            self.dismiss(animated: true)
        } else {
            deleteBlock?()
        }
    }
}


extension MoreMyFriendsDeleteViewController {
    class func showDeleteAlert(deleteHandler: (()->())?) {
        

    }
}

extension UIViewController {
    
    func showDeleteAlert(deleteHandler: (()->())?) {
        
        let deleteVC = MoreMyFriendsDeleteViewController()
        deleteVC.modalPresentationStyle = .overCurrentContext
        deleteVC.modalTransitionStyle = .crossDissolve
        deleteVC.deleteBlock = deleteHandler
        
        self.tabBarController?.present(deleteVC, animated: true)
    }
}
