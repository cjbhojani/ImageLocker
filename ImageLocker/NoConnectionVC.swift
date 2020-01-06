//
//  NoConnectionVC.swift
//  alamofireCodble
//
//  Created by Darshan Gajera on 08/07/18.
//  Copyright © 2018 Darshan Gajera. All rights reserved.
//

import UIKit

class NoConnectionVC: UIViewController {
    
    let network = NetworkManager.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        SnackBar.show(strMessage: "Please check internet connection", type: .nagative)
        network.reachability.whenReachable = { reachability in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
