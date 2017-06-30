//
//  AddCostNameViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/18.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class AddCostNameViewController: UIViewController {
    
    var accountText: UITextField! //添加支出类型的输入框

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "支出类型"
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        
        //取消按钮
        let rightBarBtn = UIBarButtonItem(title: "取消", style: .plain, target: self,
                                          action: #selector(backToPrevious))
        self.navigationItem.rightBarButtonItem = rightBarBtn
        
        setupLable()
    }
    
    //配置页面元素
    func setupLable(){
        let gap = CGFloat(10)
        
        let accountSize = sizeWithText("支出类型：", font: introduceFont, maxSize: CGSize(width: self.view.frame.width/2, height: 30))
        let account = UILabel.introduceLabel()
        account.frame = CGRect(x: 20, y: 90, width: accountSize.width, height: 30)
        account.text = "支出类型："
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
    
    //保存数据
    func saveAccount(){
        //检查
        if(self.accountText.text == ""){
            textAlertView("请输入内容！")
            return
        }
        
        let str = self.accountText.text
        let accountArray = PayName.selectAllData()
        
        //判断是否已存在
        for i in 0 ..< accountArray.count {
            let name = (accountArray[i] as AnyObject).value(forKey: payNameNameOfName) as! String
            if name == str {
                textAlertView("已存在")
                return
            }
        }
        
        //保存输入
        PayName.insertPayNameData(str!, time: getTime())
        MyToastView().showToast("添加成功！")
        self.navigationController?.popViewController(animated: true)
    }

    //退出页面
    func backToPrevious(){
        self.navigationController?.popToRootViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
