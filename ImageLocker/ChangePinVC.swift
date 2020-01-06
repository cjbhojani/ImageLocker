//
//  ChangePinVC.swift
//  ImageLocker
//
//  Created by Chirag Bhojani on 04/01/20.
//  Copyright © 2020 Chirag Bhojani. All rights reserved.
//

import UIKit

class ChangePinVC: BaseVC {
    
    @IBOutlet weak var txtOldPassword: UITextField!
    @IBOutlet weak var txtNEwPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        let leftImg = UIImage(named: "icoBack")
        self.setNavigationBar(title: "Change Password", titleImage: nil, leftImage: leftImg, rightImage: nil, leftTitle: nil, rightTitle: nil, isLeft: true, isRight: false, isLeftMenu: false, isRightMenu: false, bgColor: UIColor.AppColor(), textColor: UIColor.TextColor(), isStatusBarSame: true, leftClick: { (sender) in
            self.navigationController?.popViewController(animated: true)
        }) { (sender) in
            
        }
    }
    
    @IBAction func btnChangePasswordClick(sender : Any) {
        if self.fieldValidation(){
            let password = Storyboard.main.storyboard().instantiateViewController(withIdentifier: Identifier.PasswordVC.rawValue) as! PasswordVC
            self.navigationController?.pushViewController(password, animated: true)
            
        }
    }
    
    
    func fieldValidation() -> Bool {
        if AppPrefsManager.sharedInstance.getPin() != txtOldPassword.text{
            SnackBar.show(strMessage: "Old Password did not matched", type: .nagative)
            return false
        }
        else
        {
            if txtNEwPassword.text != txtConfirmPassword.text{
                SnackBar.show(strMessage: "New password did not matched", type: .nagative)
                return false
            }
            else
            {
                return true
            }
        }
    }
}

extension ChangePinVC {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtOldPassword{
            txtOldPassword.layer.borderColor = UIColor.hexStringToUIColor(hex: "E0E0E0").cgColor
        }
        else  if textField == txtNEwPassword
        {
            txtNEwPassword.layer.borderColor = UIColor.hexStringToUIColor(hex: "E0E0E0").cgColor
        }
        else
        {
            txtConfirmPassword.layer.borderColor = UIColor.hexStringToUIColor(hex: "E0E0E0").cgColor
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtOldPassword{
            txtOldPassword.layer.borderColor = UIColor.AppColor().cgColor
        }
        else  if textField == txtNEwPassword
        {
            txtNEwPassword.layer.borderColor = UIColor.AppColor().cgColor
        }
        else
        {
            txtConfirmPassword.layer.borderColor = UIColor.AppColor().cgColor
        }
    }
}


