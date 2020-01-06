//
//  Constant.swift
//  GreekToMe
//
//  Created by Darshan Gajera on 5/14/18.
//  Copyright © 2018 TechARK. All rights reserved.
//
// swiftlint:disable all
import UIKit
struct GlobalConstants {
    static let APPNAME = "Image Locker"
    static let APPURL = ""
    
}

enum Storyboard: String {
    case main    = "Main"
    case home    = "Home"
    case login    = "Login"
    case tabBar    = "HomeTabBar"
    func storyboard() -> UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}

enum Color: String {
    case SliderSelction  = "0080ff"
    case SliderDefault  = "0048b1"
    case SliderTextSelection  = "ffffff"
    case SliderTextDefault  = "7887b5"
    case AppColorCode  = "6E0A5E"
    
    func color() -> UIColor {
        return UIColor.hexStringToUIColor(hex: self.rawValue)
    }
}

enum Identifier: String {
//    Main Storyboard
    case ViewController = "ViewController"
    case NoConnection = "NoConnection"
    case HomeVC = "HomeVC"
    case PasswordVC = "PasswordVC"
    case CreateFolderVC = "CreateFolderVC"
    case PhotoListVC = "PhotoListVC"
    case SettingVC = "SettingVC"
    case ChangePinVC = "ChangePinVC"
    
//    Collectionview cell
    case cellFolder = "cellFolder"
}

struct ErrorMesssages {
    static let emptyPin = "Please Enter Your Pin"
    static let emptyConfirmPin = "Please Enter Pin Again"
    static let notMatchPin = "Your Both Pin Are Not Matched"
    static let pinGenerated = "Successfully pin generated."
    static let invalidPassword = "Enter Valid Pin"
}


