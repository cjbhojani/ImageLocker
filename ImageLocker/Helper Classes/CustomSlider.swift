//
//  CustomSlider.swift
//  HandyMan
//
//  Created by Darshan Gajera on 08/01/19.
//  Copyright © 2019 Darshan Gajera. All rights reserved.
//

import UIKit



protocol CustomSliderDelegate: class {
    func sliderValueChange(index: Int,val: Int,slider: CustomSlider)
}



class CustomSlider: UIView {
    
    var arrLabelValues:NSArray?
    weak var delegate: CustomSliderDelegate?
    @IBOutlet weak var lblFirst: UILabel!
    @IBOutlet weak var lblSecond: UILabel!
    @IBOutlet weak var lblThree: UILabel!
    @IBOutlet weak var lblFour: UILabel!
    @IBOutlet weak var lblFive: UILabel!
    @IBOutlet weak var lblLast: UILabel!
    
    @IBOutlet weak var btnFirst: UIButton!
    @IBOutlet weak var btnSecond: UIButton!
    @IBOutlet weak var btnThree: UIButton!
    @IBOutlet weak var btnFour: UIButton!
    @IBOutlet weak var btnLast: UIButton!

    
    @IBOutlet weak var btnFirstClickable: UIButton!
    @IBOutlet weak var btnTwoClickable: UIButton!
    @IBOutlet weak var btnThreeClickable: UIButton!
    @IBOutlet weak var btnFourClickable: UIButton!
    @IBOutlet weak var btnLastClickable: UIButton!
    
    
    @IBOutlet weak var lblFirstLeadingConstrain: NSLayoutConstraint!
    @IBOutlet weak var lblSecondTrailingConstrain: NSLayoutConstraint!
    @IBOutlet weak var lblThreeTrailingConstrain: NSLayoutConstraint!
    @IBOutlet weak var lblFourTrailingConstrain: NSLayoutConstraint!
    @IBOutlet weak var lblFiveTrailingConstrain: NSLayoutConstraint!
    @IBOutlet weak var lblLastTrailingConstrain: NSLayoutConstraint!
    
    override func awakeFromNib() {
        
        btnFirst.tag = 101
        btnSecond.tag = 102
        btnThree.tag = 103
        btnFour.tag = 104
        btnLast.tag = 105
        
        btnFirstClickable.tag = 121
        btnTwoClickable.tag = 122
        btnThreeClickable.tag = 123
        btnFourClickable.tag = 124
        btnLastClickable.tag = 125
        
        lblFirst.tag = 111
        lblSecond.tag = 112
        lblThree.tag = 113
        lblFour.tag = 114
        lblFive.tag = 115
        lblLast.tag = 116
        
        self.allLabelDefaultColor()
        self.backgroundColor = UIColor.clear
        
        btnFirst.roundCorners(corners: [.topLeft, .bottomLeft], radius: 4.0)
        btnLast.roundCorners(corners: [.topRight, .bottomRight], radius: 4.0)
        lblFirstLeadingConstrain.constant = lblFirstLeadingConstrain.constant - (lblFirst.frame.width/2)
        lblSecondTrailingConstrain.constant = lblSecondTrailingConstrain.constant + (lblSecond.frame.width/2)
        lblThreeTrailingConstrain.constant = lblThreeTrailingConstrain.constant + (lblThree.frame.width/2)
        lblFourTrailingConstrain.constant = lblFourTrailingConstrain.constant + (lblFour.frame.width/2)
        lblFiveTrailingConstrain.constant = lblFiveTrailingConstrain.constant + (lblFive.frame.width/2)
        lblLastTrailingConstrain.constant = lblLastTrailingConstrain.constant + (lblLast.frame.width/2)
    }
    
    func setValue(arrValues: NSArray?,strPar: String,selectedValue: Int? = 0) {
        lblFirst.text = String(format: "%@ %@", (arrValues?.object(at: 0) as? String)!,strPar)
        lblSecond.text = String(format: "%@ %@", (arrValues?.object(at: 1) as? String)!,strPar)
        lblThree.text = String(format: "%@ %@", (arrValues?.object(at: 2) as? String)!,strPar)
        lblFour.text = String(format: "%@ %@", (arrValues?.object(at: 3) as? String)!,strPar)
        lblFive.text = String(format: "%@ %@", (arrValues?.object(at: 4) as? String)!,strPar)
        lblLast.text = String(format: "%@+ %@", (arrValues?.object(at: 5) as? String)!,strPar)
        self.setNeedsLayout()
        arrLabelValues = arrValues
        self.selectionChange(tag: selectedValue ?? 0)
    }
    
    @IBAction func btnSlidersClick(_ sender: UIButton) {
        self.sliderSelectionColor(btnSelected: sender)
        let value = (sender.tag % 100) - 20
        let strVal: String = arrLabelValues?.object(at: value) as! String
        delegate?.sliderValueChange(index: sender.tag, val: Int(strVal)!, slider: self)
    }
    
    func sliderSelectionColor(btnSelected: UIButton) {
        self.selectionChange(tag: btnSelected.tag)
    }
    
    func selectionChange(tag: Int) {
        let tagVal = tag - 20
        for i in 101..<106 {
            let btn = self.viewWithTag(i)
            if btn is UIButton {
                btn?.backgroundColor = Color.SliderDefault.color()
            }
        }
        for i in 101..<tagVal+1 {
            let btn = self.viewWithTag(i)
            if btn is UIButton {
                btn?.backgroundColor = Color.SliderSelction.color()
            }
        }
        for i in 111..<117 {
            let lbl = self.viewWithTag(i)
            if lbl is UILabel {
                (lbl as! UILabel).textColor = Color.SliderTextDefault.color()
            }
        }
        let lastTag = 11 + tagVal + 1
        for i in 111..<lastTag {
            let lbl = self.viewWithTag(i)
            if lbl is UILabel {
                (lbl as! UILabel).textColor = Color.SliderTextSelection.color()
            }
        }
    }
    
    func allLabelDefaultColor() {
        lblFirst.textColor = Color.SliderTextDefault.color()
        lblSecond.textColor = Color.SliderTextDefault.color()
        lblThree.textColor = Color.SliderTextDefault.color()
        lblFour.textColor = Color.SliderTextDefault.color()
        lblFive.textColor = Color.SliderTextDefault.color()
        lblLast.textColor = Color.SliderTextDefault.color()
        
        btnFirst.backgroundColor = Color.SliderDefault.color()
        btnSecond.backgroundColor = Color.SliderDefault.color()
        btnThree.backgroundColor = Color.SliderDefault.color()
        btnFour.backgroundColor = Color.SliderDefault.color()
        btnLast.backgroundColor = Color.SliderDefault.color()
    }
}
