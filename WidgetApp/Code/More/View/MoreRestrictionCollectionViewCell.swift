//
//  MoreRestrictionCollectionViewCell.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/9.
//

import UIKit

class MoreRestrictionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var model: InstructionItem? {
        didSet {
            imageView.image = UIImage(named: model?.image ?? "")
            titleLabel.text = model?.title
            detailLabel.text = model?.content
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    
    func setupView() {
        self.cardView.layer.masksToBounds = true
        self.cardView.layer.cornerRadius = 12
    }

}
