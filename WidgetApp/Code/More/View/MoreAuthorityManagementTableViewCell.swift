//
//  MoreAuthorityManagementTableViewCell.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/10.
//

import UIKit

class MoreAuthorityManagementTableViewCell: UITableViewCell {
    
    @IBOutlet weak var permissionImageView: UIImageView!
    
    @IBOutlet weak var permissionLabel: UILabel!
    
    @IBOutlet weak var describeLabel: UILabel!
    
    @IBOutlet weak var stateLabel: UILabel!
    
    @IBOutlet weak var permissionSwitch: UISwitch!
    
    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var arrowImageView: UIImageView!
    var item: PermissionItem? {
        didSet {
            self.permissionImageView.image = UIImage(named: item?.image ?? "")
            self.permissionLabel.text = item?.title
            self.describeLabel.text = item?.content
            self.stateLabel.text = item?.state.description
            self.stateLabel.textColor = item?.state.color

            self.stateLabel.isHidden = item?.type == .advertisment
            self.permissionSwitch.isHidden = item?.type != .advertisment
            self.separatorView.isHidden = item?.type == .advertisment
            self.arrowImageView.isHidden = item?.type == .advertisment
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
