//
//  SubscribeViewController.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/21.
//

import UIKit
import IBAnimatable

class SubscribeViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var videoContentView: UIView!
    
    @IBOutlet weak var yearProductButton: UIButton!
    @IBOutlet weak var yearDiscountPriceLabel: UILabel!
    @IBOutlet weak var yearOriginalPriceLabel: UILabel!
    @IBOutlet weak var yearAvargePriceLabel: UILabel!
    
    @IBOutlet weak var quarterProductButton: UIButton!
    @IBOutlet weak var quarterPriceLabel: UILabel!
    
    @IBOutlet weak var permanentProductButton: UIButton!
    @IBOutlet weak var permanentPriceLabel: UILabel!
    
    @IBOutlet weak var subscribeDescribeLabel: UILabel!
    @IBOutlet weak var subscribeButton: AnimatableButton!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    
    var currentProductButton: UIButton?
    
    var player: AVPlayer?

    //购买成功且完成
    var subscribeFinish: (() -> ())?
    
    //订阅关闭
    var subscribeCancel: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNotification()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeNotification()
    }

    override func setupView() {
        scrollView.contentInsetAdjustmentBehavior = .never
        setupProductButton()
        setupPriceLabel()
        setupPlayer()
    }
    
    func setupProductButton() {
        yearProductButton.layer.borderColor = UIColor(hexString: "#FCA23D")!.cgColor
        yearProductButton.layer.borderWidth = 2
        
        quarterProductButton.layer.borderColor = UIColor(hexString: "#F0E2D2")!.cgColor
        quarterProductButton.layer.borderWidth = 1.5
        
        permanentProductButton.layer.borderColor = UIColor(hexString: "#F0E2D2")!.cgColor
        permanentProductButton.layer.borderWidth = 1.5
        
        let layer = CAGradientLayer()
        layer.colors = [UIColor(hexString: "#FFDD3B")!.cgColor, UIColor(hexString: "#FF4B4B")!.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint =  CGPoint(x: 1, y: 0.5)
        layer.frame = CGRect(x: 0, y: 0, w: ScreenWidth * (310/375), h: 50)
        layer.cornerRadius = 25
        
        subscribeButton.layer.insertSublayer(layer, at: 0)
        subscribeButton.layer.shadowColor = UIColor(hexString: "#FF6B00")!.cgColor
        subscribeButton.layer.shadowOpacity = 0.16
        subscribeButton.layer.shadowOffset = CGSize(width: 0, height: 7)
        subscribeButton.layer.shadowRadius = 18
        subscribeButton.animationType = .pop(repeatCount: 200)
        subscribeButton.duration = 1.5
        subscribeButton.force = 0.5
        currentProductButton = yearProductButton
        
        let termsTitle = NSAttributedString(string: "使用条款").underline()
        let policyTitle = NSAttributedString(string: "隐私政策").underline()
        termsButton.setAttributedTitle(termsTitle, for: .normal)
        termsButton.setAttributedTitle(termsTitle, for: .highlighted)
        privacyButton.setAttributedTitle(policyTitle, for: .normal)
        privacyButton.setAttributedTitle(policyTitle, for: .highlighted)

    }
    
    func setupPriceLabel() {
        
    }
    
    func setupPlayer() {
        
        guard let url = Bundle.main.url(forResource: "subscribe", withExtension: "mp4")
        else { return }
        
        let playItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playItem)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = CGRect(x: 0, y: 0, w: ScreenWidth, h: ScreenWidth * (250/375))
        
        self.videoContentView.layer.addSublayer(playerLayer)
        player?.play()
    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(replay), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object:nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(replay), name: .init(rawValue: "kSceneDidBecomeActive"), object: nil)
    }
    
    func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        NotificationCenter.default.removeObserver(self,name: .init("kSceneDidBecomeActive"),object: nil)
    }
    
    
//    MARK: - Action
    
    @objc func replay() {
        self.player?.seek(to: .zero)
        self.player?.play()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        SubscribeManager.shared.subscribeCancel()
        self.subscribeCancel?()
        self.dismiss(animated: true)
    }
    
    
    @IBAction func productSelectAction(_ sender: UIButton) {
        
        currentProductButton?.layer.borderColor = UIColor(hexString: "#F0E2D2")!.cgColor
        currentProductButton?.layer.borderWidth = 1.5
        currentProductButton?.isSelected = false
        
        sender.layer.borderColor = UIColor(hexString: "#FCA23D")!.cgColor
        sender.layer.borderWidth = 2
        sender.isSelected = true
        
        currentProductButton = sender
        
        var describeText = ""
        if sender.tag == 0 {
            describeText = "之后以￥36.00/年续费，随时可取消"
        } else if sender.tag == 1 {
            describeText = "之后以￥12.00/季续费，随时可取消"
        } else  {
            describeText = "一次购买，永久特权"
        }
        subscribeDescribeLabel.text = describeText
    }
    
    
    @IBAction func subscribeAction(_ sender: Any) {
        
    }
    
    
    @IBAction func restoreAction(_ sender: Any) {
    }
    
    
    @IBAction func toTermsOfUsage(_ sender: Any) {
        
    }
    
    
    @IBAction func toPrivacPolicy(_ sender: Any) {
        
        
    }
    
}
