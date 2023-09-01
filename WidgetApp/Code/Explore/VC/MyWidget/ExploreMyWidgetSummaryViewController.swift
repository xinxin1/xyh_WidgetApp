//
//  ExploreMyWidgetSummaryViewController.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/17.
//

import UIKit
import JXSegmentedView
 
enum MyWidgetType: Int, CaseIterable,CustomStringConvertible {
case homeScreen, lockScreen

    var description: String {
        switch self {
        case .homeScreen:
            return "主屏幕"
        case .lockScreen:
            return "锁屏"
        }
    }
    
    var widgetTypes:[GeneralWidgetType] {
        switch self {
        case .homeScreen:
            return [ .small, .medium, .large]
            
        case .lockScreen:
            return [.circular, .rectangular, .inline]
        }
    }
}

class ExploreMyWidgetSummaryViewController: BaseViewController {
 
    @IBOutlet weak var topView: UIView!
    
    let segmentedDataSource = JXSegmentedTitleDataSource()
    let segmentedView = JXSegmentedView()
    
    lazy var listContainerView: JXSegmentedListContainerView! = {
        
        let containerView = JXSegmentedListContainerView(dataSource: self)
        containerView.listCellBackgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.clear
        
        return containerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupView() {
        self.sh_prefersNavigationBarHidden = true
        
        self.addBackgroundImage()
        self.setupSegmentedView()
    }
    
    func setupSegmentedView() {
        
        let totalItemWidth: CGFloat = 150
        let titles: [String] = [MyWidgetType.homeScreen.description, MyWidgetType.lockScreen.description ]
        
        segmentedDataSource.itemWidth = totalItemWidth/CGFloat(titles.count)
        segmentedDataSource.titles = titles
        segmentedDataSource.titleNormalColor = UIColor(hexString: "#333333")!
        segmentedDataSource.titleSelectedColor = UIColor(hexString: "#333333")!
        segmentedDataSource.titleNormalFont = UIFont.systemFont(ofSize: 16, weight: .regular)
        segmentedDataSource.titleSelectedFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
        segmentedDataSource.itemSpacing = 0

        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorHeight = 4
        indicator.indicatorWidth = 20
        indicator.indicatorWidthIncrement = 0
        indicator.indicatorColor = UIColor(hexString: "#644BFF")!
        
        segmentedView.frame = CGRect(x: 0, y: 0, width: totalItemWidth, height: 30)
        segmentedView.dataSource = segmentedDataSource
        segmentedView.indicators = [indicator]
        topView.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: totalItemWidth, height: 30))
        }

        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        listContainerView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(topView.snp.bottom).offset(17)
        }
    }
    
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tutorialAction(_ sender: Any) {
    }
}

extension ExploreMyWidgetSummaryViewController: JXSegmentedListContainerViewDataSource {
    
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        
        let tVC = ExploreMyWidgetTypeViewController()
        tVC.type = MyWidgetType(rawValue: index) ?? .homeScreen
        
        return tVC
    }
}
