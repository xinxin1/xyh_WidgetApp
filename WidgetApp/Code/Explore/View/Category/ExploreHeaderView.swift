//
//  ExploreHeaderView.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/11.
//

import UIKit
import JXBanner
import JXPageControl

class ExploreHeaderView: UIView {
        
    @IBOutlet weak var bannerContentView: UIView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    var bannerSelectedBlock: ((Int,ActivityInfoModel?)->())?
    var introductionSelectedBlock: ((Int)->())?

    var activities : [ActivityInfoModel] = [] {
        didSet {
            self.bannerView.reloadView()
        }
    }
    
    lazy var bannerView : JXBanner = {
        let banner = JXBanner()
        banner.delegate = self
        banner.dataSource = self
        return banner
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        activities = [ActivityInfoModel(actId: "", name: "", url: "", themeUrl: "", action: ""),]
        
        bannerView.bounds = CGRect(origin: CGPoint.zero, size: CGSize.init(width: 290, height: 165))
        bannerContentView.addSubview(bannerView)
        bannerView.snp.makeConstraints { make in
            make.edges.equalTo(bannerContentView)
        }
    }
    
    @IBAction func introductionAction(_ sender: UIButton) {
        dPrint("教程点击")
        introductionSelectedBlock?(sender.tag)
    }
}


extension ExploreHeaderView : JXBannerDataSource, JXBannerDelegate {

    func jxBanner(_ banner: JXBannerType, params: JXBannerParams) -> JXBannerParams {
        return params.isShowPageControl(false).timeInterval(2).cycleWay(.forward).isAutoPlay(true)
    }
    
    func jxBanner(numberOfItems banner: JXBannerType) -> Int {
        
        if activities.count <= 0 {
            return 3
        } else {
            return activities.count
        }
    }
    
    func jxBanner(_ banner: JXBannerType) -> (JXBannerCellRegister) {
        
        return JXBannerCellRegister.init(type: ExploreHeaderBannerCell.self, reuseIdentifier: "ExploreHeaderBannerCell", nib: UINib.init(nibName: "ExploreHeaderBannerCell", bundle: nil))
    }
    
    
    func jxBanner(_ banner: JXBannerType, cellForItemAt index: Int, cell: UICollectionViewCell) -> UICollectionViewCell {
        
        let tempCell: ExploreHeaderBannerCell = cell as! ExploreHeaderBannerCell
        tempCell.placeholderImage = UIImage.init(named:"explore_top_banner_placeholder")
        
        if index <= activities.count - 1 {
            tempCell.activity = self.activities[index]
        }

        return tempCell
    }

    
    func jxBanner(_ banner: JXBannerType, didSelectItemAt index: Int) {
        dPrint("banner点击")
        if index <= activities.count - 1 {
            self.bannerSelectedBlock!(index,self.activities[index])
            
        } else {
            self.bannerSelectedBlock!(index,nil)
        }
    }
    
    func jxBanner(_ banner: JXBannerType,layoutParams: JXBannerLayoutParams) -> JXBannerLayoutParams {
        
        return layoutParams.layoutType(JXBannerTransformLinear()).itemSize(CGSize(width: 290, height: 165)).itemSpacing(15).rateOfChange(0).minimumScale(0).rateHorisonMargin(0).minimumAlpha(1)
    }
    
}
