//
//  MoreViewController.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/7.
//

import UIKit

class MoreViewController: BaseViewController {
    
    enum Section: Int, Hashable, CaseIterable, CustomStringConvertible {
        case header, friend, instruction, about
        
        var description: String {
            switch self {
            case .header: return "Header"
            case .friend: return "Friend"
            case .instruction: return "Instruction"
            case .about: return "About"
            }
        }
        
        var items: [Item]? {
            switch self {
            case .header:
                return [Item()]
                
            case .friend:
                return [Item(title: "我的好友",image: "more_setting_friend_icon", itemType: .friend)]
                
            case .instruction:
                return [Item(title: "常见问题",image: "more_setting_question_icon", itemType: .question),
                        Item(title: "组件限制",image: "more_setting_widget_limited_icon", itemType: .restriction),
                        Item(title: "权限管理",image: "more_setting_permission_icon", itemType: .permission)]
                
            case .about:
                return [Item(title: "我要吐槽",image: "more_setting_complain_icon", itemType: .complaint),
                        Item(title: "加个鸡腿",image: "more_setting_appreciate_icon", itemType: .appreciate),
                        Item(title: "清理缓存",image: "more_setting_clean_icon", itemType: .clean),
                        Item(title: "关于",image: "more_setting_about_icon", itemType: .about)]
            }
        }
    }

    struct Item: Hashable {
        
        enum ItemType {
        case friend, question, restriction, permission, complaint, appreciate, clean, about
        }

        let title: String?
        let image: String?
        let hasArrow: Bool
        let itemType: ItemType
        
        init(title: String? = nil, image: String? = nil, hasArrow: Bool = true, itemType: ItemType = .friend) {
            self.title = title
            self.image = image
            self.hasArrow = hasArrow
            self.itemType = itemType
        }
        
        private let identifier = UUID()
    }
    
    static let sectionBackgroundDecorationElementKind = "BackgroundElementKind"

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    var userModel: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureNavigationBar()
        configureCollectionView()
        configureDataSource()
        applyInitialSnapshots()
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
            
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            
            let section: NSCollectionLayoutSection
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // header布局
            if sectionKind == .header {
                
                item.contentInsets = NSDirectionalEdgeInsets.zero
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.656))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 0
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                
            // friend / instruction / About 布局
            } else {

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(55))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 5
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 15, trailing: 20)
                
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
            forDecorationViewOfKind: MoreViewController.sectionBackgroundDecorationElementKind)
        
        return layout
    }

    // 组织数据源
    func configureDataSource() {
        
        let headerRegistration = UICollectionView.CellRegistration<MoreHeaderCollectionViewCell, Item>(cellNib: UINib.init(nibName: "MoreHeaderCollectionViewCell", bundle: nil)) { cell, indexPath, item in
            cell.avatarImageView.image = UIImage(named: "more_setting_about_icon")
            cell.nickNameLabel.text = "WuQiong"
            cell.modifyBlock = {
                dPrint("修改按钮点击")
                self.showUserInfoModifier()
            }
            
            cell.messageBlock = {
                dPrint("消息按钮点击")
                self.toMessage()
            }
            
            cell.loginBlock = {
                dPrint("点击头像登陆")
                self.toLogin()
            }
        }
        
        let defaultRegistration = UICollectionView.CellRegistration<MoreDefaultCollectionViewCell, Item> { cell, indexPath, item in
            
            cell.leftImageView.image = UIImage(named: item.image ?? "")
            cell.label.text = item.title
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
            
            switch section {
            case .header:
                return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: item)
            default:
                return collectionView.dequeueConfiguredReusableCell(using: defaultRegistration, for: indexPath, item: item)
            }
        })
    }
    
    //  截面初始化
    func applyInitialSnapshots() {

        // sections
        let sections = Section.allCases
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections)

        // default 
        for section in Section.allCases {
            let items = section.items!
            snapshot.appendItems(items, toSection: section)
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}


extension MoreViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
        let items = section.items
        
        let item = items?[indexPath.item]
        
        switch item?.itemType {
        case .friend:
            toFriends()
            break
            
        case .question:
            toCommonProblem()
            break
            
        case .restriction:
            toWidgetRestriction()
            break
            
        case .permission:
            toAuthority()
            break
            
        case .complaint:
            toComplain()
            break
            
        case .appreciate:
            toRatting()
            break
            
        case .clean:
            toCleanCache()
            break
            
        case .about:
            toAbout()
            break
        default:
            break
        }
    }
}


extension MoreViewController {
    
    func toFriends() {
        self.navigationController?.pushViewController(MoreMyFriendsViewController(), animated: true)
    }
    
    func toMessage() {
        self.navigationController?.pushViewController(MoreMessageViewController(), animated: true)
    }
    
    func toCommonProblem() {
        self.navigationController?.pushViewController(MoreCommonProblemViewController(), animated: true)
    }
    
    func toWidgetRestriction() {
        self.navigationController?.pushViewController(MoreWidgetRestrictionViewController(), animated: true)
    }
    
    func toAuthority() {
        self.navigationController?.pushViewController(MoreAuthorityViewController(), animated: true)
    }
    
    func toComplain() {
        self.navigationController?.pushViewController(MoreComplaintViewController(), animated: true)
    }
    
    /// 跳转到 App Store评分页面
    func toRatting() {
        guard let rateUrl: URL = URL.init(string: "itms-apps://itunes.apple.com/app/id" + kAppStoreID + "?action=write-review") else {
            return
        }
        
        if UIApplication.shared.canOpenURL(rateUrl) {
            UIApplication.shared.open(rateUrl)
        }
    }
    
    func toCleanCache() {
        
    }
    
    func toAbout() {
        self.navigationController?.pushViewController(MoreAboutViewController(), animated: true)
    }
}
