//
//  ExploreHeaderBannerCell.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/18.
//

import UIKit

class ExploreHeaderBannerCell: UICollectionViewCell {
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var placeholderImage : UIImage? {
        didSet {
            imageView.image = placeholderImage
        }
    }
    
    var activity : ActivityInfoModel? {
        didSet {
            let url = yunJiaSu + (activity?.url ?? "")
            imageView.setImageWith(URL(string: url), placeholder: placeholderImage)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }

    
    func setupView() {
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15
        
        cardView.backgroundColor = UIColor.clear
        cardView.layer.cornerRadius = 15
        cardView.layer.shadowOffset = CGSize(width: 0, height: 6)
        cardView.layer.shadowRadius = 7
        cardView.layer.shadowOpacity = 0.16
        cardView.layer.shadowColor = UIColor(hexString: "#BBD4FD")!.cgColor
    }
}
