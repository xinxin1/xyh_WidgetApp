//
//  MoreMyFriendsAddViewController.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/11.
//

import UIKit

class MoreMyFriendsAddViewController: BaseViewController {

    @IBOutlet weak var alertContentView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        
        self.alertContentView.layer.cornerRadius = 12
        self.alertContentView.layer.masksToBounds = true
        
        self.addButton.layer.cornerRadius = 12
        self.addButton.layer.masksToBounds = true
        self.addButton.setBackgroundColor(UIColor(hexString: "#644BFF66")!, forState: .disabled)
        self.addButton.setBackgroundColor(UIColor(hexString: "#644BFF")!, forState: .normal)
        self.addButton.isEnabled = false

        self.textField.delegate = self
        self.textField.rx.text.subscribe { res in
            
            let text = res.event.element!!
            
            self.addButton.isEnabled = text.count > 0
        }.disposed(by: disBag)
    }


    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func addAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}


extension MoreMyFriendsAddViewController: UITextFieldDelegate {
    
}

extension UIViewController {
    
    func showAddFriendAlert() {
        let addVC = MoreMyFriendsAddViewController()
        addVC.modalPresentationStyle = .overCurrentContext
        addVC.modalTransitionStyle = .crossDissolve
        
        self.tabBarController!.present(addVC, animated: true)
    }
}
