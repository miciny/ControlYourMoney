//
//  AddIncomeAccountViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/18.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class AddIncomeAccountViewController: UIViewController {
    var accountText: UITextField! //输入框

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "收入类型"
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        
        //取消按钮
        let rightBarBtn = UIBarButtonItem(title: "取消", style: .plain, target: self,
                                          action: #selector(backToPrevious))
        self.navigationItem.rightBarButtonItem = rightBarBtn
        
        setupLable()
    }
    
    //退出页面
    func backToPrevious(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //设置label
    func setupLable(){
        let gap = CGFloat(10)
        
        let accountSize = sizeWithText("收入类型：", font: introduceFont, maxSize: CGSize(width: self.view.frame.width/2, height: 30))
        let account = UILabel.introduceLabel()
        account.frame = CGRect(x: 20, y: 90, width: accountSize.width, height: 30)
        account.text = "收入类型："
        self.view.addSubview(account)
        
        self.accountText = UITextField.inputTextField()
        self.accountText.frame = CGRect(x: account.frame.maxX, y: account.frame.minY, width: self.view.frame.size.width-account.frame.maxX-20, height: 30)
        self.accountText.placeholder = "请输入类型名称..."
        self.accountText.keyboardType = UIKeyboardType.default //激活时
        self.accountText.becomeFirstResponder() //界面打开时就获取焦点
        self.accountText.returnKeyType = UIReturnKeyType.done //表示完成输入
        self.view.addSubview(self.accountText)
        
        let save = UIButton(frame: CGRect(x: 20, y: account.frame.maxY+gap*3, width: self.view.frame.size.width-40, height: 44))
        save.layer.backgroundColor = UIColor.red.cgColor
        save.layer.cornerRadius = 3
        save.setTitle("保  存", for: UIControlState())
        save.addTarget(self,action: #selector(saveAccount),for:.touchUpInside)
        self.view.addSubview(save)
    }
    
    //保存
    func saveAccount(){
        //检查数据
        if(self.accountText.text == ""){
            textAlertView("请输入内容！")
            return
        }
        
        let str = self.accountText.text
        let accountArray = IncomeName.selectAllData()
        
        for i in 0 ..< accountArray.count {
            let name = (accountArray[i] as AnyObject).value(forKey: incomeNameOfName) as! String
            if name == str {
                textAlertView("已存在")
                return
            }
        }
        
        //保存数据
        IncomeName.insertIncomeNameData(getTime(), name: str!)
        MyToastView().showToast("添加成功！")
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
