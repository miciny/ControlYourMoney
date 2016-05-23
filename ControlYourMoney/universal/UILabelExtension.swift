//
//  UILabelExtension.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/23.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation
import UIKit

extension UILabel{
    
    public class func introduceLabel() -> UILabel{
        let label = UILabel()
        label.font = introduceFont
        label.textAlignment = NSTextAlignment.Left
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.blackColor()
        return label
    }
    
    public class func inputLabel() -> UILabel{
        let label = UILabelPadding()
        label.textAlignment = NSTextAlignment.Left
        label.backgroundColor = UIColor.whiteColor()
        label.textColor = UIColor.blackColor()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 3
        label.font = introduceFont
        return label
    }
    
    public class func selectLabel(target: UIViewController,selector: Selector) -> UILabel{
        let label = UILabelPadding()
        label.textAlignment = NSTextAlignment.Left
        label.backgroundColor = UIColor.whiteColor()
        label.textColor = UIColor.blackColor()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 3
        label.font = introduceFont
        label.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: target, action: selector)
        label.addGestureRecognizer(tap)
        return label
    }
}

extension UIButton{
    public class func checkButton(target: UIViewController, selector: Selector) -> UIButton{
        let btn = UIButton(type: UIButtonType.Custom)
        btn.setImage(UIImage(named: "CheckOff"), forState:UIControlState.Normal)
        btn.setImage(UIImage(named: "CheckOn"), forState:UIControlState.Selected)
        btn.addTarget(target, action: selector, forControlEvents:.TouchUpInside)
        btn.selected = false
        return btn
    }
}

extension UITextField{
    
    public class func inputTextField() -> UITextField{
        let textField = UITextField()
        
        textField.font = introduceFont
        textField.textAlignment = NSTextAlignment.Left
        textField.borderStyle = UITextBorderStyle.RoundedRect
        textField.clearButtonMode = UITextFieldViewMode.WhileEditing
        textField.backgroundColor = UIColor.whiteColor()
        textField.textColor = UIColor.blackColor()
        return textField
    }
}