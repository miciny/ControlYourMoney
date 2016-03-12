//
//  AddViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 15/12/18.
//  Copyright © 2015年 maocaiyuan. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var addType = 0
    
    var numberUsedData = UITextField()
    var whereUsedData = UITextField()
    
    var numberSalaryData = UITextField()
    
    var periodsCreditData = UITextField()
    var numberCreditData = UITextField()
    var dateCreditData = UITextField()
    var accountCreditData = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitle()
        setUpEle()
        // Do any additional setup after loading the view.
    }
    
    func setUpTitle(){
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        switch addType{
        case 0 :
            self.title = "现金记账"
        case 1 :
            self.title = "添加信用卡（电子分期）"
        case 2 :
            self.title = "工资"
        default:
            self.title = "添加电子账号"
        }
        
    }
    
    func setUpEle(){
        switch addType{
        case 0 :
            setupCashLable()
        case 1 :
            setupCreditLable()
        case 2 :
            setupSalaryLable()
        default:
            setupCashLable()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCreditLable(){
        
        let periodsCredit = UILabel(frame: CGRectMake(20, 140, self.view.frame.size.width / 5 + 20, 30))
        periodsCredit.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        periodsCredit.textAlignment = NSTextAlignment.Left
        periodsCredit.backgroundColor = UIColor.clearColor()
        periodsCredit.textColor = UIColor.blackColor()
        periodsCredit.text = "还款期数："
        self.view.addSubview(periodsCredit)
        
        let numberCredit = UILabel(frame: CGRectMake(20, 200, self.view.frame.size.width / 5 + 20, 30))
        numberCredit.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        numberCredit.textAlignment = NSTextAlignment.Left
        numberCredit.backgroundColor = UIColor.clearColor()
        numberCredit.textColor = UIColor.blackColor()
        numberCredit.text = "每期金额："
        self.view.addSubview(numberCredit)
        
        let dateCredit = UILabel(frame: CGRectMake(20, 260, self.view.frame.size.width / 5 + 20, 30))
        dateCredit.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        dateCredit.textAlignment = NSTextAlignment.Left
        dateCredit.backgroundColor = UIColor.clearColor()
        dateCredit.textColor = UIColor.blackColor()
        dateCredit.text = "还款日期："
        self.view.addSubview(dateCredit)
        
        let account = UILabel(frame: CGRectMake(20, 320, self.view.frame.size.width / 5 + 20, 30))
        account.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        account.textAlignment = NSTextAlignment.Left
        account.backgroundColor = UIColor.clearColor()
        account.textColor = UIColor.blackColor()
        account.text = "信用账户："
        self.view.addSubview(account)
        
        periodsCreditData = UITextField(frame: CGRectMake(self.view.frame.size.width / 5 + 30, 140, self.view.frame.size.width * 2 / 3 - 20, 30))
        periodsCreditData.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        periodsCreditData.textAlignment = NSTextAlignment.Left
        periodsCreditData.borderStyle = UITextBorderStyle.RoundedRect
        periodsCreditData.clearButtonMode = UITextFieldViewMode.WhileEditing
        periodsCreditData.backgroundColor = UIColor.whiteColor()
        periodsCreditData.textColor = UIColor.blackColor()
        periodsCreditData.placeholder = "还款期数..."
        periodsCreditData.keyboardType = UIKeyboardType.NumberPad //激活时 弹出数字键盘
        periodsCreditData.becomeFirstResponder() //界面打开时就获取焦点
        periodsCreditData.returnKeyType = UIReturnKeyType.Done //表示完成输入
        self.view.addSubview(periodsCreditData)
        
        numberCreditData = UITextField(frame: CGRectMake(self.view.frame.size.width / 5 + 30, 200, self.view.frame.size.width * 2 / 3 - 20, 30))
        numberCreditData.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        numberCreditData.textAlignment = NSTextAlignment.Left
        numberCreditData.borderStyle = UITextBorderStyle.RoundedRect
        numberCreditData.clearButtonMode = UITextFieldViewMode.WhileEditing
        numberCreditData.backgroundColor = UIColor.whiteColor()
        numberCreditData.textColor = UIColor.blackColor()
        numberCreditData.placeholder = "每期金额..."
        numberCreditData.keyboardType = UIKeyboardType.DecimalPad //激活时 弹出数字键盘
        numberCreditData.returnKeyType = UIReturnKeyType.Done //表示完成输入
        self.view.addSubview(numberCreditData)
        
        dateCreditData = UITextField(frame: CGRectMake(self.view.frame.size.width / 5 + 30, 260, self.view.frame.size.width * 2 / 3 - 20, 30))
        dateCreditData.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        dateCreditData.textAlignment = NSTextAlignment.Left
        dateCreditData.borderStyle = UITextBorderStyle.RoundedRect
        dateCreditData.clearButtonMode = UITextFieldViewMode.WhileEditing
        dateCreditData.backgroundColor = UIColor.whiteColor()
        dateCreditData.textColor = UIColor.blackColor()
        dateCreditData.placeholder = "还款日期..."
        dateCreditData.keyboardType = UIKeyboardType.DecimalPad //激活时 弹出数字键盘
        dateCreditData.returnKeyType = UIReturnKeyType.Done //表示完成输入
        self.view.addSubview(dateCreditData)
        
        accountCreditData = UITextField(frame: CGRectMake(self.view.frame.size.width / 5 + 30, 320, self.view.frame.size.width * 2 / 3 - 20, 30))
        accountCreditData.textAlignment = NSTextAlignment.Left
        accountCreditData.borderStyle = UITextBorderStyle.RoundedRect
        accountCreditData.clearButtonMode = UITextFieldViewMode.WhileEditing
        accountCreditData.backgroundColor = UIColor.whiteColor()
        accountCreditData.textColor = UIColor.blackColor()
        accountCreditData.placeholder = "信用账号..."
        accountCreditData.returnKeyType = UIReturnKeyType.Done //表示完成输入
        accountCreditData.delegate = self
        self.view.addSubview(accountCreditData)
        
        let save = UIButton(frame: CGRectMake(self.view.frame.size.width / 3 - 30, 380, self.view.frame.size.width / 3 + 60, 44))
        save.layer.backgroundColor = UIColor.redColor().CGColor
        save.setTitle("保  存", forState: UIControlState.Normal)
        save.addTarget(self,action:Selector("saveCredit:"),forControlEvents:.TouchUpInside)
        self.view.addSubview(save)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool { //键盘上的完成按钮 相应事件
        //收起键盘
        textField.resignFirstResponder()
        return true
    }
    
    func setupSalaryLable(){
        let numberSalary = UILabel(frame: CGRectMake(20, 140, self.view.frame.size.width / 5 + 20, 30))
        numberSalary.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        numberSalary.textAlignment = NSTextAlignment.Left
        numberSalary.backgroundColor = UIColor.clearColor()
        numberSalary.textColor = UIColor.blackColor()
        numberSalary.text = "工资金额："
        self.view.addSubview(numberSalary)

        
        numberSalaryData = UITextField(frame: CGRectMake(self.view.frame.size.width / 5 + 30, 140, self.view.frame.size.width * 2 / 3 - 20, 30))
        numberSalaryData.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        numberSalaryData.textAlignment = NSTextAlignment.Left
        numberSalaryData.borderStyle = UITextBorderStyle.RoundedRect
        numberSalaryData.clearButtonMode = UITextFieldViewMode.WhileEditing
        numberSalaryData.backgroundColor = UIColor.whiteColor()
        numberSalaryData.textColor = UIColor.blackColor()
        numberSalaryData.placeholder = "请输入金额..."
        numberSalaryData.keyboardType = UIKeyboardType.DecimalPad //激活时 弹出数字键盘
        numberSalaryData.becomeFirstResponder() //界面打开时就获取焦点
        numberSalaryData.returnKeyType = UIReturnKeyType.Done //表示完成输入
        self.view.addSubview(numberSalaryData)
        
        let save = UIButton(frame: CGRectMake(self.view.frame.size.width / 3 - 30, 200, self.view.frame.size.width / 3 + 60, 44))
        save.layer.backgroundColor = UIColor.redColor().CGColor
        save.setTitle("保  存", forState: UIControlState.Normal)
        save.addTarget(self,action:Selector("saveSalary:"),forControlEvents:.TouchUpInside)
        self.view.addSubview(save)
    }
    
    func setupCashLable(){
        let numberUsed = UILabel(frame: CGRectMake(20, 140, self.view.frame.size.width / 5, 30))
        numberUsed.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        numberUsed.textAlignment = NSTextAlignment.Left
        numberUsed.backgroundColor = UIColor.clearColor()
        numberUsed.textColor = UIColor.blackColor()
        numberUsed.text = "金额："
        self.view.addSubview(numberUsed)
        
        let whereUsed = UILabel(frame: CGRectMake(20, 200, self.view.frame.size.width / 5, 30))
        whereUsed.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        whereUsed.textAlignment = NSTextAlignment.Left
        whereUsed.backgroundColor = UIColor.clearColor()
        whereUsed.textColor = UIColor.blackColor()
        whereUsed.text = "用处："
        self.view.addSubview(whereUsed)
        
        numberUsedData = UITextField(frame: CGRectMake(self.view.frame.size.width / 5 + 20, 140, self.view.frame.size.width * 2 / 3 - 20, 30))
        numberUsedData.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        numberUsedData.textAlignment = NSTextAlignment.Left
        numberUsedData.borderStyle = UITextBorderStyle.RoundedRect
        numberUsedData.clearButtonMode = UITextFieldViewMode.WhileEditing
        numberUsedData.backgroundColor = UIColor.whiteColor()
        numberUsedData.textColor = UIColor.blackColor()
        numberUsedData.placeholder = "请输入金额..."
        numberUsedData.keyboardType = UIKeyboardType.DecimalPad //激活时 弹出数字键盘
        numberUsedData.becomeFirstResponder() //界面打开时就获取焦点
        numberUsedData.returnKeyType = UIReturnKeyType.Done //表示完成输入
        self.view.addSubview(numberUsedData)
        
        whereUsedData = UITextField(frame: CGRectMake(self.view.frame.size.width / 5 + 20, 200, self.view.frame.size.width * 2 / 3 - 20, 30))
        whereUsedData.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        whereUsedData.textAlignment = NSTextAlignment.Left
        whereUsedData.borderStyle = UITextBorderStyle.RoundedRect
        whereUsedData.clearButtonMode = UITextFieldViewMode.WhileEditing
        whereUsedData.backgroundColor = UIColor.whiteColor()
        whereUsedData.textColor = UIColor.blackColor()
        whereUsedData.placeholder = "请输入用处..."
        whereUsedData.text = "早中晚餐"
        self.view.addSubview(whereUsedData)
        
        let save = UIButton(frame: CGRectMake(self.view.frame.size.width / 3 - 30, 260, self.view.frame.size.width / 3 + 60, 44))
        save.layer.backgroundColor = UIColor.redColor().CGColor
        save.setTitle("保  存", forState: UIControlState.Normal)
        save.addTarget(self,action:Selector("saveCash:"),forControlEvents:.TouchUpInside)
        self.view.addSubview(save)
    }
    
    @IBAction func saveCash(sender : AnyObject){
        
        if(numberUsedData.text == "" || whereUsedData.text == ""){
            textView("请输入金额和用处！")
        }else{
            if(stringIsFloat(numberUsedData.text! as String)){
                InsertCashData(whereUsedData.text!, useNumber: Float(numberUsedData.text!)!, time: getTime())
                
                let countTmp = SelectAllData(entityNameOfTotal).count
                if(countTmp == 0){
                    InsertTotaleData(0 - Float(numberUsedData.text!)!,canUse: 0 - Float(numberUsedData.text!)!)
                }else{
                    var canTmp = getCanUseToFloat()
                    canTmp = canTmp - Float(numberUsedData.text!)!
                    InsertTotaleData(getTotalToFloat() - Float(numberUsedData.text!)!,canUse: canTmp)
                }
                textView("添加成功！")
                self.navigationController?.popToRootViewControllerAnimated(true)
            }else{
                textView("请输入正确金额！")
            }
        }
    }
    
    @IBAction func saveSalary(sender : AnyObject){
        if(numberSalaryData.text == ""){
            textView("请输入内容！")
        }else{
            if(stringIsFloat(numberSalaryData.text! as String)){
                InsertSalaryData(getTime(), number: Float(numberSalaryData.text!)!)
                
                let countTmp = SelectAllData(entityNameOfTotal).count
                if(countTmp == 0){
                    let floatTmp = (Float(numberSalaryData.text!)!)
                    InsertTotaleData( floatTmp,canUse: floatTmp )
                }else{
                    var totalTmp = getTotalToFloat()
                    var canTmp = getCanUseToFloat()
                    totalTmp = totalTmp + (Float(numberSalaryData.text!)!)
                    canTmp = canTmp + (Float(numberSalaryData.text!)!)
                    InsertTotaleData(totalTmp , canUse:  canTmp)
                }
                
                textView("添加成功！")
                self.navigationController?.popToRootViewControllerAnimated(true)
            }else{
                textView("请输入正确金额！")
            }
        }
    }
    
    @IBAction func saveCredit(sender : AnyObject){
        if(periodsCreditData.text == "" || numberCreditData.text == "" ||  dateCreditData.text == "" || accountCreditData.text == ""){
            textView("请输入内容！")
        }else{
            if(stringIsInt(periodsCreditData.text! as String)){
                if(stringIsFloat(numberCreditData.text! as String)){
                    if(stringIsInt(dateCreditData.text! as String)){
                        if(Int(dateCreditData.text!) < 29 && Int(dateCreditData.text!) > 0){
                            var refundDate = NSDate()
                            let timeNow = getTime()
                            if(Int(dateCreditData.text!)! <= dateToInt(timeNow, dd: "dd")){
                                if(dateToInt(timeNow, dd: "MM") == 12){
                                    refundDate = stringToDateNoHH(String(dateToInt(timeNow, dd: "yyyy") + 1) + "-1-" + String(Int(dateCreditData.text!)!))
                                }else{
                                    refundDate = stringToDateNoHH(String(dateToInt(timeNow, dd: "yyyy")) + "-" + String(dateToInt(timeNow, dd: "MM") + 1) + "-" + String(Int(dateCreditData.text!)!))
                                }
                            }else{
                                refundDate = stringToDateNoHH(String(dateToInt(timeNow, dd: "yyyy")) + "-" + String(dateToInt(timeNow, dd: "MM")) + "-" + String(Int(dateCreditData.text!)!))
                            }
                            
                            InsertCrediData(Int(periodsCreditData.text!)!, number: Float(numberCreditData.text!)!, time: refundDate, account: accountCreditData.text!, date: Int(dateCreditData.text!)!)
                            
                            let countTmp = SelectAllData(entityNameOfTotal).count
                            if(countTmp == 0){
                                InsertTotaleData(0 - Float(periodsCreditData.text!)! * Float(numberCreditData.text!)!,canUse: 0)
                            }else{
                                let totalTmp = getTotalToFloat()
                                InsertTotaleData(totalTmp - (Float(periodsCreditData.text!)! * Float(numberCreditData.text!)!), canUse: getCanUseToFloat())
                            }
                            textView("添加成功！")
                            self.navigationController?.popToRootViewControllerAnimated(true)
                        }else{
                            textView("请输入正确还款日期！")
                        }
                    }else{
                        textView("请输入正确还款日期！")
                    }
                }else{
                    textView("请输入正确还款金额！")
                }
            }else{
                textView("请输入正确还款期数！")
            }
        }
        
    }
    
    
    func textView(str :String) ->UIAlertView{
        let alert=UIAlertView()
        alert.message=str
        alert.addButtonWithTitle("Ok")
        alert.delegate=self
        alert.show()
        return alert
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
