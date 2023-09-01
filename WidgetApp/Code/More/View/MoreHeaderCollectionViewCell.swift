//
//  MoreHeaderCollectionViewCell.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/8.
//

import UIKit

class MoreHeaderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nickNameLabel: UILabel!
    
    @IBOutlet weak var messageButton: UIButton!
    
    @IBOutlet weak var badgeView: UIView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    var modifyBlock: (()->())?
    var subscribeBlock: (()->())?
    var messageBlock: (()->())?
    var loginBlock: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    
    func configView() {
        avatarImageView.addTapGesture { tap in
            self.loginBlock?()
        }
    }
    
    
    @IBAction func messageAction(_ sender: UIButton) {
        messageBlock?()
    }
    
    
    @IBAction func modifyAction(_ sender: UIButton) {
        modifyBlock?()
    }
    
    
    @IBAction func subscribeAction(_ sender: UIButton) {
        
    }
    
}
