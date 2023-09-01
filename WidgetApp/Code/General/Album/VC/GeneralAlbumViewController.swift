//
//  GeneralAlbumViewController.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/21.
//

import UIKit
import Photos
import SnapKit
import TZImagePickerController

class GeneralAlbumViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
 
    var selectImageBlock : ((PHAsset?)->())?

    
    var model : TZAlbumModel? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var didLoadAlbums : Bool = false
    
    var albums : [TZAlbumModel] = []
    
    private let manager = PHCachingImageManager()
    
    private lazy var options: PHFetchOptions = {
        $0.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: true)]
        $0.predicate = NSPredicate.init(format: "mediaType = 1")
        return $0
    } ( PHFetchOptions())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCameraRollAlbum()
    }
    
    override func setupView() {
        
        super.setupView()
        self.addBackButton()
        
        let width = (ScreenWidth - 15) / 4 - 0.001

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        layout.sectionInset = UIEdgeInsets.init(top: 8, left: 3, bottom: 8, right: 3)
        layout.itemSize = CGSize.init(width: width, height: width)
        
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor(hexString: "#F5F5F5")!
        collectionView.register(UINib.init(nibName: "GeneralPhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GeneralPhotoCollectionViewCell")
    }
    
    func loadCameraRollAlbum() {
        
        TZImagePickerConfig.sharedInstance().allowPickingImage = true
        TZImagePickerConfig.sharedInstance().allowPickingVideo = false
        TZImageManager.default().getCameraRollAlbum(withFetchAssets: true) { album in
            self.model = album
        }
    }
    
//    private func loadAlbum() {
//        didLoadAlbums = true
//
//        TZImageManager.default().getAllAlbums(withFetchAssets: true) { albums in
//            self.albums.append(contentsOf: albums ?? [])
//            self.tableView.reloadData()
//        }
//    }
    
 

}



extension GeneralAlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GeneralPhotoCollectionViewCell", for: indexPath) as! GeneralPhotoCollectionViewCell
        cell.assetModel = model?.models[indexPath.item] as? TZAssetModel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            
        let assetModel = model?.models[indexPath.item] as! TZAssetModel

        if self.selectImageBlock != nil {
            self.selectImageBlock!(assetModel.asset)
            self.dismiss(animated: true)
            
        }
    }
}
