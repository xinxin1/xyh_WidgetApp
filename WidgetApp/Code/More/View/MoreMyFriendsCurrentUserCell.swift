//
//  MoreMyFriendsCurrentUserCell.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/10.
//

import UIKit

class MoreMyFriendsCurrentUserCell: UICollectionViewCell {
    
    @IBOutlet weak var userIDLabel: UILabel!
    
    var copyBlock: (()->())?
    var shareBlock: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    @IBAction func copyAction(_ sender: Any) {
        copyBlock?()
    }
    
    
    @IBAction func shareAction(_ sender: Any) {
        shareBlock?()
    }
}
