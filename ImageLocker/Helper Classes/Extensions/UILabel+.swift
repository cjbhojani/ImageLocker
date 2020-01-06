//
//  UILabel+.swift
//  FullKit
//
//  Created by Darshan Gajera on 21/06/18.
//  Copyright © 2018 Darshan Gajera. All rights reserved.
//
//swiftlint:disable all

import UIKit

extension UILabel {
    @IBInspectable
    var setScalable: Bool {
        set{
            var fontValue = self.font.pointSize
            if Display.typeIsLike == .iphone5 {
                
            } else if Display.typeIsLike == .iphone6 || Display.typeIsLike == .iphoneX {
                fontValue = fontValue + 1
            } else if Display.typeIsLike == .iphone6plus {
                fontValue = fontValue + 2
            }
            self.font =  UIFont(name: (self.font.fontName), size: CGFloat(fontValue))!
        }
        get{
            return true
        }
    }
    
    func setSizeFont (font: String, sizeFont: Double) {
        self.sizeToFit()
        var fontValue = sizeFont
        if UIDevice.isDevice(ofType: .iPhoneSE) || UIDevice.isDevice(ofType: .iPhone5) || UIDevice.isDevice(ofType: .iPhone5C) {
            fontValue = fontValue - 2
        } else if UIDevice.isDevice(ofType: .iPhone6) || UIDevice.isDevice(ofType: .iPhone6S){
            fontValue = fontValue - 1
        } else if UIDevice.isDevice(ofType: .iPhone6plus) {
            
        }
        self.font =  UIFont(name: font, size: CGFloat(fontValue))!
    }

}
