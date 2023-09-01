//
//  LaunchScreenVideoPlayController.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/21.
//

import UIKit
import AVFoundation

class LaunchScreenVideoPlayController: BaseViewController {
    
    var player: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeNotification()
    }
    
    override func setupView() {
        super.setupView()
        self.configPlayer()

        if app_purchased == true {
            self.changeRootViewController()
        }
    }
    
    func addNotification() {
                
        NotificationCenter.default.addObserver(self, selector: #selector(endPlay), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object:nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(replay), name: .init(rawValue: "kSceneDidBecomeActive"), object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(appOpenAdDidEnd), name: ADManager.didFullScreenAdDismissedNotification, object:nil)
    }
    
    func removeNotification() {
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        NotificationCenter.default.removeObserver(self,name: .init("kSceneDidBecomeActive"),object: nil)
        
//        NotificationCenter.default.removeObserver(self, name: ADManager.didFullScreenAdDismissedNotification, object: nil)
    }

    
    func configPlayer() {
        
        guard let url = Bundle.main.url(forResource: "LaunchScreenVideo", withExtension: "mp4")
        else { return }
        
        let playItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playItem)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        
        playerLayer.frame = ScreenBounds
        playerLayer.videoGravity = .resizeAspectFill
        
        self.view.layer.addSublayer(playerLayer)
        player?.play()
    }
    
    
    @objc func endPlay() {
        changeRootViewController()
//        self.player?.seek(to: .zero, toleranceBefore: .zero, toleranceAfter: .zero)
//        self.player?.play()
    }
    
    @objc func replay() {
        self.player?.seek(to: .zero)
        self.player?.play()
    }
 
    func changeRootViewController() {
        
        let window = UIWindow.getWindow()
        window.rootViewController = GeneralTabBarController()
        window.makeKeyAndVisible()
  
    }
}
