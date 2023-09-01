//
//  MoreCommonProblemViewController.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/10.
//

import UIKit

class MoreCommonProblemViewController: BaseViewController {
    
    var collectionView: UICollectionView!
    var cellType: MoreCommonProblemCollectionViewCell.CommonProblemCellType = .defaultCell {
        didSet {
            if cellType == .defaultCell {
                items = InstructionItem.problemSummaryItems

            } else {
                if currentIndex == 0 {
                    items = InstructionItem.problemDetailItems

                } else {
                    items = InstructionItem.iconBookItems
                }
            }
        }
    }
    
    var items : [InstructionItem] = []
    var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupView() {
        self.sh_prefersNavigationBarHidden = false
        self.title =  NSLocalizedString("常见问题", comment: "")
        self.cellType = .defaultCell
        
        self.addBackButton()
        
        self.setupCollectionView()
    }

    func setupCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 40, right: 20)
        
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "#F5F5F5")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MoreCommonProblemCollectionViewCell.self, forCellWithReuseIdentifier: "MoreCommonProblemCollectionViewCell")
        
        self.view.addSubview(collectionView!)
        collectionView!.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }

    }
    
    override func backAction() {
        if cellType == .defaultCell {
            self.navigationController?.popViewController(animated: true)
            
        } else {
            cellType = .defaultCell
            self.collectionView.reloadData()
        }
    }
}

extension MoreCommonProblemViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreCommonProblemCollectionViewCell", for: indexPath) as? MoreCommonProblemCollectionViewCell
        
        cell?.cellType = cellType
        
        cell?.item = items[indexPath.item]
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if cellType == .defaultCell {
            return CGSize(width: ScreenWidth -  40, height: 110)
        } else {
            return CGSize(width: ScreenWidth -  40, height: 55)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if cellType == .defaultCell {
            currentIndex = indexPath.item
            cellType = .detailCell
            self.collectionView.reloadData()
            
        } else {
            
            let dVC = MoreCommonProblemDetailViewController()
            dVC.item = items[indexPath.item]
            self.navigationController?.pushViewController(dVC, animated: true)
        }
    }
}

