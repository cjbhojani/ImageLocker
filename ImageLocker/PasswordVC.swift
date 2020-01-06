
//
//  PasswordVC.swift
//  ImageLocker
//
//  Created by Chirag Bhojani on 03/01/20.
//  Copyright © 2020 Chirag Bhojani. All rights reserved.
//

import UIKit
import SVPinView

class PasswordVC: BaseVC {
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var viewPassword: SVPinView!
    var strPin = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setvViewPassword()
        self.setNavigationBar(title: GlobalConstants.APPNAME as NSString, titleImage: nil, leftImage: nil, rightImage: nil, leftTitle: nil, rightTitle: nil, isLeft: false, isRight: false, isLeftMenu: false, isRightMenu: false, bgColor: UIColor.AppColor(), textColor: UIColor.TextColor(), isStatusBarSame: true, leftClick: {(sender) in
        }){(sender) in
            
        }
    }
    
    
    func setvViewPassword() {
        viewPassword.fieldBackgroundColor = UIColor.white
        viewPassword.style = .box
        viewPassword.interSpace = 18
        viewPassword.shouldSecureText = true
        viewPassword.borderLineColor = UIColor.hexStringToUIColor(hex: "ededed")
        viewPassword.fieldBackgroundColor = UIColor.hexStringToUIColor(hex: "ededed")
        viewPassword.activeBorderLineColor = UIColor.AppColor()
        viewPassword.borderLineThickness = 1
        viewPassword.activeBorderLineThickness = 3
        viewPassword.font = UIFont.systemFont(ofSize: 22)
        viewPassword.keyboardType = .phonePad
        viewPassword.placeholder = "----"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewPassword.didFinishCallback = { pin in
            self.strPin = pin
        }
    }
    
    @IBAction func btnPasswordClick(_ sender: Any){
        print("Password : ",strPin)
        
        if self.strPin == AppPrefsManager.sharedInstance.getPin(){
            let home = Storyboard.main.storyboard().instantiateViewController(withIdentifier: Identifier.HomeVC.rawValue) as! HomeVC
            self.navigationController?.pushViewController(home, animated: true)
        }
        else
        {
            SnackBar.show(strMessage: ErrorMesssages.invalidPassword, type: .nagative)
        }
        
        
        
    }
}
