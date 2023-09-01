//
//  ExploreMyWidgetCollectionViewCell.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/17.
//

import UIKit

class ExploreMyWidgetCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var installButton: UIButton!
    
    @IBOutlet weak var separatorView: UIView!
    
    var widget: ExploreWidgetModel? {
        didSet {
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupView() {
        
    }
    
    @IBAction func installAction(_ sender: Any) {
        
    }
}
