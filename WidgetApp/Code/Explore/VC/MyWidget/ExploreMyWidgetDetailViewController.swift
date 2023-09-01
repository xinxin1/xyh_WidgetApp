//
//  ExploreMyWidgetDetailViewController.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/17.
//

import UIKit
import JXSegmentedView

class ExploreMyWidgetDetailViewController: BaseViewController {
    
    enum Item: Hashable {
        case widget(DBItem)
        case advertisment
        case recommend(RecommendItem)
    }
    
    struct RecommendItem: Hashable {
        let widgetName: String
        let image: String
    }
    
    struct DBItem: Hashable {
        let name: String
        let image: String
    }
    
    struct Section: Hashable {
        let title: String
        var items:[Item]
    }
    
    static let sectionBackgroundDecorationElementKind = "BackgroundElementKind"

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    var widgetType: GeneralWidgetType = .small
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    override func setupView() {
        self.view.backgroundColor = UIColor.clear
        configureNavigationBar()
        configureCollectionView()
        configureDataSource()
//        applyInitialSnapshots()
    }
    
    func configureNavigationBar() {
        self.sh_prefersNavigationBarHidden = true
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    // collectionView 整体布局
    func createLayout() -> UICollectionViewLayout {
        
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                        
            let section: NSCollectionLayoutSection
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // widget布局
            if sectionIndex == 0 {
                
                item.contentInsets = NSDirectionalEdgeInsets.zero
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(110))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 0
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)
                
            // 广告布局
            } else if sectionIndex == 1 {

                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(ScreenWidth - 20),
                                                       heightDimension: .absolute(110))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20)
                
            //推荐布局
            } else {
                
                let width = (ScreenWidth - 109) / 2 - 0.001
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(width + 3),
                                                       heightDimension: .absolute(width + 24))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20)
                
                let backgroundDecoration = NSCollectionLayoutDecorationItem.background(
                    elementKind: MoreViewController.sectionBackgroundDecorationElementKind)
                backgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 15, trailing: 20)
                section.decorationItems = [backgroundDecoration]
            }
            return section
        }
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        layout.register(
            MoreBackgroundDecorationView.self,
            forDecorationViewOfKind: ExploreMyWidgetDetailViewController.sectionBackgroundDecorationElementKind)
        
        return layout
    }
    
    // 组织数据源
    func configureDataSource() {
        
        let myWidgetRegistration = UICollectionView.CellRegistration<ExploreMyWidgetCollectionViewCell,DBItem>(cellNib: UINib(nibName: "ExploreMyWidgetCollectionViewCell", bundle: nil)) { cell, indexPath, itemIdentifier in
            
        }

        let advertismentRegistration = UICollectionView.CellRegistration<UICollectionViewCell,Item> { cell, indexPath, itemIdentifier in
            
        }
        
        let recommendRegistration = UICollectionView.CellRegistration<ExploreWidgetCollectionViewCell, RecommendItem> { cell, indexPath, item in

        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            switch item {
                
            case .widget(let dbItem):
                return collectionView.dequeueConfiguredReusableCell(using: myWidgetRegistration, for: indexPath, item: dbItem)
                
            case .advertisment:
                return collectionView.dequeueConfiguredReusableCell(using: advertismentRegistration, for: indexPath, item: nil)
                
            case .recommend(let rItem):
                return collectionView.dequeueConfiguredReusableCell(using: recommendRegistration, for: indexPath, item: rItem)
            }
        })
    }
    
    
    //  截面初始化
    func applyInitialSnapshots() {

    }
}


extension ExploreMyWidgetDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}


extension ExploreMyWidgetDetailViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
}
