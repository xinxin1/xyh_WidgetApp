//
//  LoginViewController.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/9.
//

import UIKit

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var touchImageView: UIImageView!
    
    @IBOutlet weak var defaultLoginButton: UIButton!
    
    @IBOutlet weak var agreementLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupView() {
        touchImageView.addTapGesture { tap in
            self.dismiss(animated: true)
        }
    }
    
// MARK: - Action
    @IBAction func loginAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

extension UIViewController {
    func toLogin() {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .overCurrentContext
        loginVC.modalTransitionStyle = .crossDissolve
        
        self.tabBarController!.present(loginVC, animated: true)
    }
}
