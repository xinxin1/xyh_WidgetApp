//
//  ExploreViewController.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/8.
//

import UIKit
import JXSegmentedView
import JXPagingView
import IBAnimatable

class ExploreViewController: BaseViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var mineImageView: AnimatableImageView!
    
    var pagingView: JXPagingView!
    var headerView: ExploreHeaderView!
    var headerContainerView: UIView!
    var segmentedViewDataSource: JXSegmentedTitleOrImageDataSource!
    var segmentedView: JXSegmentedView!
    
    let titles = ["推荐", "创意", "X面板","❤️七夕","照片","时间"]
    var HeightForTableViewHeader: Int = 280
    var HeightForHeaderInSection: Int = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func setupView() {
        super.setupView()
        
        self.sh_prefersNavigationBarHidden = true
        self.addBackgroundImage()
        self.setupHeaderView()
        self.setupSegmentView()
    }
    
    func setupHeaderView() {
        
        headerView = Bundle.main.loadNibNamed("ExploreHeaderView", owner: nil)?.first as? ExploreHeaderView ?? ExploreHeaderView(x: 0, y: 0, w: ScreenWidth, h: CGFloat(HeightForTableViewHeader))
        headerView.bannerSelectedBlock = { index, activity in
            
        }
        headerView.introductionSelectedBlock = { tag in
            self.introductionAction(tag: tag)
        }
        
        headerContainerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: CGFloat(HeightForTableViewHeader)))

        headerContainerView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.edges.equalTo(headerContainerView)
        }
    }
    
    func setupSegmentView() {
        
        //配置数据源
        let dataSource = JXSegmentedTitleOrImageDataSource()
        dataSource.isTitleColorGradientEnabled = true
        dataSource.titleNormalColor = UIColor(hexString: "#A9ABB8")!
        dataSource.titleSelectedColor = UIColor(hexString: "#333333")!
        dataSource.titleSelectedFont = UIFont.YouSheBiaoTiHei(with: 24)
        dataSource.titleNormalFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        dataSource.isTitleColorGradientEnabled = true
        dataSource.isTitleZoomEnabled = false
        dataSource.itemSpacing = 25
        dataSource.titles = titles
//        dataSource.selectedImageInfos = ["", nil, "dog", nil, "sheep", "chicken", "horse", nil, nil, "dragon"]
        dataSource.loadImageClosure = {(imageView, normalImageInfo) in
            //图片加载方法
            imageView.image = UIImage(named: normalImageInfo)
        }
        dataSource.widthForTitleClosure = {title in
            let rect = title.toNSString.boundingRect(with: CGSize(width: 200, height: 50), options: .usesLineFragmentOrigin,attributes:[NSAttributedString.Key.font:UIFont.YouSheBiaoTiHei(with: 24)] ,  context: nil)
            return rect.size.width
        }
        segmentedViewDataSource = dataSource
 

        segmentedView = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: CGFloat(HeightForHeaderInSection)))
        segmentedView.backgroundColor = UIColor(hexString: "#FBFCFF")
        segmentedView.dataSource = segmentedViewDataSource
        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false

        let lineView = JXSegmentedIndicatorLineView()
        lineView.indicatorColor = UIColor(hexString: "#644BFF")!
        lineView.indicatorHeight =  8.5
        lineView.verticalOffset = 14
        lineView.indicatorCornerRadius = 3
        segmentedView.indicators = [lineView]

        pagingView = JXPagingView(delegate: self)
        pagingView.mainTableView.backgroundColor = UIColor.clear
        pagingView.listContainerView.backgroundColor = UIColor(hexString: "#FBFCFF")
        pagingView.listContainerView.listCellBackgroundColor = UIColor(hexString: "#FBFCFF")!
        self.view.addSubview(pagingView)
        
        segmentedView.listContainer =  pagingView.listContainerView 
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pagingView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(topView.snp.bottom).offset(22)
        }
    }
    
    //MARK: - Action
    @IBAction func mineAction(_ sender: Any) {
        
//        let mineVC = ExploreMyWidgetSummaryViewController()
//        self.navigationController?.pushViewController(mineVC, animated: true)
        
        
//        let subscribeVc = SubscribeViewController()
//        subscribeVc.modalPresentationStyle = .fullScreen
//
//        self.present(subscribeVc, animated: true)
        
        
//        self.mineImageView.animate(.swing(repeatCount: 1))
        
        let editVC = GeneralEditWidgetScheduleViewController()
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    func introductionAction(tag: Int) {
        switch tag {
        case 1:
            break

        case 2:
            break
            
        case 3:
            self.navigationController?.pushViewController(ExploreTutorialViewController(), animated: true)
            break
            
        case 4:
            break
            
        default:
            break
        }
    }
}


extension ExploreViewController: JXPagingViewDelegate {

    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return HeightForTableViewHeader
    }

    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return headerContainerView
    }

    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return HeightForHeaderInSection
    }

    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return segmentedView
    }

    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return titles.count
    }

    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        let list =  ExploreCategoryViewController()
        return list
    }

    func mainTableViewDidScroll(_ scrollView: UIScrollView) {

    }
}

extension JXPagingListContainerView: JXSegmentedViewListContainer {}
