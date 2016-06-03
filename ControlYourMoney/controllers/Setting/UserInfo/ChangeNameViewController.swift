//
//  ChangeNameViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/6/3.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class ChangeNameViewController: UIViewController, UITextFieldDelegate{

    private let nameTextField = UITextField()
    
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEles()
    }
    
    //设置title 导航栏等
    func setUpEles(){
        self.title = "名字"
        self.view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        
        //取消按钮
        let leftBarBtn = UIBarButtonItem(title: "取消", style: .Plain, target: self,
                                         action: #selector(ChangeNameViewController.backToPrevious))
        self.navigationItem.leftBarButtonItem = leftBarBtn
        
        //保存按钮
        let rightBarBtn = UIBarButtonItem(title: "保存", style: .Plain, target: self,
                                          action: #selector(ChangeNameViewController.saveName))
        rightBarBtn.tintColor = UIColor(red: 7/255, green: 191/255, blue: 5/255, alpha: 0.9)
        self.navigationItem.rightBarButtonItem = rightBarBtn
        self.navigationItem.rightBarButtonItem?.enabled = false
        
        setUpTextField()
    }
    
    //输入框
    func setUpTextField(){
        let nameTextView = UIView(frame: CGRect(x: 0, y: 70, width: Width, height: 44))
        nameTextView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(nameTextView)
        
        nameTextField.frame = CGRect(x: 10, y: 7, width: Width-20, height: 30)
        nameTextField.backgroundColor = UIColor.clearColor()
        nameTextField.font = UIFont.systemFontOfSize(15)
        nameTextField.textAlignment = NSTextAlignment.Left
        nameTextField.textColor = UIColor.blackColor()
        nameTextField.text = name
        nameTextField.keyboardType = UIKeyboardType.Default //激活时 弹出普通键盘 DecimalPad带小数点的键盘
        nameTextField.becomeFirstResponder() //界面打开时就获取焦点
        nameTextField.returnKeyType = UIReturnKeyType.Done //表示完成输入
        nameTextField.clearButtonMode=UITextFieldViewMode.WhileEditing  //编辑时出现清除按钮
        nameTextField.delegate = self
        nameTextView.addSubview(nameTextField)
    }
    
    //键盘上的完成按钮 相应事件 收起键盘
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //收起键盘
        textField.resignFirstResponder()
        return true
    }
    
    //输入框字符改变了
    //    要获取最新内容，则需要String的 stringByReplacingCharactersInRange 方法，但这个方法在Swift的String中又不支持。
    //    要解决这个问题，就要先替 NSRange 做个扩展。
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
                   replacementString string: String) -> Bool {
        
        let newText = textField.text!.stringByReplacingCharactersInRange(
            range.toRange(textField.text!), withString: string)
        
        //判断输入框删空了 或者和原来的一样
        self.navigationItem.rightBarButtonItem!.enabled = (newText != name && newText != "")
        
        return true
    }
    
    //保存
    func saveName() {
        let name = nameTextField.text!
        User.updateuserData(0, changeValue: name, changeFieldName: userNameOfName)
        backToPrevious()
        let toast = MyToastView()
        toast.showToast("保存成功！")
    }
    
    //返回
    func backToPrevious() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
