//
//  ExploreMyWidgetTypeViewController.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/17.
//

import UIKit
import JXSegmentedView
  
 class ExploreMyWidgetTypeViewController: BaseViewController {
 
    @IBOutlet weak var topView: UIView!
    
    var titles : [String] = []
    var type: MyWidgetType = .homeScreen
    
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
        self.view.backgroundColor = UIColor.clear
        
        for aType in type.widgetTypes {
            titles.append(aType.description)
        }
        
        self.setupSegmentedView()
    }
    
    func setupSegmentedView() {

        segmentedDataSource.titles = titles
        segmentedDataSource.titleNormalColor = UIColor(hexString: "#333333")!
        segmentedDataSource.titleSelectedColor = UIColor(hexString: "#644BFF")!
        segmentedDataSource.titleNormalFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        segmentedDataSource.titleSelectedFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
        segmentedDataSource.itemSpacing = 15
 
        segmentedView.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        segmentedView.dataSource = segmentedDataSource
        topView.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 134, height: 30))
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

}

extension ExploreMyWidgetTypeViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}


extension ExploreMyWidgetTypeViewController: JXSegmentedListContainerViewDataSource {
    
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        
        let dVC = ExploreMyWidgetDetailViewController()
        dVC.widgetType = type.widgetTypes[index]
        
        return dVC
    }
}
