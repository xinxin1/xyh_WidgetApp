//
//  CourseCollectionViewCell.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/24.
//

import UIKit

class CourseCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    
    var course: CourseModel? {
        didSet {
            addButton.isHidden = (course?.courseName.length ?? 0) > 0
            textField.text = course?.courseName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.borderColor = UIColor(hexString: "D5D5D5")!.cgColor
        self.contentView.layer.borderWidth = 0.5
        
    }

}
