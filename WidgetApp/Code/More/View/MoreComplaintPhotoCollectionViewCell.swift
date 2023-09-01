//
//  MoreComplaintPhotoCollectionViewCell.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/19.
//

import UIKit

class MoreComplaintPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    var deleteBlock: (()->())?
    var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cardView.layer.cornerRadius = 6
        self.cardView.layer.masksToBounds = true
    }
    
    
    
    @IBAction func deleteAction(_ sender: UIButton) {
        deleteBlock?()
    }
    
}
