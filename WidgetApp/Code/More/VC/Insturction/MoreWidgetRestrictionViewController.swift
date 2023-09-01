//
//  MoreWidgetRestrictionViewController.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/9.
//

import UIKit

class MoreWidgetRestrictionViewController: BaseViewController {
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        self.sh_prefersNavigationBarHidden = false
        self.title =  "组件限制说明"
        self.addBackButton()
        
        self.setupCollectionView()
    }

    func setupCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 40, right: 20)
        
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "#F5F5F5")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib.init(nibName: "MoreRestrictionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MoreRestrictionCollectionViewCell")
        
        self.view.addSubview(collectionView!)
        collectionView!.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }

    }
}

extension MoreWidgetRestrictionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return InstructionItem.widgetRestrictionItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreRestrictionCollectionViewCell", for: indexPath) as? MoreRestrictionCollectionViewCell
        
        cell?.model = InstructionItem.widgetRestrictionItems[indexPath.item]
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let content = InstructionItem.widgetRestrictionItems[indexPath.item].content ?? ""
        
        let rectSize = content.toNSString.boundingRect(with: CGSize.init(width: ScreenWidth - 80, height: 2000), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .semibold) ], context: nil)
        
        let height = rectSize.height + 97
        return CGSize(width: ScreenWidth -  40, height: height)
    }
}
