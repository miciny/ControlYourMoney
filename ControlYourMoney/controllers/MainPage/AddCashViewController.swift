//
//  AddCashViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/3/12.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class AddCashViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, costNameListViewDelegate{
    var numberUsedData = UITextField()
    var whereUsedData = UITextField()
    var isCreditCheck: UIButton! //
    var accountData = UILabel()
    var accountArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "现金记账"
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)

        setupCashLable()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        initData()
    }
    
    func initData(){
        accountArray = NSMutableArray()
        let accountTempArray = SQLLine.selectAllData(entityNameOfPayName)
        
        if accountTempArray.count == 0{
            let alert = textAlertView("请先添加支出类型")
            alert.delegate = self
            return
        }
        
        for i in 0 ..< accountTempArray.count {
            let name = accountTempArray[i].valueForKey(payNameNameOfName) as! String
            accountArray.addObject(name)
        }
        
        if self.accountData.text == nil {
            if accountArray.containsObject("早中晚餐"){
                self.accountData.text = "早中晚餐"
            }else{
                self.accountData.text = accountArray.objectAtIndex(0) as? String
            }
        }
    }
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        let vc = AddCostNameViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupCashLable(){
        let gap = CGFloat(10)
        
        let numberUsedSize = sizeWithText("支出类型：", font: introduceFont, maxSize: CGSizeMake(self.view.frame.width/2, 30))
        let numberUsed = UILabel.introduceLabel()
        numberUsed.frame = CGRectMake(20, 90, numberUsedSize.width, 30)
        numberUsed.text = "金额："
        self.view.addSubview(numberUsed)
        
        let whereUsed = UILabel.introduceLabel()
        whereUsed.frame = CGRectMake(20, numberUsed.frame.maxY+gap, numberUsedSize.width, 30)
        whereUsed.text = "用处："
        self.view.addSubview(whereUsed)
        
        self.numberUsedData = UITextField.inputTextField()
        self.numberUsedData.frame = CGRectMake(numberUsed.frame.maxX, numberUsed.frame.minY, self.view.frame.size.width-numberUsed.frame.maxX-20, 30)
        self.numberUsedData.placeholder = "请输入金额..."
        self.numberUsedData.keyboardType = UIKeyboardType.DecimalPad //激活时 弹出数字键盘
        self.numberUsedData.becomeFirstResponder() //界面打开时就获取焦点
        self.numberUsedData.returnKeyType = UIReturnKeyType.Done //表示完成输入
        self.view.addSubview(self.numberUsedData)
        
        self.whereUsedData = UITextField.inputTextField()
        self.whereUsedData.frame = CGRectMake(whereUsed.frame.maxX, whereUsed.frame.minY, self.view.frame.size.width-whereUsed.frame.maxX-20, 30)
        self.whereUsedData.placeholder = "请输入用处..."
        self.view.addSubview(self.whereUsedData)
        
        let account = UILabel.introduceLabel()
        account.frame = CGRectMake(20, whereUsed.frame.maxY+gap, numberUsedSize.width, 30)
        account.text = "支出类型："
        self.view.addSubview(account)
        
        self.accountData = UILabel.selectLabel(self, selector: #selector(goSelectAccount))
        self.accountData.frame = CGRectMake(account.frame.maxX, account.frame.minY, self.view.frame.size.width-account.frame.maxX-20, 30)
        self.view.addSubview(self.accountData)
        
        isCreditCheck = UIButton.checkButton(self, selector: #selector(isCreditSeleted))
        isCreditCheck.frame = CGRect(x: 20, y: account.frame.maxY+gap+5, width: 20, height: 20)
        isCreditCheck.selected = false
        self.view.addSubview(isCreditCheck)
        
        let size1 = sizeWithText("信用账号", font: introduceFont, maxSize: CGSizeMake(Width, 30))
        let isCreditCheckButtonText = UILabel.introduceLabel()
        isCreditCheckButtonText.frame = CGRectMake(isCreditCheck.frame.maxX+10, isCreditCheck.frame.minY-5, size1.width, 30)
        isCreditCheckButtonText.text = "信用账号"
        isCreditCheckButtonText.userInteractionEnabled = true //打开点击事件
        let tap1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddCashViewController.isCreditSeleted))
        isCreditCheckButtonText.addGestureRecognizer(tap1)
        self.view.addSubview(isCreditCheckButtonText)
        
        let save = UIButton(frame: CGRectMake(20, isCreditCheckButtonText.frame.maxY+gap*3, self.view.frame.size.width - 40, 44))
        save.layer.backgroundColor = UIColor.redColor().CGColor
        save.layer.cornerRadius = 3
        save.setTitle("保  存", forState: UIControlState.Normal)
        save.addTarget(self,action: #selector(saveCash),forControlEvents:.TouchUpInside)
        self.view.addSubview(save)
    }
    
    func goSelectAccount(){
        let vc = CostNameListViewController()
        vc.delegate = self
        let vcNavigationController = UINavigationController(rootViewController: vc) //带导航栏
        self.navigationController?.presentViewController(vcNavigationController, animated: true, completion: nil)
    }
    
    func costNameClicked(name: String) {
        self.accountData.text = name
    }
    
    func saveCash(){
        
        if(self.numberUsedData.text == "" || self.whereUsedData.text == ""){
            textAlertView("请输入金额和用处！")
            return
        }
        
        if(!stringIsFloat(self.numberUsedData.text! as String)){
            textAlertView("请输入正确金额！")
            return
        }
        
        //用的现金
        if !isCreditCheck.selected{
            SQLLine.insertCashData(self.whereUsedData.text!, useNumber: Float(self.numberUsedData.text!)!, type: self.accountData.text!, time: getTime())
            
            CalculateCredit.changeTotal(Float(self.numberUsedData.text!)!)
        }else{
            var isIn = false
            var index = 0
            let timeNow = getTime()
            var account = String()
            
            var MM = timeNow.currentMonth
            
            if(myOwnAccountBillDay <= timeNow.currentDay){
                MM += 1
                if MM+1 == 13{
                    MM = 1
                }
                account = myOwnAccount + String(MM) + "月"
            }else{
                account = myOwnAccount + String(MM) + "月"
            }
            
            let creditArray = SQLLine.selectAllData(entityNameOfCredit)
            for i in 0 ..< creditArray.count {
                let name = creditArray[i].valueForKey(creditNameOfAccount) as! String
                if name == account{
                    isIn = true
                    index = i
                    break
                }
            }
            
            if !isIn {
                var refundDate = NSDate()
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
                
                SQLLine.insertCrediData(1, number: Float(numberUsedData.text!)!, time: refundDate, account: account, date: myOwnAccountPayDay, nextPayDay: nextPayDay, leftPeriods: 1, type: self.accountData.text!)
            }else{
                let oldNumber = creditArray[index].valueForKey(creditNameOfNumber) as! Float
                SQLLine.updateCreditDataSortedByTime(index, changeValue: oldNumber+Float(numberUsedData.text!)!, changeEntityName: creditNameOfNumber)
               
            }
        }
        MyToastView().showToast("添加成功！")
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func isCreditSeleted(){
        isCreditCheck.selected = !isCreditCheck.selected
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
