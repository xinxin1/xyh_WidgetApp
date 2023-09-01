//
//  MoreComplaintViewController.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/10.
//

import UIKit
import RxCocoa

class MoreComplaintViewController: BaseViewController {
    
    @IBOutlet weak var bugButton: UIButton!
    
    @IBOutlet weak var feedbackButton: UIButton!

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var placeholderLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var submitButton: UIButton!
    
    var currentTypeButton: UIButton?
    
    var images: [UIImage] = [UIImage(named: "more_question_add_icon")!] {
        didSet {
            self.collectionView.reloadData()
            self.relayoutCollection()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentTypeButton = bugButton
    }

    override func setupView() {
        super.setupView()
        
        self.title = NSLocalizedString("我要吐槽", comment: "")
        self.addBackButton()
        
        configCorner(with: bugButton)
        configCorner(with: feedbackButton)
        configCorner(with: textView)
        configCorner(with: collectionView)
        configCorner(with: submitButton, cornerRadius: 25)
        
        bugButton.setBackgroundColor(UIColor.white, forState: .normal)
        bugButton.setBackgroundColor(UIColor.init(named: "#644BFF")!, forState: .selected)
        
        feedbackButton.setBackgroundColor(UIColor.white, forState: .normal)
        feedbackButton.setBackgroundColor(UIColor.init(named: "#644BFF")!, forState: .selected)
        
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15)
        textView.delegate = self
        textView.rx.text.subscribe { res in
            let text = res.event.element!!
            self.placeholderLabel.isHidden = text.count != 0
            self.submitButton.isEnabled = text.count > 0

        }.disposed(by: disBag)
        
        let width = (ScreenWidth - 100) / 5 + 4.0
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 6, left: 10, bottom: 10, right: 6)
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumInteritemSpacing = 6
        layout.minimumLineSpacing = 6
        
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.register(UINib(nibName: "MoreComplaintPhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: MoreComplaintPhotoCollectionViewCell.className)
        
        relayoutCollection()
    }
    
    func configCorner(with view: UIView, cornerRadius: CGFloat = 12) {
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
    }
    
    func relayoutCollection() {
        let width = (ScreenWidth - 100) / 5 + 4.0
        let itemsCount = self.images.count
        let cloumsCount = itemsCount % 5
        let rowsCount = itemsCount / 5
        let collectionWidth = CGFloat(itemsCount) * (width + 6) + 10 + 6
        
        self.collectionViewWidth.constant = collectionWidth
        self.collectionViewHeight.constant = collectionWidth
        self.collectionView.setNeedsLayout()
        
        UIView.animate(withDuration: 0.2) {
            self.collectionView.layoutIfNeeded()
        }
    }
    
// MARK: - Action
    
    @IBAction func typeAction(_ sender: UIButton) {
        sender.isSelected = true
        currentTypeButton?.isSelected = false
        currentTypeButton = sender
    }
    
    
    @IBAction func submitAction(_ sender: Any) {
        self.textView.resignFirstResponder()
    }
    
}


extension MoreComplaintViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let selectRange = textView.markedTextRange
        
        let pos = textView.position(from: textView.beginningOfDocument, offset: 0)
        
        if selectRange != nil && pos != nil{
            return
        }
        
        if textView.text.count >= 300{
            textView.text = String(textView.text.prefix(300))
        }
    }
}


extension MoreComplaintViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoreComplaintPhotoCollectionViewCell.className, for: indexPath) as! MoreComplaintPhotoCollectionViewCell
        
        cell.deleteBlock = {
            self.images.remove(at: indexPath.item)
        }
        
        if indexPath.item == self.images.count - 1 {
            cell.image = self.images.last
//            cell.deleteButton.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == self.images.count - 1 {
            // 去相册
            
            self.pushVC(GeneralAlbumViewController())
        }
    }
}
