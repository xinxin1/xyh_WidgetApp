//
//  ExploreWidgetCollectionViewCell.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/14.
//

import UIKit

class ExploreWidgetCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var vipImageView: UIImageView!
    
    var widgetModel: ExploreWidgetModel? {
        didSet {
            let url = yunJiaSu + (widgetModel?.previewImage ?? "")
            coverImageView.setImageWith(URL(string: url), placeholder: nil, options: .setImageWithFadeAnimation) { image, url, type, stage, error in
                if error != nil {
                    
                }
            }
            nameLabel.text = widgetModel?.widgetName
            vipImageView.isHidden = !(widgetModel?.isVip ?? false)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        coverImageView.layer.masksToBounds = true
        coverImageView.layer.cornerRadius = 12
        
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowOffset = CGSize(width: 0, height: 5)
        cardView.layer.shadowRadius = 6
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowColor = UIColor(hexString: "#B7BFCD")!.cgColor        
    }

    

}
