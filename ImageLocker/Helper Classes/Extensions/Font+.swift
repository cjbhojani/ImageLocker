//
//  Font+.swift
//  FullKit
//
//  Created by Darshan Gajera on 21/06/18.
//  Copyright © 2018 Darshan Gajera. All rights reserved.
//

import Foundation
import UIKit

enum AppFont: String {
    case Avenir = "Avenir"
    case AvenirBold = "Avenir-Heavy"
    case AvenirLight = "Avenir-Light"
    case AvenirNext = "Avenir Next"
    case AvenirNextCon = "AvenirNextCondensed"
    case SFPro = "SF Pro Display"
    
    case Roboto = "Roboto-Regular"
    case RobotoBold = "Roboto-Bold"
    case RobotoLight = "Roboto-Light"
    
    func customFont(size: CGFloat) -> UIFont {
        let font = UIFont(name: self.rawValue, size: size)
        assert(font != nil, "Can't load font: \(self.rawValue)")
        return font ?? UIFont.systemFont(ofSize: size)
    }
}
