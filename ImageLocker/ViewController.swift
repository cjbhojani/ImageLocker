//
//  ViewController.swift
//  ImageLocker
//
//  Created by Chirag Bhojani on 02/01/20.
//  Copyright © 2020 Chirag Bhojani. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


struct ViewControllerViewModel {
    var newPin = Variable<String>("")
    var confirmNewPin = Variable<String>("")
}

extension ViewControllerViewModel{
    func fieldValidation() -> Bool {
        if newPin.value.isEmpty{
            SnackBar.show(strMessage: ErrorMesssages.emptyPin, type: .nagative)
            return false
        }
        else
        {
            if confirmNewPin.value.isEmpty{
                SnackBar.show(strMessage: ErrorMesssages.emptyPin, type: .nagative)
                return false
            }
            else{
                if newPin.value != confirmNewPin.value{
                    SnackBar.show(strMessage: ErrorMesssages.notMatchPin, type: .nagative)
                    return false
                }
                else
                {
                    SnackBar.show(strMessage: ErrorMesssages.pinGenerated, type: .postive)
                    return true
                }
            }
        }
    }
}

class ViewController: BaseVC {
    
    @IBOutlet weak var txtPin: UITextField!
    @IBOutlet weak var txtConfirmPin: UITextField!
    @IBOutlet weak var btnSetPin: UIButton!
    
    var viewModel : ViewControllerViewModel = ViewControllerViewModel()
    var disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.txtPin.rx.text
        .orEmpty
        .bind(to: viewModel.newPin)
        .disposed(by: disposeBag)
        
        self.txtConfirmPin.rx.text
        .orEmpty
        .bind(to: viewModel.confirmNewPin)
        .disposed(by: disposeBag)
        
        self.setNavigationBar(title: GlobalConstants.APPNAME as NSString, titleImage: nil, leftImage: nil, rightImage: nil, leftTitle: nil, rightTitle: nil, isLeft: false, isRight: false, isLeftMenu: false, isRightMenu: false, bgColor: UIColor.AppColor(), textColor: UIColor.TextColor(), isStatusBarSame: true, leftClick: {(sender) in
        }){(sender) in
            
        }
    }
    
    
    @IBAction func btnSetPinClick(_ sender: Any){
        if viewModel.fieldValidation(){
            AppPrefsManager.sharedInstance.setPin(obj: txtPin.text as AnyObject)
            let homeVC = Storyboard.main.storyboard().instantiateViewController(withIdentifier: Identifier.HomeVC.rawValue) as! HomeVC
            self.navigationController?.pushViewController(homeVC, animated: true)
        }
    }
}


// Textfield delegate method
extension ViewController{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtPin{
            txtPin.layer.borderColor = UIColor.hexStringToUIColor(hex: "ededed").cgColor
        }
        else
        {
            txtConfirmPin.layer.borderColor = UIColor.hexStringToUIColor(hex: "ededed").cgColor
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtPin{
            txtPin.layer.borderColor = UIColor.AppColor().cgColor
        }
        else
        {
            txtConfirmPin.layer.borderColor = UIColor.AppColor().cgColor
        }
    }
}

