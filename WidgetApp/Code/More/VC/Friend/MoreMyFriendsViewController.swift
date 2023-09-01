//
//  MoreMyFriendsViewController.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/10.
//

import UIKit

class MoreMyFriendsViewController: BaseViewController {
    
    enum Section: Int, Hashable, CaseIterable {
        case header, friend
    }
    
    static let sectionBackgroundDecorationElementKind = "BackgroundElementKind"
    static let sectionHeaderElementKind = "TitleKind"
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, UserModel>!
    
    var friends: [UserModel] = []
    var currentUser: UserModel?
    
    lazy var placeholderView : UIView = {
        let view = UIView()
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
    }
    
    override func setupView() {
        super.setupView()
        
        configureNavigationBar()
        configureCollectionView()
        configureDataSource()
        configureAddButton()
    }
    
    func setupData() {
        self.currentUser = UserModel(avatarUrl: "", nickName: "")
        self.friends = [UserModel(userId: "1234", avatarUrl: "", nickName: "李雷雷"), UserModel(userId: "", avatarUrl: "", nickName: "韩梅梅")]
        applyInitialSnapshots()
    }

    func configureNavigationBar() {
        self.title = NSLocalizedString("我的好友", comment: "")
        self.sh_prefersNavigationBarHidden = false
        self.addBackButton()
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = UIColor(hexString: "#F5F5F5")!
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    // collectionView 整体布局
    func createLayout() -> UICollectionViewLayout {
        
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            
            let section: NSCollectionLayoutSection
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // header布局
            if sectionKind == .header {
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5067))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 0
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                
            // friend 布局
            } else {

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(55))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 5
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 15, trailing: 20)
                
                // section header
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(37))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: MoreMyFriendsViewController.sectionHeaderElementKind, alignment: .top)
                section.boundarySupplementaryItems = [sectionHeader]
            }
            return section
        }
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        
        return layout
    }

    // 组织数据源
    func configureDataSource() {
        //当前用户cell
        let headerRegistration = UICollectionView.CellRegistration<MoreMyFriendsCurrentUserCell, UserModel>(cellNib: UINib.init(nibName: "MoreMyFriendsCurrentUserCell", bundle: nil)) { cell, indexPath, item in
            cell.shareBlock = {
                
            }
            cell.copyBlock = {
                tool.copy(message: self.currentUser?.userId ?? "")
            }
        }
        
        // “好友列表”
        let titleHeaderRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(supplementaryNib: UINib(nibName: "TitleSupplementaryView", bundle: nil), elementKind: MoreMyFriendsViewController.sectionHeaderElementKind) { supplementaryView, elementKind, indexPath in
            supplementaryView.backgroundColor = .clear
        }
        
        // 好友cell
        let friendsRegistration = UICollectionView.CellRegistration<MoreMyFriendsDefaultUserCell, UserModel>(cellNib: UINib.init(nibName: "MoreMyFriendsDefaultUserCell", bundle: nil)) { cell, indexPath, item in
            cell.user = item
            cell.deleteBlock = {
                self.showDeleteAlert { // 弹出删除确认框
                    
                }
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, UserModel>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
            
            switch section {
            case .header:
                return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: item)
            default:
                return collectionView.dequeueConfiguredReusableCell(using: friendsRegistration, for: indexPath, item: item)
            }
        })
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: titleHeaderRegistration, for: index)
        }
    }
    
    //  截面初始化
    func applyInitialSnapshots() {

        let sections = Section.allCases
        var snapshot = NSDiffableDataSourceSnapshot<Section, UserModel>()
        snapshot.appendSections(sections)
        
        // header
        let headerItems = [currentUser!]
        snapshot.appendItems(headerItems,toSection: .header)
        
        // friend
        let friendItems = friends
        snapshot.appendItems(friendItems,toSection: .friend)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    
    func configureAddButton() {
        
        let addButton = UIButton()
        addButton.setTitle("添加好友", for: .normal)
        addButton.setTitleColor(UIColor(hexString: "#644BFF"), for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        addButton.backgroundColor = UIColor.white
        addButton.layer.cornerRadius = 12
        addButton.layer.masksToBounds = true
        addButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        view.addSubview(addButton)
        
        addButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 300, height: 50))
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-83)
        }
    }
    
    @objc func addAction() {
        self.showAddFriendAlert()
    }
}

extension MoreMyFriendsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}


extension MoreMyFriendsViewController {

}
