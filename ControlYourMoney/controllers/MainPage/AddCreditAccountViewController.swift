//
//  AddCreditAccpuntViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/12.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class AddCreditAccountViewController: UIViewController {

    var creditAccountText = UITextField() //输入框
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "信用帐号"
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        
        //取消按钮
        let rightBarBtn = UIBarButtonItem(title: "取消", style: .Plain, target: self,
                                         action: #selector(AddCreditAccountViewController.backToPrevious))
        self.navigationItem.rightBarButtonItem = rightBarBtn

        setupLable()
    }
    
    //退出页面
    func backToPrevious(){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    //设置页面元素
    func setupLable(){
        let gap = CGFloat(10)
        
        let creditAccountSize = sizeWithText("信用账号：", font: introduceFont, maxSize: CGSizeMake(self.view.frame.width/2, 30))
        let creditAccount = UILabel.introduceLabel()
        creditAccount.frame = CGRectMake(20, 90, creditAccountSize.width, 30)
        creditAccount.text = "信用账号："
        self.view.addSubview(creditAccount)
        
        self.creditAccountText = UITextField.inputTextField()
        self.creditAccountText.frame = CGRectMake(creditAccount.frame.maxX, creditAccount.frame.minY, self.view.frame.size.width-creditAccount.frame.maxX-20, 30)
        self.creditAccountText.placeholder = "请输入信用账号..."
        self.creditAccountText.keyboardType = UIKeyboardType.Default //激活时
        self.creditAccountText.becomeFirstResponder() //界面打开时就获取焦点
        self.creditAccountText.returnKeyType = UIReturnKeyType.Done //表示完成输入
        self.view.addSubview(self.creditAccountText)
        
        let save = UIButton(frame: CGRectMake(20, creditAccount.frame.maxY+gap*3, self.view.frame.size.width-40, 44))
        save.layer.backgroundColor = UIColor.redColor().CGColor
        save.layer.cornerRadius = 3
        save.setTitle("保  存", forState: UIControlState.Normal)
        save.addTarget(self,action: #selector(saveAccount),forControlEvents:.TouchUpInside)
        self.view.addSubview(save)
    }

    //保存数据
    func saveAccount(){
        //检查输入框
        if(self.creditAccountText.text == ""){
            textAlertView("请输入内容！")
            return
        }
        
        let str = self.creditAccountText.text
        let accountArray = CreditAccount.selectAllData()
        
        //是否已存在
        for i in 0 ..< accountArray.count {
            let name = accountArray[i].valueForKey(creditAccountNameOfName) as! String
            if name == str {
                textAlertView("已存在")
                return
            }
        }
        
        CreditAccount.insertAccountData(str!, time: getTime())
        MyToastView().showToast("添加成功！")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
