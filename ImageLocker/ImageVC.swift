//
//  ImageVC.swift
//  ImageLocker
//
//  Created by Chirag Bhojani on 03/01/20.
//  Copyright © 2020 Chirag Bhojani. All rights reserved.
//

import UIKit

class ImageVC: BaseVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftImg = UIImage(named: "icoBack")
        self.setNavigationBar(title: GlobalConstants.APPNAME as NSString, titleImage: nil, leftImage: leftImg, rightImage: nil, leftTitle: nil, rightTitle: nil, isLeft: true, isRight: false, isLeftMenu: false, isRightMenu: false, bgColor: UIColor.AppColor(), textColor: UIColor.TextColor(), isStatusBarSame: true, leftClick: { (sender) in
            
        }) { (sender) in
            
        }
    }
    
    
    
    
    
}
