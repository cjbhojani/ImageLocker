//
//  Utility.swift
//  alamofireCodble
//
//  Created by Darshan Gajera on 07/07/18.
//  Copyright © 2018 Darshan Gajera. All rights reserved.
//

//import MJSnackBar
import Foundation
import UIKit
import MBProgressHUD
import MaterialComponents.MaterialSnackbar
import Alamofire

enum snackBarType {
    case postive
    case nagative
}

@available(iOS 13.0, *)
class ErrorReporting {
    static func showMessage(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        let appTopView = UIApplication.shared.topViewController()
        appTopView?.present(alert, animated: true, completion: nil)
    }
}

class LoadingView : UIView {
    
    static func startLoading(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let view: UIView = (UIApplication.shared.keyWindow?.subviews.last)!
            MBProgressHUD.showAdded(to: view, animated: true)
        }
    }
    
   	static func stopLoading(){
        let view: UIView = (UIApplication.shared.keyWindow?.subviews.last)!
        MBProgressHUD.hide(for: view, animated: true)
        
    }
}

class SnackBar {
    static func show(strMessage: String, type: snackBarType) {
        let message = MDCSnackbarMessage()
        message.text = strMessage
        var color: UIColor = UIColor()
        if type == .postive {
            color = UIColor(red: 7.0/255.0, green: 135.0/255.0, blue: 234.0/255.0, alpha: 1)
        } else {
            color = UIColor(red: 234.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1)
        }
        
        MDCSnackbarManager.snackbarMessageViewBackgroundColor = color
        MDCSnackbarManager.show(message)
    }
}

extension NSDictionary {
    func dataReturn(isParseDirect: Bool?) -> Data? {
        do {
            if isParseDirect ?? false {
                let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                return data!
            } else {
                let jsonData = try JSONSerialization.data(withJSONObject: self.value(forKey: "data") ?? "" as Any as Any, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                return data!
            }
        } catch let err {
            print("Err", err)
            return nil
        }
    }
}


extension String {
    var isValidContact: Bool {
        let phoneNumberRegex = "^[6-9]\\d{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        let isValidPhone = phoneTest.evaluate(with: self)
        return isValidPhone
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        let passRegEx = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{7,}"
        let passTest = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        return passTest.evaluate(with: self)
    }
    
    func toDayMonth() -> String {
        let dateD: Date = Date(fromString: self, format: DateFormatType.isoDateTimeMilliSec)!
        return dateD.toString(format: DateFormatType.dateMonth)
    }
    
    func toDayMonthYearTime() -> String {
        let dateD: Date = Date(fromString: self, format: DateFormatType.isoDateTimeMilliSec)!
        return dateD.toString(format: DateFormatType.dateMonthYearTime)
    }
}

struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}
