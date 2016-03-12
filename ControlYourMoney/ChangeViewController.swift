//
//  ChangeViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 15/12/24.
//  Copyright © 2015年 maocaiyuan. All rights reserved.
//

import UIKit
import CoreData

class ChangeViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate{
    
    var changeIndex = 0
    var nextPaydayString = String()
    var recivedData  = [NSString]()
    
    var numberUsedData = UITextField()
    var whereUsedData = UITextField()
    
    var numberSalaryData = UITextField()
    
    var nextPaydayText = UITextField()
    var periodsCreditData = UITextField()
    var numberCreditData = UITextField()
    var dateCreditData = UITextField()
    var accountCreditData = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitle()
        setUpEle()
        setUpText()
        // Do any additional setup after loading the view.
    }
    
    func setUpText(){
        periodsCreditData.text = recivedData[0] as String
        numberCreditData.text = recivedData[1] as String
        dateCreditData.text = recivedData[2] as String
        accountCreditData.text = recivedData[3] as String
        
    }
    
    func setUpTitle(){
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        self.title = "修改信用卡（电子分期）"
        
    }
    
    func setUpEle(){
        setupCreditLable()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCreditLable(){
        
        let nextPayday = UILabel(frame: CGRectMake(20, 80, self.view.frame.size.width / 5 + 20, 30))
        nextPayday.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        nextPayday.textAlignment = NSTextAlignment.Left
        nextPayday.backgroundColor = UIColor.clearColor()
        nextPayday.textColor = UIColor.blackColor()
        nextPayday.text = "下期还款："
        self.view.addSubview(nextPayday)
        
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
        
        nextPaydayText = UITextField(frame: CGRectMake(self.view.frame.size.width / 5 + 30, 80, self.view.frame.size.width * 2 / 3 - 20, 30))
        nextPaydayText.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        nextPaydayText.textAlignment = NSTextAlignment.Left
        nextPaydayText.borderStyle = UITextBorderStyle.RoundedRect
        nextPaydayText.clearButtonMode = UITextFieldViewMode.WhileEditing
        nextPaydayText.backgroundColor = UIColor.whiteColor()
        nextPaydayText.textColor = UIColor.blackColor()
        nextPaydayText.text = nextPaydayString
        nextPaydayText.enabled = false
        self.view.addSubview(nextPaydayText)
        
        periodsCreditData = UITextField(frame: CGRectMake(self.view.frame.size.width / 5 + 30, 140, self.view.frame.size.width * 2 / 3 - 20, 30))
        periodsCreditData.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        periodsCreditData.textAlignment = NSTextAlignment.Left
        periodsCreditData.borderStyle = UITextBorderStyle.RoundedRect
        periodsCreditData.clearButtonMode = UITextFieldViewMode.WhileEditing
        periodsCreditData.backgroundColor = UIColor.whiteColor()
        periodsCreditData.textColor = UIColor.blackColor()
        periodsCreditData.placeholder = "还款期数..."
        self.view.addSubview(periodsCreditData)
        
        numberCreditData = UITextField(frame: CGRectMake(self.view.frame.size.width / 5 + 30, 200, self.view.frame.size.width * 2 / 3 - 20, 30))
        numberCreditData.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        numberCreditData.textAlignment = NSTextAlignment.Left
        numberCreditData.borderStyle = UITextBorderStyle.RoundedRect
        numberCreditData.clearButtonMode = UITextFieldViewMode.WhileEditing
        numberCreditData.backgroundColor = UIColor.whiteColor()
        numberCreditData.textColor = UIColor.blackColor()
        numberCreditData.placeholder = "每期金额..."
        self.view.addSubview(numberCreditData)
        
        dateCreditData = UITextField(frame: CGRectMake(self.view.frame.size.width / 5 + 30, 260, self.view.frame.size.width * 2 / 3 - 20, 30))
        dateCreditData.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        dateCreditData.textAlignment = NSTextAlignment.Left
        dateCreditData.borderStyle = UITextBorderStyle.RoundedRect
        dateCreditData.clearButtonMode = UITextFieldViewMode.WhileEditing
        dateCreditData.backgroundColor = UIColor.whiteColor()
        dateCreditData.textColor = UIColor.blackColor()
        dateCreditData.placeholder = "还款日期..."
        self.view.addSubview(dateCreditData)
        
        accountCreditData = UITextField(frame: CGRectMake(self.view.frame.size.width / 5 + 30, 320, self.view.frame.size.width * 2 / 3 - 20, 30))
        accountCreditData.textAlignment = NSTextAlignment.Left
        accountCreditData.borderStyle = UITextBorderStyle.RoundedRect
        accountCreditData.clearButtonMode = UITextFieldViewMode.WhileEditing
        accountCreditData.backgroundColor = UIColor.whiteColor()
        accountCreditData.textColor = UIColor.blackColor()
        accountCreditData.placeholder = "信用账号..."
        accountCreditData.returnKeyType = UIReturnKeyType.Done //表示完成输入
        accountCreditData.delegate=self
        self.view.addSubview(accountCreditData)
        
        let save = UIButton(frame: CGRectMake(20, 380, self.view.frame.size.width - 40, 44))
        save.layer.backgroundColor = UIColor.redColor().CGColor
        save.setTitle("保  存", forState: UIControlState.Normal)
        save.layer.cornerRadius = 3
        save.addTarget(self,action:Selector("saveCredit:"),forControlEvents:.TouchUpInside)
        self.view.addSubview(save)
        
        let alreadyPay = UIButton(frame: CGRectMake(20, 440, self.view.frame.size.width - 40, 44))
        alreadyPay.layer.backgroundColor = UIColor.redColor().CGColor
        alreadyPay.setTitle("本月已还", forState: UIControlState.Normal)
        alreadyPay.layer.cornerRadius = 3
        alreadyPay.addTarget(self,action:Selector("alreadyPay:"),forControlEvents:.TouchUpInside)
        self.view.addSubview(alreadyPay)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool { //键盘上的完成按钮 相应事件
        //收起键盘
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func alreadyPay(sender : AnyObject){
        if(periodsCreditData.text == "" || numberCreditData.text == "" ||  dateCreditData.text == "" || accountCreditData.text == ""){
            textView("请输入内容！")
        }else{
            if(stringIsInt(periodsCreditData.text! as String)){
                if(stringIsFloat(numberCreditData.text! as String)){
                    if(stringIsInt(dateCreditData.text! as String)){
                        if(Int(dateCreditData.text!) < 29 && Int(dateCreditData.text!) > 0){
                            
                            var refundDate = NSDate()
                            let payDay = stringToDateNoHH(nextPaydayString)
                            
                            if(dateToInt(payDay, dd: "MM") == 12){
                                refundDate = stringToDateNoHH(String(dateToInt(payDay, dd: "yyyy") + 1) + "-1-" + String(Int(dateCreditData.text!)!))
                            }else{
                                refundDate = stringToDateNoHH(String(dateToInt(payDay, dd: "yyyy")) + "-" + String(dateToInt(payDay, dd: "MM") + 1) + "-" + String(Int(dateCreditData.text!)!))
                            }
                            
                            if(Int(periodsCreditData.text!)! > 1){
                                UpdateCreditDataSortedByTime(changeIndex ,periods: Int(periodsCreditData.text!)!-1, number: Float(numberCreditData.text!)!,date: Int(dateCreditData.text!)!, account: accountCreditData.text!,time: refundDate)
                            }else{
                                DeleteData(entityNameOfCredit, indexPath: changeIndex)
                            }
                            
                            let totalTmp = getTotalToFloat()
                            InsertTotaleData(totalTmp, canUse: getCanUseToFloat() - Float(numberCreditData.text!)!)
                            
                            
                            textView("还款成功！")
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
                            
                            UpdateCreditDataSortedByTime(changeIndex ,periods: Int(periodsCreditData.text!)!, number: Float(numberCreditData.text!)!,date: Int(dateCreditData.text!)!, account: accountCreditData.text!,time: refundDate)
                            
                            let countTmp = SelectAllData(entityNameOfTotal).count
                            if(countTmp == 0){
                                InsertTotaleData(0 - Float(periodsCreditData.text!)! * Float(numberCreditData.text!)!,canUse: 0)
                            }else{
                                let totalTmp = getTotalToFloat()
                                InsertTotaleData(totalTmp + Float(recivedData[0] as String)! * Float(recivedData[1] as String)! - (Float(periodsCreditData.text!)! * Float(numberCreditData.text!)!), canUse: getCanUseToFloat())
                            }
                            textView("修改成功！")
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
