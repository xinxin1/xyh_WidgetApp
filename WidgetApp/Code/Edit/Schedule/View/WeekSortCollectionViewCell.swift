//
//  WeekSortCollectionViewCell.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/24.
//

import UIKit

class WeekSortCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var weekLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var timeModel: CourseTimeModel? {
        didSet {
            
            weekLabel.text = timeModel?.weekCN
            
            if timeModel?.isToday ?? false {
                timeLabel.text = " 今日 "
                timeLabel.textColor = .white
                timeLabel.backgroundColor = UIColor(hexString: "#644BFF")
            } else  {
                timeLabel.text = "\(timeModel?.month ?? 0).\(timeModel?.day ?? 0)"
                timeLabel.backgroundColor = .white
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.borderColor = UIColor(hexString: "D5D5D5")!.cgColor
        self.contentView.layer.borderWidth = 0.5
    }

}
