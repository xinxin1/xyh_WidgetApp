//
//  ExploreTutorialViewController.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/18.
//

import UIKit
import IBAnimatable

class ExploreTutorialViewController: BaseViewController {
    
    @IBOutlet weak var lightBgButton: UIButton!
    
    @IBOutlet weak var darkBgButton: UIButton!
        
    @IBOutlet weak var adContentView: AnimatableView!
    
    @IBOutlet weak var appearenceSwitch: UISwitch!
    
    fileprivate var showDark: Bool = false
    
    fileprivate var lightScreenCaptureImage: UIImage? {
        didSet {
            self.lightBgButton.setBackgroundImage(lightScreenCaptureImage, for: .normal)
            self.lightBgButton.setBackgroundImage(lightScreenCaptureImage, for: .highlighted)
        }
    }
    
    fileprivate var darkScreenCaptureImage: UIImage? {
        didSet {
            self.darkBgButton.setBackgroundImage(darkScreenCaptureImage, for: .normal)
            self.darkBgButton.setBackgroundImage(darkScreenCaptureImage, for: .highlighted)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        
    }

    // 取出沙盒里的桌面截图（亮/暗）
    func setupData() {
        
    }
    
    override func setupView() {
        self.title = NSLocalizedString("透明组件", comment: "")
        addBackButton()

        self.showDark = UserDefaults.standard.bool(forKey: kTransparentWidgetAppearance)
        self.appearenceSwitch.isOn = showDark
        
        layerAppearance(for: lightBgButton)
        layerAppearance(for: darkBgButton)
        configButtonLayout()
    }
    
    func layerAppearance(for view: UIView) {
        view.layer.cornerRadius = 12
        
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 5
        
        view.layer.shadowColor = UIColor(hexString: "#B7BFCD")!.cgColor
        view.layer.shadowRadius = 12
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowOpacity = 0.2
    }
    
    func configButtonLayout() {
        
        let width = CGFloat((ScreenWidth - 60) / 2)
        let height = width * (339/157)
        
        if showDark {
            
            lightBgButton.snp.remakeConstraints { make in
                make.width.equalTo(width)
                make.height.equalTo(height)
                make.leading.equalTo(20)
            }
            
            darkBgButton.snp.remakeConstraints { make in
                make.width.equalTo(width)
                make.height.equalTo(height)
                make.trailing.equalTo(-20)
            }
            
        } else {
            
            lightBgButton.snp.remakeConstraints { make in
                make.width.equalTo(width)
                make.height.equalTo(height)
                make.centerX.equalTo(view)
            }
            
            darkBgButton.snp.remakeConstraints { make in
                make.width.equalTo(width)
                make.height.equalTo(height)
                make.centerX.equalTo(view)
            }
        }
    }
    
    @IBAction func selectedScreenCaptureAction(_ sender: UIButton) {
        
    }
    
    @IBAction func appearanceAction(_ sender: UISwitch) {
        showDark = sender.isOn
        UserDefaults.standard.set(showDark, forKey: kTransparentWidgetAppearance)
        
        UIView.animate(withDuration: 0.4) {
            self.configButtonLayout()
        }
    }
}
