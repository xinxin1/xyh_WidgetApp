//
//  MoreAboutViewController.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/9.
//

import UIKit

class MoreAboutViewController: BaseViewController {
    
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var privacyPolicyLabel: UILabel!
    
    @IBOutlet weak var userAgreementLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        self.sh_prefersNavigationBarHidden = true
        self.addBackgroundImage()
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
