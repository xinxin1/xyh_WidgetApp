//
//  MoreModifyUserInfoViewController.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/8.
//

import UIKit
import RxCocoa
import RxSwift
import YYKit

class MoreModifyUserInfoViewController: BaseViewController {

    @IBOutlet weak var alertContentView: UIView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var submitButtom: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    override func setupView() {
        
        self.alertContentView.layer.cornerRadius = 12
        self.alertContentView.layer.masksToBounds = true
        
        self.submitButtom.layer.cornerRadius = 12
        self.submitButtom.layer.masksToBounds = true
        self.submitButtom.setBackgroundColor(UIColor(hexString: "#644BFF66")!, forState: .disabled)
        self.submitButtom.setBackgroundColor(UIColor(hexString: "#644BFF")!, forState: .normal)
        self.submitButtom.isEnabled = false

        self.textField.delegate = self
        self.textField.rx.text.subscribe { res in
            
            let text = res.event.element!!
            
            self.submitButtom.isEnabled = text.count > 0
            
            self.countLabel.text = "\(text.count)/10"
            
        }.disposed(by: disBag)

    }
    
// MARK: - Action
    @IBAction func avatarModifyAction(_ sender: UIButton) {
        
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func sureAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}

extension MoreModifyUserInfoViewController: UITextFieldDelegate {
    
}

extension UIViewController {
    
    func showUserInfoModifier() {
        
        let modifyVC = MoreModifyUserInfoViewController()
        modifyVC.modalPresentationStyle = .overCurrentContext
        modifyVC.modalTransitionStyle = .crossDissolve
        
        self.tabBarController!.present(modifyVC, animated: true)
    }
}
