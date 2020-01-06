//
//  HomeVC.swift
//  ImageLocker
//
//  Created by Chirag Bhojani on 03/01/20.
//  Copyright © 2020 Chirag Bhojani. All rights reserved.
//

import UIKit
import EMAlertController

class cellFolder: UICollectionViewCell{
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewBackground: UIView!
}

class HomeVC: BaseVC, CreateFolderVCDelegate {
    func closePopUp() {
        self.getFolders()
    }
    
    @IBOutlet weak var viewCreateFolder: UIView!
    @IBOutlet weak var btnCreateFolder: UIButton!
    @IBOutlet weak var clvView: UICollectionView!
    var arrFolders = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewCreateFolder.dropShadow(scale: false)
        let rightImg = UIImage(named: "icoSetting")
        self.setNavigationBar(title: GlobalConstants.APPNAME as NSString, titleImage: nil, leftImage: nil, rightImage: rightImg, leftTitle: nil, rightTitle: nil, isLeft: false, isRight: true, isLeftMenu: false, isRightMenu: false, bgColor: UIColor.AppColor(), textColor: UIColor.TextColor(), isStatusBarSame: true, leftClick: { (sender) in
            
        }){(sender)in
            let setting = Storyboard.main.storyboard().instantiateViewController(withIdentifier: Identifier.SettingVC.rawValue) as! SettingVC
            self.navigationController?.pushViewController(setting, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.getFolders()
    }
    
    func getFolders() {
        if let folderArray = self.listFilesFromDocumentsFolder(){
            if folderArray.count > 0 {
                arrFolders = NSMutableArray(array: folderArray)
                let string: String = arrFolders.object(at: 0) as! String
                if string.hasPrefix(".") {
                    arrFolders.removeObject(at: 0)
                }
            } else {
                arrFolders = NSMutableArray()
            }
        }
        else
        {
            print("Floder Not Found")
        }
//        self.clvView.reloadEmptyDataSet()
        self.clvView.reloadData()
    }
    
    @IBAction func btnCreateFolderClick(_ sender: Any){
            let filter = Storyboard.main.storyboard().instantiateViewController(withIdentifier: Identifier.CreateFolderVC.rawValue) as! CreateFolderVC
            filter.delegate = self
            filter.arrExistName = self.arrFolders
            let navigationBar = UINavigationController(rootViewController: filter)
            navigationBar.modalPresentationStyle = .overFullScreen
            self.present(navigationBar, animated: true, completion: {
            })
    }
}



extension HomeVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFolders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.cellFolder.rawValue, for: indexPath) as! cellFolder
        cell.lblTitle.text = arrFolders.object(at: indexPath.row) as? String
        cell.tag = indexPath.row
        let longPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.openActionSheetForDelete(_:)))
        longPress.minimumPressDuration = 1
        cell.addGestureRecognizer(longPress)
        cell.viewBackground.dropShadow(scale: false)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.size.width / 2) - 18, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let photo =  Storyboard.main.storyboard().instantiateViewController(withIdentifier: Identifier.PhotoListVC.rawValue) as! PhotoListVC
        photo.folderName = arrFolders.object(at: indexPath.row) as? String
        self.navigationController?.pushViewController(photo, animated: true)
    }
    
    @objc func openActionSheetForDelete(_ gesture: UILongPressGestureRecognizer){
        let singlefolderName = self.arrFolders.object(at: (gesture.view?.tag)!) as! String
        self.presentAlertWithTitle(presentStyle: .actionSheet, title: singlefolderName, message:"Are you sure you want to delete this folder?", options: "Delete","Cancel") { (index) in
            if index == 0 {
                self.sureForDelete(strFolderName: singlefolderName)
            }
        }
    }
    
    func sureForDelete(strFolderName: String) {
        self.presentAlertWithTitle(presentStyle: .alert, title: "Delete", message: "Are you sure to delete folder?", options: "Yes","No") { (index) in
            if index == 0 {
               _ = self.deleteDirectory(str: strFolderName)
               self.getFolders()
            } else {
                
            }
        }
    }
}
