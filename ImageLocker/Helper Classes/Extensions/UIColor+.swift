//
//  UIColor+.swift
//  FullKit
//
//  Created by Darshan Gajera on 21/06/18.
//  Copyright © 2018 Darshan Gajera. All rights reserved.
//

// swiftlint:disable all
import Foundation
import UIKit

extension UIColor {
    class func AppGredient() -> [UIColor] {
        var colors = [UIColor]()
        colors.append(UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0))
        colors.append(UIColor(red: 212.0/255.0, green: 247.0/255.0, blue: 251.0/255.0, alpha: 1.0))
        colors.append(UIColor(red: 86.0/255.0, green: 204.0/255.0, blue: 242.0/255.0, alpha: 1.0))
        colors.append(UIColor(red: 47.0/255.0, green: 128.0/255.0, blue: 237.0/255.0, alpha: 1.0))
        colors.append(UIColor(red: 7.0/255.0, green: 135.0/255.0, blue: 234.0/255.0, alpha: 1.0))
        return colors
    }
    
    class func bgColor() -> UIColor {
        return self.hexStringToUIColor(hex: "533b51")
    }
    
    class func AppColor() -> UIColor {
        return self.hexStringToUIColor(hex: "3d72de")
    }
    
    class func appBackgroundColor() -> UIColor {
        return self.hexStringToUIColor(hex: "e87e5c")
    }

    
    
    class func TextColor() -> UIColor {
        return self.hexStringToUIColor(hex: "ffffff")
    }
    
    class func greenBackgroundColor() -> UIColor {
        return UIColor(red: 223.0/255.0, green: 240.0/255.0, blue: 216.0/255.0, alpha: 1)
        

    }
    
    class func greenTextColor() -> UIColor {
        return UIColor(red: 60.0/255.0, green: 118.0/255.0, blue: 60.0/255.0, alpha: 1)
    }
    
    
    class func AppSecondColor() -> UIColor {
        return UIColor(red: 248/255.0, green: 150/255.0, blue: 37/255.0, alpha: 1.0)
    }
    
    class func AppThirdColor() -> UIColor {
        return UIColor(red: 152/255.0, green: 1/255.0, blue: 101/255.0, alpha: 1.0)
    }
    
    class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
