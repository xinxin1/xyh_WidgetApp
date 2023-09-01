//
//  MoreCommonProblemDetailViewController.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/10.
//

import UIKit

class MoreCommonProblemDetailViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var hotImageView: UIImageView!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    var item: InstructionItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    override func setupView() {
        super.setupView()
        self.addBackButton()
        self.title = NSLocalizedString("常见问题", comment: "")
        
        self.titleLabel.text = item?.title
        self.contentLabel.text = item?.content
        self.hotImageView.image = UIImage(named: item?.image ?? "")
    }
}
