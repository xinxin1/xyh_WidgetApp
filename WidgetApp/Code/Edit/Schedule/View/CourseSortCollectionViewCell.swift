//
//  CourseSortCollectionViewCell.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/24.
//

import UIKit
import YYKit

class CourseSortCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sortLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.layer.borderColor = UIColor(hexString: "D5D5D5")!.cgColor
        self.contentView.layer.borderWidth = 0.5
    }

}
