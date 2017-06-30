//
//  AddCashViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/3/12.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class AddCashViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate{
    var numberUsedData = UITextField()  //现金额度的输入框
    var whereUsedData = UITextField()  //现金用处的输入框
    var isCreditCheck: UIButton! //是否用的信用卡按钮
    var accountData = UILabel() //是否用的信用卡的label，因为点击label，也要选中信用卡
    var accountArray = NSMutableArray() //保存支出类型的数组

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "现金记账"
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)

        setupCashLable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        initData()
    }
    
    //初始化数据
    func initData(){
        accountArray = NSMutableArray()
        let accountTempArray = PayName.selectAllData()
        
        if accountTempArray.count == 0{
            let alert = textAlertView("请先添加支出类型")
            alert.delegate = self
            return
        }
        
        for i in 0 ..< accountTempArray.count {
            let name = (accountTempArray[i] as AnyObject).value(forKey: payNameNameOfName) as! String
            accountArray.add(name)
        }
        
        //优先选择早中晚餐
        if self.accountData.text == nil {
            if accountArray.contains("早中晚餐"){
                self.accountData.text = "早中晚餐"
            }else{
                self.accountData.text = accountArray.object(at: 0) as? String
            }
        }
    }
    
    //提示框
    func alertView(_ alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        let vc = AddCostNameViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //配置页面元素
    func setupCashLable(){
        let gap = CGFloat(10)
        
        //三个label
        let numberUsedSize = sizeWithText("支出类型：", font: introduceFont, maxSize: CGSize(width: self.view.frame.width/2, height: 30))
        let numberUsed = UILabel.introduceLabel()
        numberUsed.frame = CGRect(x: 20, y: 90, width: numberUsedSize.width, height: 30)
        numberUsed.text = "金额："
        self.view.addSubview(numberUsed)
        
        let whereUsed = UILabel.introduceLabel()
        whereUsed.frame = CGRect(x: 20, y: numberUsed.frame.maxY+gap, width: numberUsedSize.width, height: 30)
        whereUsed.text = "用处："
        self.view.addSubview(whereUsed)
        
        let account = UILabel.introduceLabel()
        account.frame = CGRect(x: 20, y: whereUsed.frame.maxY+gap, width: numberUsedSize.width, height: 30)
        account.text = "支出类型："
        self.view.addSubview(account)
        
        //两个输入框
        self.numberUsedData = UITextField.inputTextField()
        self.numberUsedData.frame = CGRect(x: numberUsed.frame.maxX, y: numberUsed.frame.minY, width: self.view.frame.size.width-numberUsed.frame.maxX-20, height: 30)
        self.numberUsedData.placeholder = "请输入金额..."
        self.numberUsedData.keyboardType = UIKeyboardType.decimalPad //激活时 弹出数字键盘
        self.numberUsedData.becomeFirstResponder() //界面打开时就获取焦点
        self.numberUsedData.returnKeyType = UIReturnKeyType.done //表示完成输入
        self.view.addSubview(self.numberUsedData)
        
        self.whereUsedData = UITextField.inputTextField()
        self.whereUsedData.frame = CGRect(x: whereUsed.frame.maxX, y: whereUsed.frame.minY, width: self.view.frame.size.width-whereUsed.frame.maxX-20, height: 30)
        self.whereUsedData.placeholder = "请输入用处..."
        self.view.addSubview(self.whereUsedData)
        
        //支出类型的label
        self.accountData = UILabel.selectLabel(self, selector: #selector(goSelectAccount))
        self.accountData.frame = CGRect(x: account.frame.maxX, y: account.frame.minY, width: self.view.frame.size.width-account.frame.maxX-20, height: 30)
        self.view.addSubview(self.accountData)
        
        //是否是信用卡的按钮和label
        isCreditCheck = UIButton.checkButton(self, selector: #selector(isCreditSeleted))
        isCreditCheck.frame = CGRect(x: 20, y: account.frame.maxY+gap+5, width: 20, height: 20)
        isCreditCheck.isSelected = false
        self.view.addSubview(isCreditCheck)
        
        let size1 = sizeWithText("信用账号", font: introduceFont, maxSize: CGSize(width: Width, height: 30))
        let isCreditCheckButtonText = UILabel.introduceLabel()
        isCreditCheckButtonText.frame = CGRect(x: isCreditCheck.frame.maxX+10, y: isCreditCheck.frame.minY-5, width: size1.width, height: 30)
        isCreditCheckButtonText.text = "信用账号"
        isCreditCheckButtonText.isUserInteractionEnabled = true //打开点击事件
        let tap1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddCashViewController.isCreditSeleted))
        isCreditCheckButtonText.addGestureRecognizer(tap1)
        self.view.addSubview(isCreditCheckButtonText)
        
        //保存按钮
        let save = UIButton(frame: CGRect(x: 20, y: isCreditCheckButtonText.frame.maxY+gap*3, width: self.view.frame.size.width - 40, height: 44))
        save.layer.backgroundColor = UIColor.red.cgColor
        save.layer.cornerRadius = 3
        save.setTitle("保  存", for: UIControlState())
        save.addTarget(self,action: #selector(saveCash),for:.touchUpInside)
        self.view.addSubview(save)
    }
    
    //进入选择支出类型的页面
    func goSelectAccount(){
        let vc = CostNameListViewController()
        vc.delegate = self
        let vcNavigationController = UINavigationController(rootViewController: vc) //带导航栏
        self.navigationController?.present(vcNavigationController, animated: true, completion: nil)
    }
    
    //保存
    func saveCash(){
        
        //判断输入的数据
        guard let numberStr = self.numberUsedData.text, numberStr != "" else{
            textAlertView("请输入金额！")
            return
        }
        
        guard let whereStr = self.whereUsedData.text, whereStr != "" else{
            textAlertView("请输入用处！")
            return
        }
        
        if(!stringIsFloat(numberStr)){
            textAlertView("请输入正确金额！")
            return
        }
        
        //用的现金
        if !isCreditCheck.isSelected{
            Cash.insertCashData(whereStr, useNumber: Float(numberStr)!, type: self.accountData.text!, time: getTime())
            
            CalculateCredit.changeTotal(Float(self.numberUsedData.text!)!)
        }else{ //用的信用卡
            let timeNow = getTime()
            var account = String()
            
            var MM = timeNow.currentMonth
            
            if(myOwnAccountBillDay <= timeNow.currentDay){  //3号的账单日，21号的还还款日
                MM += 1
                if MM+1 == 13{
                    MM = 1
                }
                account = myOwnAccount + String(MM) + "月"
            }else{
                account = myOwnAccount + String(MM) + "月"
            }
            
            var refundDate = Date()
            if(myOwnAccountBillDay < timeNow.currentDay){
                let yyyy = timeNow.currentYear
                let mm = timeNow.currentMonth
                refundDate = stringToDateNoHH(String(yyyy) + "-" + String(mm) + "-" + String(myOwnAccountPayDay+1))
            }else{
                var mm = timeNow.currentMonth-1
                var yyyy = timeNow.currentYear
                if mm == 0 {
                    mm = 12
                    yyyy -= 1
                }
                
                refundDate = stringToDateNoHH(String(yyyy) + "-" + String(mm) + "-" + String(myOwnAccountPayDay+1))
            }
            
            let nextPayDay = CalculateCredit.getFirstPayDate(refundDate, day: myOwnAccountPayDay)
            
            Credit.insertCrediData(1, number: Float(numberUsedData.text!)!, time: refundDate, account: account, date: myOwnAccountPayDay, nextPayDay: nextPayDay, leftPeriods: 1, type: self.accountData.text!)
        }
        MyToastView().showToast("添加成功！")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //选择了是否是信用卡按钮事件
    func isCreditSeleted(){
        isCreditCheck.isSelected = !isCreditCheck.isSelected
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AddCashViewController: costNameListViewDelegate{
    //支出类型列表页，选择一个类型后的传值
    func costNameClicked(_ name: String) {
        self.accountData.text = name
    }
}
