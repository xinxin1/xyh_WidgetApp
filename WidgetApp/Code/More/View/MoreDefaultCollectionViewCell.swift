//
//  MoreDefaultCollectionViewCell.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/8.
//

import UIKit

class MoreDefaultCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "MoreDefaultReuseIdentifier"
    
    let leftImageView = UIImageView()

    let label = UILabel()
    
    let arrowImageView = UIImageView()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
        
}

extension MoreDefaultCollectionViewCell {
    func configure() {
        
        leftImageView.contentMode = .scaleAspectFit
        leftImageView.tintColor = UIColor.lightGray.withAlphaComponent(0.7)
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(leftImageView)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(label)

        let chevronImage = UIImage(named: "more_setting_arrow_icon")
        arrowImageView.image = chevronImage
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(arrowImageView)

        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = UIColor.clear

        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            
            leftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            leftImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            leftImageView.widthAnchor.constraint(equalToConstant: 22),
            leftImageView.heightAnchor.constraint(equalToConstant: 22),
            
            label.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 20),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),

            arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 24),
            arrowImageView.heightAnchor.constraint(equalToConstant: 24),
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
            ])
    }
}
