//
//  UIVIewController+.swift
//  FullKit
//
//  Created by Darshan Gajera on 21/06/18.
//  Copyright © 2018 Darshan Gajera. All rights reserved.
//

import Foundation
import UIKit
// swiftlint:disable all
typealias okButton = (_ left : UIButton) -> Void
typealias cancelButton = (_ right : UIButton) -> Void

extension UIViewController {
    
    func presentAlertWithTitle(presentStyle: UIAlertController.Style ,title: String, message: String, options: String..., completion: @escaping (Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: presentStyle)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                completion(index)
            }))
        }
        self.present(alertController, animated: true, completion: nil)
        
        // Implementaion
        /*
         presentAlertWithTitle(presentStyle: .alert, title: "Test", message: "A message", options: "1", "2") { (option) in
         print("option: \(option)")
         switch(option) {
         case 0:
         print("option one")
         break
         case 1:
         print("option two")
         default:
         break
         }
         }
         */
    }
    
    func updateCurvedNavigationBarBackgroundColor(color: UIColor) {
        
        // Get layer if exist
        guard let layer = curvedLayer() else {
            return
        }
        
        layer.fillColor = color.cgColor
    }
    
    // Private functions
    
    private func curvedLayer() -> CAShapeLayer? {
        // Find our layer and return it, if not found return nil
        if let existingLayer = view.layer.sublayers?.filter({$0.name == "curved_nav_bar"}), existingLayer.count > 0 {
            if let existingLayerSubLayers = existingLayer[0].sublayers, let pathLayer = existingLayerSubLayers[0] as? CAShapeLayer {
                return pathLayer
            }
        }
        return nil
    }
    
    // To run best place function last in viewDidLayoutSubviews
    func
        addCurvedNavigationBar(backgroundColor: UIColor = .red,
                               curveRadius: CGFloat = 17,
                               shadowColor: UIColor = .darkGray,
                               shadowRadius: CGFloat = 4,
                               heightOffset: CGFloat = 0) {
        
        // Without navigation controller we cannot continue. Also make sure layer do not exist already.
        guard let navigationController = self.navigationController, curvedLayer() == nil else {
            return
        }
        
        // Clear navigatio bar line and background by replacing with empty image
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.barTintColor = UIColor.blue
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        
        
        //         Get needed sizes with respect to device screen
        let screenWidth = UIScreen.main.bounds.size.width
        let totalHeight = UIApplication.shared.statusBarFrame.height + navigationController.navigationBar.frame.size.height + heightOffset
        let y1: CGFloat = totalHeight
        let y2: CGFloat = totalHeight + curveRadius
        
        // Create shape layer to hold curve path
        let pathLayer = CAShapeLayer()
        pathLayer.fillColor = backgroundColor.cgColor
        pathLayer.path = UIBezierPath().topCurvePath(width: screenWidth, y1: y1, y2: y2).cgPath
        
        // Create shadow layer
        let shadowLayer = CALayer().addShadowLayer(name: "curved_view", shapeLayer: pathLayer, radius: shadowRadius, color: shadowColor)
        
        // Add to view
        view.layer.addSublayer(shadowLayer)
    }
    
//    func sideMenuOpen(flag: Bool) {
//        let appDelegate = UIApplication.shared.delegate  as! AppDelegate
//        let rootVC = appDelegate.window!.rootViewController as! FAPanelController
//        rootVC.configs.canLeftSwipe = flag
//    }
}
