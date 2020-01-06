//
//  SettingVC.swift
//  ImageLocker
//
//  Created by Chirag Bhojani on 04/01/20.
//  Copyright © 2020 Chirag Bhojani. All rights reserved.
//

import UIKit

class SettingVC: BaseVC {
    
    
    @IBOutlet weak var viewSetting : UIView!
    @IBOutlet weak var viewShareapp : UIView!
    @IBOutlet weak var viewRateapp : UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewSetting.dropShadow(scale: false)
        self.viewShareapp.dropShadow(scale: false)
        self.viewRateapp.dropShadow(scale: false)
        
        let leftImg = UIImage(named: "icoBack")
        self.setNavigationBar(title: GlobalConstants.APPNAME as NSString, titleImage: nil, leftImage: leftImg, rightImage: nil, leftTitle: nil, rightTitle: nil, isLeft: true, isRight: false, isLeftMenu: false, isRightMenu: false, bgColor: UIColor.AppColor(), textColor: UIColor.TextColor(), isStatusBarSame: true, leftClick: { (sender) in
            self.navigationController?.popViewController(animated: true)
        }) { (sender) in
            
        }
        
    }
    
    @IBAction func btnChangePasswordCLick(_ sender: Any){
        let changePin = Storyboard.main.storyboard().instantiateViewController(withIdentifier: Identifier.ChangePinVC.rawValue) as! ChangePinVC
        self.navigationController?.pushViewController(changePin, animated: true)
        
    }
    
    @IBAction func btnShareAppClick(_ sender: Any){
        self.shareApp()
    }
    
    @IBAction func btnRateAppClick(_ sender: Any){
        self.openAppPage()
    }
}
