//
//  CreateFolderVC.swift
//  ImageLocker
//
//  Created by Chirag Bhojani on 03/01/20.
//  Copyright © 2020 Chirag Bhojani. All rights reserved.
//

import UIKit

protocol CreateFolderVCDelegate: class {
    func closePopUp()
}

class CreateFolderVC: BaseVC {
    var arrExistName: NSMutableArray?
    weak var delegate: CreateFolderVCDelegate?
    
    @IBOutlet weak var txtFolderName: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnCanel: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func btnSubmitClick(_ sender: Any){
        if self.txtFolderName.text?.count != 0 {
            if (self.arrExistName?.contains(self.txtFolderName.text ?? ""))! {
                SnackBar.show(strMessage: "Folder already exist!", type: .nagative)
            } else {
                _ = URL.createFolder(folderName: self.txtFolderName.text!)
                self.delegate?.closePopUp()
                self.delayWithSeconds(0.1, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
            }
        } else {
            SnackBar.show(strMessage: "Please Enter Proper Folder Name", type: .nagative)
        }
    }
    
    @IBAction func btnCancelClick(_ sender: Any){
        self.delegate?.closePopUp()
        self.delayWithSeconds(0.1, completion: {
            self.dismiss(animated: true, completion: nil)
        })
    }
}
