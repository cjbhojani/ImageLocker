//
//  PhotoListVC.swift
//  image lockerDemo
//
//  Created by Darshan Gajera on 18/05/19.
//  Copyright © 2019 Darshan Gajera. All rights reserved.
//

import UIKit
import BSImagePicker
import BSGridCollectionViewLayout
import BSImageView
import Photos
import SKPhotoBrowser


class FolderCell: UICollectionViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var img: UIImageView!
}




class PhotoListVC: BaseVC, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var clnView: UICollectionView!
    var arrFiles: NSMutableArray = NSMutableArray()
    var arrSelectedAssets: NSMutableArray = NSMutableArray()
    @IBOutlet weak var btnAdd: UIButton!
    var folderName: String?
    var count: Int?
    let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnAction()
        
        count = arrFiles.count
        self.getFiles()
        self.setNavigationBar(title: NSString(string: folderName!), titleImage: nil, leftImage: UIImage(named: "icoBack"), rightImage: nil, leftTitle: nil, rightTitle: nil, isLeft: true, isRight: false, isLeftMenu: false, isRightMenu: false, bgColor: UIColor.AppColor(), textColor: UIColor.TextColor(), isStatusBarSame: true
            , leftClick: { (btnLeft) in
                self.navigationController?.popViewController(animated: true)
        }) { (btnRight) in
            
        }
    }
    
    func getFiles() {
        arrFiles = NSMutableArray(array: self.listFilesFromFolder(str: folderName!)!)
        if arrFiles.count > 0 {
            let string: String = arrFiles.object(at: 0) as! String
            if string.hasPrefix(".") {
                arrFiles.removeObject(at: 0)
            }
        }
        self.clnView.reloadData()
    }
    
    func collectionViewLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        clnView!.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var collectionViewSize = collectionView.frame.size
        collectionViewSize.width = (collectionViewSize.width/3.0)-10//Display Three elements in a row.
        collectionViewSize.height = collectionViewSize.width
        return collectionViewSize
    }

    func btnAction() {
        self.count = self.listFilesFromFolder(str: self.folderName!)?.count
        btnAdd.addAction {
            let vc = BSImagePickerViewController()
            self.bs_presentImagePickerController(vc, animated: true,
                                                 select: { (asset: PHAsset) -> Void in
                                                    
            }, deselect: { (asset: PHAsset) -> Void in
                
            }, cancel: { (assets: [PHAsset]) -> Void in
                // User cancelled. And this where the assets currently selected.
            }, finish: { (assets: [PHAsset]) -> Void in
                print(assets.count)
                for singleAssetes in assets {
                    
                    self.count = self.listFilesFromFolder(str: self.folderName!)?.count
                    self.delayWithSeconds(0.1, completion: {
                        let imgSingle = self.getUIImage(asset: singleAssetes)
                        self.count = self.count! + 1
                        let strfilename = String(format: "%@.png", singleAssetes.localIdentifier.components(separatedBy: "/").first!)
                        self.saveImageDocumentDirectory(img: imgSingle, strFileName: strfilename, strFolderName: self.folderName!)
                    })
                }
                self.delayWithSeconds(0.5, completion: {
                    self.getFiles()
                })
            }, completion: nil)
        }
    }
    func getUIImage(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        var thumbnail = UIImage()
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        manager.requestImageData(for: asset, options: options) { (data, str, _, info) in
            let img = UIImage(data: data!)
            thumbnail = img!
        }
        return thumbnail
    }
}

extension PhotoListVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FolderCell", for: indexPath) as! FolderCell
        cell.tag = indexPath.row
        let fileName = String(format: "%@/%@", self.folderName! ,(arrFiles.object(at: indexPath.row) as? String)!)
        cell.img.image = self.getImageFromName(str: fileName)
        cell.viewBackground.dropShadow(scale: false)
        let longPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.openActionSheetForDelete(_:)))
        longPress.minimumPressDuration = 1
        cell.addGestureRecognizer(longPress)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 1. create images from local files
        var images = [SKLocalPhoto]()
        for i in 0..<arrFiles.count {
            let strSingleFile = arrFiles.object(at: i) as! String
            let photoURL = String(format: "%@/%@/%@", self.docs,folderName!,strSingleFile)
            let photo = SKLocalPhoto.photoWithImageURL(photoURL)
            images.append(photo)
        }
      
        // 2. create PhotoBrowser Instance, and present.
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(indexPath.item)
        present(browser, animated: true, completion: {})
    }
    
    @objc func openActionSheetForDelete(_ gesture: UILongPressGestureRecognizer){
        self.presentAlertWithTitle(presentStyle: .actionSheet, title: "Options", message: "perform operations", options: "Delete","Cancel") { (index) in
            if index == 0 {
                self.sureForDelete(strfileName: self.arrFiles.object(at: (gesture.view?.tag)!) as! String)
            }
        }
    }
    
    func sureForDelete(strfileName: String) {
        self.presentAlertWithTitle(presentStyle: .alert, title: "Delete", message: "Are you sure to delete this picture?", options: "Yes","No") { (index) in
            if index == 0 {
                _ = self.deleteDirectory(str: String(format: "%@/%@", self.folderName!,strfileName))
                self.getFiles()
            } else {
                
            }
        }
    }
}
