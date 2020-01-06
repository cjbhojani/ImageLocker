//
//  AppDelegate.swift
//  ImageLocker
//
//  Created by Chirag Bhojani on 02/01/20.
//  Copyright © 2020 Chirag Bhojani. All rights reserved.


import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var navigationController = UINavigationController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        if AppPrefsManager.sharedInstance.getPin() != nil{
            let password = Storyboard.main.storyboard().instantiateViewController(withIdentifier: Identifier.PasswordVC.rawValue) as! PasswordVC
            navigationController.initRootViewController(vc: password)
        }
        else
        {
            let viewVC = Storyboard.main.storyboard().instantiateViewController(withIdentifier: Identifier.ViewController.rawValue) as! ViewController
            navigationController.initRootViewController(vc: viewVC)
        }
        window?.rootViewController = navigationController
        return true
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if AppPrefsManager.sharedInstance.getPin() != nil{
            let password = Storyboard.main.storyboard().instantiateViewController(withIdentifier: Identifier.PasswordVC.rawValue) as! PasswordVC
            navigationController.initRootViewController(vc: password)
        }
        else
        {
            let viewVC = Storyboard.main.storyboard().instantiateViewController(withIdentifier: Identifier.ViewController.rawValue) as! ViewController
            navigationController.initRootViewController(vc: viewVC)
        }
    }
    
}

