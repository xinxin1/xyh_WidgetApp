//
//  ExploreLayout.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/14.
//

import UIKit


class ExploreLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let originalAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        var updateAttributes : [UICollectionViewLayoutAttributes] = []
        updateAttributes.append(contentsOf: originalAttributes)
        
        for attribute in originalAttributes {
            if attribute.representedElementKind == nil {
                let index = updateAttributes.firstIndex(of: attribute) ?? 0
                updateAttributes[index] = self.layoutAttributesForItem(at: attribute.indexPath)!
            }
        }
        return updateAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let cAttribute =  super.layoutAttributesForItem(at: indexPath)
        guard let currentAttribute = cAttribute else { return cAttribute }
        
        let sectionInset = (self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
                
        if indexPath.item == 0 {
            var originalFrame = currentAttribute.frame
            originalFrame.origin.x = sectionInset.left
            currentAttribute.frame = originalFrame
            
            return currentAttribute
        }
        
        let layoutWidth = (self.collectionView?.frame.width ?? ScreenWidth) - sectionInset.left - sectionInset.right
        
        let previousIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
        let previousFrame = (self.layoutAttributesForItem(at: previousIndexPath))!.frame

        let currentFrame = currentAttribute.frame
        let strecthedCurrentFrame = CGRect(x: sectionInset.left, y: currentFrame.origin.y, w: layoutWidth, h: currentFrame.size.height)
    
        if previousFrame.intersects(strecthedCurrentFrame) == false {
            
            var originalFrame = currentAttribute.frame
            originalFrame.origin.x = sectionInset.left
            currentAttribute.frame = originalFrame
            
            return currentAttribute
        }
        
        let previousFrameRightPoint = CGFloat((previousFrame.origin.x)) + CGFloat((previousFrame.size.width))
        var frame = currentAttribute.frame
        frame.origin.x = previousFrameRightPoint + self.minimumInteritemSpacing
        currentAttribute.frame = frame
        
        return currentAttribute
    }
    
//
//    func evaluatedSectionInsetForItemAtIndex(index: Int) -> UIEdgeInsets {
//
//        guard let delegate = self.collectionView?.delegate else { return self.sectionInset }
//
//        let d = delegate as? UICollectionViewDelegateFlowLayout
//
//        return d?.collectionView?(self.collectionView!, layout: self, insetForSectionAt: index) ?? self.sectionInset
//
//    }

}
