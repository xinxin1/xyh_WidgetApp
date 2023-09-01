//
//  MoreCommonProblemCollectionViewCell.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/10.
//

import UIKit

class MoreCommonProblemCollectionViewCell: UICollectionViewCell {
    
    enum CommonProblemCellType {
        case defaultCell, detailCell
    }
    
    var cellType: CommonProblemCellType = .defaultCell {
        didSet {
            configureLayout()
        }
    }
    
    let leftImageView = UIImageView()

    let label = UILabel()
    
    let arrowImageView = UIImageView()
    
    var item: InstructionItem? {
        didSet {
            leftImageView.image = UIImage(named: item?.image ?? "")
            label.text = item?.title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        leftImageView.contentMode = .scaleAspectFit
        leftImageView.tintColor = UIColor.lightGray.withAlphaComponent(0.7)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.systemFont(ofSize: 15)
        
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = UIColor.clear
        
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(leftImageView)
        contentView.addSubview(label)
        contentView.addSubview(arrowImageView)
    }
    
    func configureLayout() {
        
        let arrowImage = cellType == .defaultCell ? "more_setting_arrow_icon" : "more_problem_arrow_icon"
        arrowImageView.image = UIImage(named: arrowImage)
        
        let layoutModel : CommonProblemCellLayoutModel = (cellType == .defaultCell) ? .default : .detailLayout
        
        if layoutModel.isImageOnTheMostLeft {
            leftImageView.snp.remakeConstraints { make in
                make.size.equalTo(layoutModel.leftImageSize)
                make.centerY.equalToSuperview()
                make.left.equalTo(layoutModel.leftMargin)
            }
            
            label.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalTo(leftImageView.snp.right).offset(layoutModel.marginBetweenLabelAndImageView)
            }
        } else {
            label.snp.remakeConstraints { make in
                make.centerY.equalTo(contentView)
                make.left.equalTo(layoutModel.leftMargin)
            }
            
            leftImageView.snp.remakeConstraints { make in
                make.size.equalTo(layoutModel.leftImageSize)
                make.centerY.equalToSuperview()
                make.left.equalTo(label.snp.right).offset(layoutModel.marginBetweenLabelAndImageView)
            }
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.size.equalTo(layoutModel.rightImageSize)
            make.centerY.equalToSuperview()
            make.right.equalTo(-layoutModel.rightMargin)
        }
    }
    
}


struct CommonProblemCellLayoutModel {
    
    var leftMargin: CGFloat = 20
    var rightMargin: CGFloat = 20
    var marginBetweenLabelAndImageView: CGFloat = 15
    var isImageOnTheMostLeft: Bool =  true
    var leftImageSize: CGSize = CGSize(width: 45, height: 45)
    var rightImageSize: CGSize = CGSize(width: 24, height: 24)
    
    public static let `default` = CommonProblemCellLayoutModel()
    
    public static let detailLayout = CommonProblemCellLayoutModel(leftMargin: 15, rightMargin: 15, marginBetweenLabelAndImageView: 6, isImageOnTheMostLeft: false, leftImageSize: CGSize(width: 18, height: 18))
}
