//
//  Appdelegate+.swift
//  alamofireCodble
//
//  Created by Darshan Gajera on 13/07/18.
//  Copyright © 2018 Darshan Gajera. All rights reserved.
//

import Foundation
import UIKit

import UserNotifications

// swiftlint:disable all
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("i am not available in simulator \(error)")
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        print("Handle push from foreground")
        completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Handle push from background or closed")
        completionHandler()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        if application.applicationState == .inactive || application.applicationState == .background {
            // Check notification content and decide the redirection
//            let navigationController = self.window?.rootViewController as? UINavigationController
//            let destinationController = Storyboard.Main.storyboard().instantiateViewController(withIdentifier: Identifier.Post.rawValue) as! PostVC
//            navigationController?.pushViewController(destinationController, animated: false)
        }
    }

    func application(application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        AppPrefsManager.sharedInstance.setAPNsToken(obj: deviceTokenString as AnyObject)
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
    
    public func topViewController(_ base: UIViewController? = nil) -> UIViewController? {
        let base = base ?? keyWindow?.rootViewController
        if let top = (base as? UINavigationController)?.topViewController {
            return topViewController(top)
        }
        if let selected = (base as? UITabBarController)?.selectedViewController {
            return topViewController(selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
    
    var statusBarBackgroundColor: UIColor? {
        get {
            return (UIApplication.shared.value(forKey: "statusBar") as? UIView)?.backgroundColor
        } set {
            (UIApplication.shared.value(forKey: "statusBar") as? UIView)?.backgroundColor = newValue
            }
        }
    
    
}
