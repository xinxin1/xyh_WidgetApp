//
//  GeneralEditWidgetScheduleViewController.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/24.
//

import UIKit
import IQKeyboardManagerSwift

class GeneralEditWidgetScheduleViewController: BaseViewController {
    
    enum Section: Int, Hashable, CaseIterable, CustomStringConvertible {
        case time, first ,second, third, forth, rest, fifth, sixth, seventh, eighth

        var description: String {
            switch self {
            case .time:
                return "8\n月"
            case .first:
                return "第\n1\n节"
            case .second:
                return "第\n2\n节"
            case .third:
                return "第\n3\n节"
            case .forth:
                return "第\n4\n节"
            case .rest:
                return "午\n休"
            case .fifth:
                return "第\n5\n节"
            case .sixth:
                return "第\n6\n节"
            case .seventh:
                return "第\n7\n节"
            case .eighth:
                return "第\n8\n节"
            }
        }
        
        var offset: Int? {
            switch self {
            case .first:
                return 0
            case .second:
                return 1
            case .third:
                return 2
            case .forth:
                return 3
            case .fifth:
                return 4
            case .sixth:
                return 5
            case .seventh:
                return 6
            case .eighth:
                return 7
            default:
                return nil
            }
        }
    }
    
    var timeModels : [CourseTimeModel] = []

    var courses = [[CourseModel(courseName: "语文", updateTime: "", courseSort: 1, weekSort: 1),
                    CourseModel(courseName: "", updateTime: "", courseSort: 2, weekSort: 1),
                    CourseModel(courseName: "数学", updateTime: "", courseSort: 3, weekSort: 1),
                    CourseModel(courseName: "英语", updateTime: "", courseSort: 4, weekSort: 1),
                    CourseModel(courseName: "", updateTime: "", courseSort: 5, weekSort: 1),
                    CourseModel(courseName: "", updateTime: "", courseSort: 6, weekSort: 1),
                    CourseModel(courseName: "物理", updateTime: "", courseSort: 7, weekSort: 1),
                    CourseModel(courseName: "体育", updateTime: "", courseSort: 8, weekSort: 1),],
                   
                   [CourseModel(courseName: "语文", updateTime: "", courseSort: 1, weekSort: 2),
                   CourseModel(courseName: "", updateTime: "", courseSort: 2, weekSort: 2),
                   CourseModel(courseName: "数学", updateTime: "", courseSort: 3, weekSort: 2),
                   CourseModel(courseName: "英语", updateTime: "", courseSort: 4, weekSort: 2),
                   CourseModel(courseName: "", updateTime: "", courseSort: 5, weekSort: 2),
                   CourseModel(courseName: "", updateTime: "", courseSort: 6, weekSort: 2),
                   CourseModel(courseName: "物理", updateTime: "", courseSort: 7, weekSort: 2),
                   CourseModel(courseName: "体育", updateTime: "", courseSort: 8, weekSort: 2),],
                   
                   [CourseModel(courseName: "语文", updateTime: "", courseSort: 1, weekSort: 3),
                   CourseModel(courseName: "", updateTime: "", courseSort: 2, weekSort: 3),
                   CourseModel(courseName: "数学", updateTime: "", courseSort: 3, weekSort: 3),
                   CourseModel(courseName: "英语", updateTime: "", courseSort: 4, weekSort: 3),
                   CourseModel(courseName: "", updateTime: "", courseSort: 5, weekSort: 3),
                   CourseModel(courseName: "", updateTime: "", courseSort: 6, weekSort: 3),
                   CourseModel(courseName: "物理", updateTime: "", courseSort: 7, weekSort: 3),
                   CourseModel(courseName: "体育", updateTime: "", courseSort: 8, weekSort: 3),],
                   
                   [CourseModel(courseName: "语文", updateTime: "", courseSort: 1, weekSort: 4),
                   CourseModel(courseName: "", updateTime: "", courseSort: 2, weekSort: 4),
                   CourseModel(courseName: "数学", updateTime: "", courseSort: 3, weekSort: 4),
                   CourseModel(courseName: "英语", updateTime: "", courseSort: 4, weekSort: 4),
                   CourseModel(courseName: "", updateTime: "", courseSort: 5, weekSort: 4),
                   CourseModel(courseName: "", updateTime: "", courseSort: 6, weekSort: 4),
                   CourseModel(courseName: "物理", updateTime: "", courseSort: 7, weekSort: 4),
                   CourseModel(courseName: "体育", updateTime: "", courseSort: 8, weekSort: 4),],
                   
                   [CourseModel(courseName: "语文", updateTime: "", courseSort: 1, weekSort: 5),
                   CourseModel(courseName: "", updateTime: "", courseSort: 2, weekSort: 5),
                   CourseModel(courseName: "数学", updateTime: "", courseSort: 3, weekSort: 5),
                   CourseModel(courseName: "英语", updateTime: "", courseSort: 4, weekSort: 5),
                   CourseModel(courseName: "", updateTime: "", courseSort: 5, weekSort: 5),
                   CourseModel(courseName: "", updateTime: "", courseSort: 6, weekSort: 5),
                   CourseModel(courseName: "物理", updateTime: "", courseSort: 7, weekSort: 5),
                   CourseModel(courseName: "体育", updateTime: "", courseSort: 8, weekSort: 5),]
    ]
    
    @IBOutlet weak var contentView: UIView!
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!

    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enable = true
        setupData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = false
    }
    
    override func setupView() {
        
        self.title = "编辑课程表"
        addBackButton()

        contentView.layer.borderColor = UIColor(hexString: "#D5D5D5").cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 6
        contentView.layer.masksToBounds = true
        configureCollectionView()
        configureDataSource()
    }
    
    func setupData() {
        getTimes()
        applyInitialSnapshots()
    }
    
    func configureCollectionView() {
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never

        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
 
    /// 课程表布局
    func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }

            let leadingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(35),
                                                  heightDimension: .fractionalHeight(1.0)))
            leadingItem.contentInsets = NSDirectionalEdgeInsets.zero
            

            switch sectionKind {
            case .rest:
                let trailingItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(ScreenWidth - 55),
                                                       heightDimension: .fractionalHeight(1.0)))
                trailingItem.contentInsets = NSDirectionalEdgeInsets.zero
                
                let nestedGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(0.1)),
                    subitems: [leadingItem, trailingItem])
                let section = NSCollectionLayoutSection(group: nestedGroup)
                return section

            default:
                
                let trailingItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalHeight(1.0)))
                trailingItem.contentInsets = NSDirectionalEdgeInsets.zero
                
                let trailingGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(ScreenWidth - 55), heightDimension: .fractionalHeight(1.0)), subitem: trailingItem, count: 5)

                let nestedGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(0.1)),
                    subitems: [leadingItem, trailingGroup])
                let section = NSCollectionLayoutSection(group: nestedGroup)
                return section
            }
        }
        
        return layout
    }
    
    // 组织数据源
    func configureDataSource() {

        let weekRegistration = UICollectionView.CellRegistration<WeekSortCollectionViewCell, CourseTimeModel> (cellNib: UINib(nibName: "WeekSortCollectionViewCell", bundle: nil)) { cell, indexPath, item in
            cell.timeModel = item
        }
        
        let sortRegistration = UICollectionView.CellRegistration<CourseSortCollectionViewCell, String>(cellNib: UINib(nibName: "CourseSortCollectionViewCell", bundle: nil)) { cell, indexPath, itemIdentifier in
            
            cell.sortLabel.text = itemIdentifier
            
            if Section(rawValue: indexPath.section) == .rest {
                cell.sortLabel.textColor = UIColor(hexString: "#A5A7AF")
                if indexPath.item == 1 {
                    cell.sortLabel.font = UIFont.systemFont(ofSize: 16)
                }
            }
        }
        
        let courseRegistration = UICollectionView.CellRegistration<CourseCollectionViewCell, CourseModel>(cellNib: UINib(nibName: "CourseCollectionViewCell", bundle: nil)) { cell, indexPath, item in
            cell.course = item
        }
  
        
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
                        
            switch item {
            case let model as CourseTimeModel:
                return collectionView.dequeueConfiguredReusableCell(using: weekRegistration, for: indexPath, item: model)
                
            case let model as String:
                return collectionView.dequeueConfiguredReusableCell(using: sortRegistration, for: indexPath, item: model)
                
            case let model as CourseModel:
                return collectionView.dequeueConfiguredReusableCell(using: courseRegistration, for: indexPath, item: model)
            default:
                return nil
            }
        })
    }
    
    // 取当前一周时间
    func getTimes() {
        
        let component : Set<Calendar.Component> = [.year,.month,.day,.weekday]

        var calendar = Calendar.current
        calendar.firstWeekday = 2
        
        var dateComponents = calendar.dateComponents(component, from: Date())
        let nWeekDay = dateComponents.weekday ?? 1
        let nMonthDay = dateComponents.day ?? 1
        let nMonth = dateComponents.month ?? 1
        
        var diff = nWeekDay - calendar.firstWeekday
        if diff < 0 {
            diff = 7 + diff
        }
        
        dateComponents.setValue(nMonthDay - diff, for: .day)
        
        guard let firstDay = calendar.date(from: dateComponents) else { return }
        
        let oneDay = 24 * 60 * 60
        for i in 0...4 {
            let date = Date(timeInterval: TimeInterval(i * oneDay), since: firstDay)

            let dateComponents = calendar.dateComponents(component, from: date)
            
            let month = dateComponents.month ?? 1
            let monthDay = dateComponents.day ?? 1
            let weekDay = dateComponents.weekday ?? 2
            
            let timeModel = CourseTimeModel(week: weekDay, day: monthDay , month: month, isToday: (month == nMonth) && (nMonthDay == monthDay))
            
            self.timeModels.append(timeModel)
        }
    }
    
    //  截面初始化
    func applyInitialSnapshots() {

        // sections
        let sections = Section.allCases
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections(sections)
         
        for section in Section.allCases {
            
            var items : [AnyHashable] = []
            items.append(section.description)
            
            if section == .time {
                items.append(contentsOf: timeModels)

            } else if section == .rest {
                items.append("午休")
                
            } else {
                for course in courses {
                    items.append(course[section.offset ?? 0])
                }
            }
            snapshot.appendItems(items,toSection: section)
        }
 
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
