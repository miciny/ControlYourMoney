//
//  ChangePWViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/6/3.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class ChangePWViewController: UIViewController, UITextFieldDelegate{

    private let pwTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEles()
    }
    
    //设置title 导航栏等
    func setUpEles(){
        self.title = "修改密码"
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
        
        pwTextField.frame = CGRect(x: 10, y: 7, width: Width-20, height: 30)
        pwTextField.backgroundColor = UIColor.clearColor()
        pwTextField.font = UIFont.systemFontOfSize(15)
        pwTextField.textAlignment = NSTextAlignment.Left
        pwTextField.secureTextEntry = true //密码
        pwTextField.keyboardType = UIKeyboardType.Default //激活时 弹出普通键盘 DecimalPad带小数点的键盘
        pwTextField.returnKeyType = UIReturnKeyType.Done //表示完成输入
        pwTextField.clearButtonMode=UITextFieldViewMode.WhileEditing  //编辑时出现清除按钮
        pwTextField.delegate = self
        pwTextField.placeholder = "请输入密码"
        nameTextView.addSubview(pwTextField)
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
        self.navigationItem.rightBarButtonItem!.enabled = (newText != "")
        
        return true
    }
    
    //保存
    func saveName() {
        let pwTemp = pwTextField.text!
        User.updateuserData(0, changeValue: pwTemp, changeFieldName: userNameOfPW)
        User.updateuserData(0, changeValue: true, changeFieldName: userNameOfChanged)
        backToPrevious()
        let toast = MyToastView()
        toast.showToast("修改成功！")
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
