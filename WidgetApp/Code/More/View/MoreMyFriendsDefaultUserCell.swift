//
//  MoreMyFriendsDefaultUserCell.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/11.
//

import UIKit

class MoreMyFriendsDefaultUserCell: UICollectionViewCell {
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nickNameLabel: UILabel!
    
    var deleteBlock: (()->())?
    
    var user: UserModel? {
        didSet {
            let url = URL(string: user?.avatarUrl ?? "")
            avatarImageView.setImageWith(url, placeholder: UIImage.init(named: "more_setting_about_icon"))
            nickNameLabel.text = user?.nickName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cardView.layer.masksToBounds = true
        self.cardView.layer.cornerRadius = 12
        
        self.avatarImageView.layer.masksToBounds = true
        self.avatarImageView.layer.cornerRadius = 16
    }

    @IBAction func deleteAction(_ sender: Any) {
        deleteBlock?()
    }
}
