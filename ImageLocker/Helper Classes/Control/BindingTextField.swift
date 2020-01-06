//
//  BindingTextBox.swift
//  Headlines
//
//  Created by Darshan Gajera on 10/20/18.
//  Copyright © 2018 Darshan Gajera. All rights reserved.
//

import Foundation
import UIKit
//swiftlint:disable all
class BindingTextField : UITextField {
   var textChanged :(String) -> () = { _ in }
    
    func bind(callback :@escaping (String) -> ()) {
        
        self.textChanged = callback
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField :UITextField) {
        self.textChanged(textField.text!)
    }
}
