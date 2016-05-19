//
//  AddCostNameViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/18.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class AddCostNameViewController: UIViewController {
    
    var accountText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "支出类型"
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        
        //取消按钮
        let rightBarBtn = UIBarButtonItem(title: "取消", style: .Plain, target: self,
                                          action: #selector(backToPrevious))
        self.navigationItem.rightBarButtonItem = rightBarBtn
        
        setupLable()

        // Do any additional setup after loading the view.
    }
    
    func setupLable(){
        let gap = CGFloat(10)
        
        let accountSize = sizeWithText("收入类型：", font: introduceFont, maxSize: CGSizeMake(self.view.frame.width/2, 30))
        let account = UILabel(frame: CGRectMake(20, 90, accountSize.width, 30))
        account.font = introduceFont
        account.textAlignment = NSTextAlignment.Left
        account.backgroundColor = UIColor.clearColor()
        account.textColor = UIColor.blackColor()
        account.text = "收入类型："
        self.view.addSubview(account)
        
        
        self.accountText = UITextField(frame: CGRectMake(account.frame.maxX, account.frame.minY, self.view.frame.size.width-account.frame.maxX-20, 30))
        self.accountText.font = introduceFont
        self.accountText.textAlignment = NSTextAlignment.Left
        self.accountText.borderStyle = UITextBorderStyle.RoundedRect
        self.accountText.clearButtonMode = UITextFieldViewMode.WhileEditing
        self.accountText.backgroundColor = UIColor.whiteColor()
        self.accountText.textColor = UIColor.blackColor()
        self.accountText.placeholder = "请输入类型名称..."
        self.accountText.keyboardType = UIKeyboardType.Default //激活时
        self.accountText.becomeFirstResponder() //界面打开时就获取焦点
        self.accountText.returnKeyType = UIReturnKeyType.Done //表示完成输入
        self.view.addSubview(self.accountText)
        
        let save = UIButton(frame: CGRectMake(20, account.frame.maxY+gap*3, self.view.frame.size.width-40, 44))
        save.layer.backgroundColor = UIColor.redColor().CGColor
        save.layer.cornerRadius = 3
        save.setTitle("保  存", forState: UIControlState.Normal)
        save.addTarget(self,action: #selector(saveAccount),forControlEvents:.TouchUpInside)
        self.view.addSubview(save)
    }
    
    func saveAccount(){
        if(self.accountText.text == ""){
            textAlertView("请输入内容！")
            return
        }
        
        let str = self.accountText.text
        let accountArray = SQLLine.selectAllData(entityNameOfPayName)
        
        for i in 0 ..< accountArray.count {
            let name = accountArray[i].valueForKey(payNameNameOfName) as! String
            if name == str {
                textAlertView("已存在")
                return
            }
        }
        
        SQLLine.insertPayNameData(str!, time: getTime())
        MyToastView().showToast("添加成功！")
        self.navigationController?.popViewControllerAnimated(true)
    }

    
    func backToPrevious(){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}