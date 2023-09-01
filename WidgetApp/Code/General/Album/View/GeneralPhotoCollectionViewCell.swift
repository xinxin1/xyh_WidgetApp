//
//  GeneralPhotoCollectionViewCell.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/21.
//

import UIKit

class GeneralPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var localIdentifier : String = ""
    
    var imageRequestID : Int32?
    
    var assetModel : TZAssetModel? {
        
        didSet {
            
            localIdentifier = assetModel?.asset.localIdentifier ?? ""
            
            let imageRequestID = TZImageManager.default().getPhotoWith(assetModel?.asset, photoWidth: self.tz_width, completion: { photo, info, isDegraded in
                
                // Set the cell's thumbnail image if it's still showing the same asset.
                if self.localIdentifier == self.assetModel?.asset.localIdentifier {
                    self.imageView.image = photo
                    self.setNeedsLayout()
                    
                } else {
                    // NSLog(@"this cell is showing other asset");
                    PHImageManager.default().cancelImageRequest(self.imageRequestID ?? 0)
                }
                if !isDegraded {
                    self.imageRequestID = 0;
                }
            }, progressHandler: nil, networkAccessAllowed: false)
            
            if (imageRequestID != 0) && (self.imageRequestID != nil) && imageRequestID != self.imageRequestID {
                
                PHImageManager.default().cancelImageRequest(self.imageRequestID!)
                // NSLog(@"cancelImageRequest %d",self.imageRequestID);
            }
            self.imageRequestID = imageRequestID;
                
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 3
    }
}
