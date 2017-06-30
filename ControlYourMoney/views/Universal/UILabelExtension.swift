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
    
    //自定义的介绍label样式
    public class func introduceLabel() -> UILabel{
        let label = UILabel()
        label.font = introduceFont
        label.textAlignment = NSTextAlignment.left
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.black
        return label
    }
    
    //自定义的输入label样式
    public class func inputLabel() -> UILabel{
        let label = UILabelPadding()
        label.textAlignment = NSTextAlignment.left
        label.backgroundColor = UIColor.white
        label.textColor = UIColor.black
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 3
        label.font = introduceFont
        return label
    }
    
    //自定义的选择的label样式
    public class func selectLabel(_ target: UIViewController,selector: Selector) -> UILabel{
        let label = UILabelPadding()
        label.textAlignment = NSTextAlignment.left
        label.backgroundColor = UIColor.white
        label.textColor = UIColor.black
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 3
        label.font = introduceFont
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: target, action: selector)
        label.addGestureRecognizer(tap)
        return label
    }
}

extension UIButton{
    //自定义的check样式btn
    public class func checkButton(_ target: UIViewController, selector: Selector) -> UIButton{
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "CheckOff"), for:UIControlState())
        btn.setImage(UIImage(named: "CheckOn"), for:UIControlState.selected)
        btn.addTarget(target, action: selector, for:.touchUpInside)
        btn.isSelected = false
        return btn
    }
}

extension UITextField{
    //自定义的textField样式
    public class func inputTextField() -> UITextField{
        let textField = UITextField()
        
        textField.font = introduceFont
        textField.textAlignment = NSTextAlignment.left
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.clearButtonMode = UITextFieldViewMode.whileEditing
        textField.backgroundColor = UIColor.white
        textField.textColor = UIColor.black
        return textField
    }
}
