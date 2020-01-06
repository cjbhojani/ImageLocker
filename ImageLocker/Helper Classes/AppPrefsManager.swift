//
//  AppPrefsManager.swift
//  PastZero
//
//  Created by Sunil Zalavadiya on 7/28/16.
//  Copyright © 2016 Sunil Zalavadiya. All rights reserved.
//

import UIKit
import CoreLocation
// swiftlint:disable all
class AppPrefsManager: NSObject {

    static let sharedInstance = AppPrefsManager()
    let TOKEN = "token"
    let EMAIL = "email"
    let LASTCLICKDATE = "lastClickDate"
    let USERBADGES = "USERBADGES"
    let ALLBADGES = "ALLBADGES"
    let USERDATA = "USERDATA"
    let APNSTOKEN = "APNSToken"
    let JWTTOKEN = "jwttoken"
    let SETCOUNT = "SETCOUNT"
    let USERID = "USERID"
    let CURRENTLAT = "CURRENTLAT"
    let CURRENTLONG = "CURRENTLONG"
    let USER =   "USER"
    let PIN = "PIN"

    func setDataToPreference(data: AnyObject, forKey key: String) {
        do {
            var archivedData = Data()
            if #available(iOS 11.0, *) {
                archivedData = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true)
            } else {
                archivedData = NSKeyedArchiver.archivedData(withRootObject: data)
            }
            UserDefaults.standard.set(archivedData, forKey: key)
            UserDefaults.standard.synchronize()
        }
        catch {
            print("Unexpected error: \(error).")
        }
    }
    
    func getDataFromPreference(key: String) -> AnyObject? {
        let archivedData = UserDefaults.standard.object(forKey: key)
        if(archivedData != nil) {
            do {
                var unArchivedData: Any?
                if #available(iOS 11.0, *) {
                    unArchivedData =  try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(archivedData as! Data) as AnyObject
                } else {
                    unArchivedData = NSKeyedUnarchiver.unarchiveObject(with: archivedData as! Data) as AnyObject
                }
                return unArchivedData as AnyObject
            } catch {
                print("Unexpected error: \(error).")
            }
        }
        return nil
    }
    
    func removeDataFromPreference(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func isKeyExistInPreference(key: String) -> Bool {
        if(UserDefaults.standard.object(forKey: key) == nil) {
            return false
        }
        return true
    }
    
    
    func setPin(obj: AnyObject) {
        setDataToPreference(data: obj as AnyObject, forKey: PIN)
    }
    
    func getPin() -> String? {
        let strPin = getDataFromPreference(key: PIN)
        return strPin as? String
    }
    
    
    func setCount(obj: AnyObject) {
        setDataToPreference(data: obj as AnyObject, forKey: SETCOUNT)
    }
    
    func getCount() -> Int? {
        let count = getDataFromPreference(key: SETCOUNT)
        return count as? Int
    }
    
    func setAPNsToken(obj: AnyObject) {
        setDataToPreference(data: obj as AnyObject, forKey: APNSTOKEN)
    }

    func getAPNsToken() -> String? {
        let strToken = getDataFromPreference(key: APNSTOKEN)
        return strToken as? String
    }
    
    // Last Redeem Date
    func setRedeemDate(obj: AnyObject?) {
        setDataToPreference(data: obj as AnyObject, forKey: LASTCLICKDATE)
    }
    
    func getRedeemDate() -> NSDate {
        let date = getDataFromPreference(key: LASTCLICKDATE) as! NSDate
        return date
        
    }
    
    func setUser(obj: AnyObject) {
        setDataToPreference(data: obj as AnyObject, forKey: USER)
    }
    
//    func getUser() -> User? {
//        do {
//            if self.isKeyExistInPreference(key: USER) {
//                let userData = getDataFromPreference(key: USER) as! NSDictionary
//                return try JSONDecoder().decode(User.self, from: (userData.dataReturn(isParseDirect: true))!)
//            }
//            return nil
//        }
//        catch let err {
//            print("Err", err)
//            return nil
//        }
//    }
}
