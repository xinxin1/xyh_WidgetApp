//
//  ExploreCategoryViewController.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/14.
//

import UIKit
import JXPagingView

class ExploreCategoryViewController: BaseViewController {
    
    var listViewDidScrollCallback: ((UIScrollView) -> ())?
    var collectionView: UICollectionView!
    var widgetSections: [WidgetSection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupData()
    }
    
    override func setupView() {
        self.view.backgroundColor = UIColor.clear
        setupCollectionView()
    }
     
    func setupCollectionView() {
        
        let layout = ExploreLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 12
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 17)
        
        self.collectionView = UICollectionView(frame: CGRectZero,collectionViewLayout: layout)
        self.collectionView.backgroundColor = UIColor(hexString: "#FBFCFF")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.contentMode = .left
        
        self.collectionView.register(UINib(nibName: "ExploreWidgetCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ExploreWidgetCollectionViewCell.className)
        self.collectionView.register(UINib(nibName: "ExploreWidgetSectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ExploreWidgetSectionHeaderView.className)
        self.view.addSubview(self.collectionView)
        
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
    }
    
    
    func setupData() {
        let small1 = ExploreWidgetModel.defaultSmall
        let small2 = ExploreWidgetModel(widgetName: "照片zu", sizeType: 0, previewImage: "explore_header_transparent_icon", puarchaseType: "0")
        
        let medium1 = ExploreWidgetModel.defaultMedium
        let medium2 = ExploreWidgetModel(widgetName: "翻转时钟", sizeType: 1, previewImage: "more_friend_header_bg", puarchaseType: "1")
        
        let large1 = ExploreWidgetModel.defaultLarge
        let large2 = ExploreWidgetModel(widgetName: "纪念日", sizeType: 2, previewImage: "more_top_subscribe_bg", puarchaseType: "2")
        
        let section1 = WidgetSection(sectionName: "热门", sectionImage: "more_question_hot_icon", sectionWidgets: [small1,small1,small2,large1,small1,medium2])
        widgetSections.append(section1)
        
        self.collectionView.reloadData()
    }

}

extension ExploreCategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.widgetSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.widgetSections[section].sectionWidgets?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreWidgetCollectionViewCell.className, for: indexPath) as! ExploreWidgetCollectionViewCell
        
        cell.widgetModel = widgetSections[indexPath.section].sectionWidgets?[indexPath.item]
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let widget = widgetSections[indexPath.section].sectionWidgets?[indexPath.item]
        
        if widget?.isVip ?? false {
            dPrint("点击vip组件")
            SubscribeManagerEX.cheakProductPurchaseStatus({
                
            }, currentVC: self) {
                
            }
        } else  {
            dPrint("点击免费组件")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widgetModel = widgetSections[indexPath.section].sectionWidgets?[indexPath.item]
        
        guard let widgetModel = widgetModel else { return CGSize.zero}
        
        let size = widgetModel.widgetType.imageSize
        
        return CGSize(width: size.width + 3, height: size.height + 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ExploreWidgetSectionHeaderView", for: indexPath) as! ExploreWidgetSectionHeaderView
        
        header.sectionImageView.image = UIImage(named: widgetSections[indexPath.section].sectionImage ?? "")
        header.sectionName.text = widgetSections[indexPath.section].sectionName
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: ScreenWidth, height: 56)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.listViewDidScrollCallback?(scrollView)
    }
}


extension ExploreCategoryViewController: JXPagingViewListViewDelegate {
    public func listView() -> UIView {
        return self.view
    }
    
    public func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.listViewDidScrollCallback = callback
    }

    public func listScrollView() -> UIScrollView {
        return self.collectionView
    }
}
