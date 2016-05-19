//
//  ChangeViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 15/12/24.
//  Copyright © 2015年 maocaiyuan. All rights reserved.
//

import UIKit
import CoreData

class ChangeCreditViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate{
    
    var changeIndex = 0
    var nextPaydayString = String()
    var recivedData: MainTableCreditModul!
    
    var numberUsedData = UITextField()
    var whereUsedData = UITextField()
    
    var numberSalaryData = UITextField()
    
    var nextPaydayText = UITextField()
    var periodsCreditData = UITextField()
    var numberCreditData = UITextField()
    var dateCreditData = UITextField()
    var accountCreditData = UILabel()
    var typeData = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTitle()
        self.setupCreditLable()
        self.setUpText()
    }
    
    func setUpText(){
        self.periodsCreditData.text = self.recivedData.periods
        self.numberCreditData.text = self.recivedData.number
        self.dateCreditData.text = self.recivedData.date
        self.accountCreditData.text = self.recivedData.account
        self.typeData.text = self.recivedData.type
    }
    
    func setUpTitle(){
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        self.title = "修改信用卡（电子分期）"
        
        self.nextPaydayString = self.recivedData.time
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCreditLable(){
        let gap = CGFloat(10)
        let nextPaydaySize = sizeWithText("下期还款：", font: introduceFont, maxSize: CGSizeMake(Width, 30))
        let nextPayday = UILabel(frame: CGRectMake(20, 90, nextPaydaySize.width, 30))
        nextPayday.font = introduceFont
        nextPayday.textAlignment = NSTextAlignment.Left
        nextPayday.backgroundColor = UIColor.clearColor()
        nextPayday.textColor = UIColor.blackColor()
        nextPayday.text = "下期还款："
        self.view.addSubview(nextPayday)
        
        let periodsCredit = UILabel(frame: CGRectMake(20, nextPayday.frame.maxY+gap, nextPaydaySize.width, 30))
        periodsCredit.font = introduceFont
        periodsCredit.textAlignment = NSTextAlignment.Left
        periodsCredit.backgroundColor = UIColor.clearColor()
        periodsCredit.textColor = UIColor.blackColor()
        periodsCredit.text = "还款期数："
        self.view.addSubview(periodsCredit)
        
        let numberCredit = UILabel(frame: CGRectMake(20, periodsCredit.frame.maxY+gap, nextPaydaySize.width, 30))
        numberCredit.font = introduceFont
        numberCredit.textAlignment = NSTextAlignment.Left
        numberCredit.backgroundColor = UIColor.clearColor()
        numberCredit.textColor = UIColor.blackColor()
        numberCredit.text = "每期金额："
        self.view.addSubview(numberCredit)
        
        let dateCredit = UILabel(frame: CGRectMake(20, numberCredit.frame.maxY+gap, nextPaydaySize.width, 30))
        dateCredit.font = introduceFont
        dateCredit.textAlignment = NSTextAlignment.Left
        dateCredit.backgroundColor = UIColor.clearColor()
        dateCredit.textColor = UIColor.blackColor()
        dateCredit.text = "还款日期："
        self.view.addSubview(dateCredit)
        
        let account = UILabel(frame: CGRectMake(20, dateCredit.frame.maxY+gap, nextPaydaySize.width, 30))
        account.font = introduceFont
        account.textAlignment = NSTextAlignment.Left
        account.backgroundColor = UIColor.clearColor()
        account.textColor = UIColor.blackColor()
        account.text = "信用账户："
        self.view.addSubview(account)
        
        let type = UILabel(frame: CGRectMake(20, account.frame.maxY+gap, nextPaydaySize.width, 30))
        type.font = introduceFont
        type.textAlignment = NSTextAlignment.Left
        type.backgroundColor = UIColor.clearColor()
        type.textColor = UIColor.blackColor()
        type.text = "支出类型："
        self.view.addSubview(type)
        
        self.nextPaydayText = UITextField(frame: CGRectMake(nextPayday.frame.maxX, nextPayday.frame.minY, self.view.frame.size.width-nextPayday.frame.maxX-20, 30))
        self.nextPaydayText.font = introduceFont
        self.nextPaydayText.textAlignment = NSTextAlignment.Left
        self.nextPaydayText.borderStyle = UITextBorderStyle.RoundedRect
        self.nextPaydayText.clearButtonMode = UITextFieldViewMode.WhileEditing
        self.nextPaydayText.backgroundColor = UIColor.whiteColor()
        self.nextPaydayText.textColor = UIColor.blackColor()
        self.nextPaydayText.text = self.nextPaydayString
        self.view.addSubview(self.nextPaydayText)
        self.nextPaydayText.enabled = false
        
        self.periodsCreditData = UITextField(frame: CGRectMake(periodsCredit.frame.maxX, periodsCredit.frame.minY, self.view.frame.size.width-periodsCredit.frame.maxX-20, 30))
        self.periodsCreditData.font = introduceFont
        self.periodsCreditData.textAlignment = NSTextAlignment.Left
        self.periodsCreditData.borderStyle = UITextBorderStyle.RoundedRect
        self.periodsCreditData.clearButtonMode = UITextFieldViewMode.WhileEditing
        self.periodsCreditData.backgroundColor = UIColor.whiteColor()
        self.periodsCreditData.textColor = UIColor.blackColor()
        self.periodsCreditData.placeholder = "还款期数..."
        self.view.addSubview(self.periodsCreditData)
        
        self.numberCreditData = UITextField(frame: CGRectMake(numberCredit.frame.maxX, numberCredit.frame.minY, self.view.frame.size.width-numberCredit.frame.maxX-20, 30))
        self.numberCreditData.font = introduceFont
        self.numberCreditData.textAlignment = NSTextAlignment.Left
        self.numberCreditData.borderStyle = UITextBorderStyle.RoundedRect
        self.numberCreditData.clearButtonMode = UITextFieldViewMode.WhileEditing
        self.numberCreditData.backgroundColor = UIColor.whiteColor()
        self.numberCreditData.textColor = UIColor.blackColor()
        self.numberCreditData.placeholder = "每期金额..."
        self.view.addSubview(self.numberCreditData)
        
        self.dateCreditData = UITextField(frame: CGRectMake(dateCredit.frame.maxX, dateCredit.frame.minY, self.view.frame.size.width-dateCredit.frame.maxX-20, 30))
        self.dateCreditData.font = introduceFont
        self.dateCreditData.textAlignment = NSTextAlignment.Left
        self.dateCreditData.borderStyle = UITextBorderStyle.RoundedRect
        self.dateCreditData.clearButtonMode = UITextFieldViewMode.WhileEditing
        self.dateCreditData.backgroundColor = UIColor.whiteColor()
        self.dateCreditData.textColor = UIColor.blackColor()
        self.dateCreditData.placeholder = "还款日期..."
        self.view.addSubview(dateCreditData)
        
        self.accountCreditData = UILabel(frame: CGRectMake(account.frame.maxX, account.frame.minY, self.view.frame.size.width-account.frame.maxX-20, 30))
        self.accountCreditData.textAlignment = NSTextAlignment.Left
        self.accountCreditData.backgroundColor = UIColor.whiteColor()
        self.accountCreditData.textColor = UIColor.blackColor()
        self.accountCreditData.layer.masksToBounds = true
        self.accountCreditData.layer.cornerRadius = 3
        self.view.addSubview(self.accountCreditData)
        
        self.typeData = UILabel(frame: CGRectMake(type.frame.maxX, type.frame.minY, self.view.frame.size.width-type.frame.maxX-20, 30))
        self.typeData.textAlignment = NSTextAlignment.Left
        self.typeData.backgroundColor = UIColor.whiteColor()
        self.typeData.textColor = UIColor.blackColor()
        self.typeData.layer.masksToBounds = true
        self.typeData.layer.cornerRadius = 3
        self.view.addSubview(self.typeData)
        
        let save = UIButton(frame: CGRectMake(20, type.frame.maxY+gap*3, self.view.frame.size.width - 40, 44))
        save.layer.backgroundColor = UIColor.redColor().CGColor
        save.setTitle("保  存", forState: UIControlState.Normal)
        save.layer.cornerRadius = 3
        save.addTarget(self,action:#selector(ChangeCreditViewController.saveCredit),forControlEvents:.TouchUpInside)
        self.view.addSubview(save)
        
        let alreadyPay = UIButton(frame: CGRectMake(20, save.frame.maxY+gap, self.view.frame.size.width - 40, 44))
        alreadyPay.layer.backgroundColor = UIColor.redColor().CGColor
        alreadyPay.setTitle("本月已还", forState: UIControlState.Normal)
        alreadyPay.layer.cornerRadius = 3
        alreadyPay.addTarget(self,action:#selector(ChangeCreditViewController.alreadyPay),forControlEvents:.TouchUpInside)
        self.view.addSubview(alreadyPay)
        
        let alreadyPayAll = UIButton(frame: CGRectMake(20, alreadyPay.frame.maxY+gap, self.view.frame.size.width - 40, 44))
        alreadyPayAll.layer.backgroundColor = UIColor.redColor().CGColor
        alreadyPayAll.setTitle("全部已还", forState: UIControlState.Normal)
        alreadyPayAll.layer.cornerRadius = 3
        alreadyPayAll.addTarget(self,action:#selector(ChangeCreditViewController.alreadyPayAll),forControlEvents:.TouchUpInside)
        self.view.addSubview(alreadyPayAll)
        
        let deleteBtn = UIButton(frame: CGRectMake(20, alreadyPayAll.frame.maxY+gap, self.view.frame.size.width - 40, 44))
        deleteBtn.layer.backgroundColor = UIColor.redColor().CGColor
        deleteBtn.setTitle("删除", forState: UIControlState.Normal)
        deleteBtn.layer.cornerRadius = 3
        deleteBtn.addTarget(self,action:#selector(ChangeCreditViewController.deleteBtnClicked),forControlEvents:.TouchUpInside)
        self.view.addSubview(deleteBtn)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool { //键盘上的完成按钮 相应事件
        //收起键盘
        textField.resignFirstResponder()
        return true
    }
    
    func alreadyPayAll(){
        
        SQLLine.insertTotalData(GetAnalyseData.getCanUseToFloat() - Float(recivedData.number)! * Float(recivedData.periods)!, time: getTime())
        
        SQLLine.deleteCreditDataSortedByTime(changeIndex)
        MyToastView().showToast("还款成功！")
        self.navigationController?.popToRootViewControllerAnimated(true)

    }
    
    func deleteBtnClicked(){
        SQLLine.deleteCreditDataSortedByTime(changeIndex)
        MyToastView().showToast("删除成功！")
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    //已还
    func alreadyPay(){
        if !checkData(){
            return
        }
        let thisPayDay = stringToDateNoHH(recivedData.time)
        let nextPayDay = CalculateCredit.calculateTime(thisPayDay, months: 1)
        let periods = Int(recivedData.periods)!-1
        
        //由于按nextPayDay排序，必须先保存周期
        SQLLine.updateCreditDataSortedByTime(changeIndex, changeValue: periods, changeEntityName: creditNameOfLeftPeriods)
        SQLLine.updateCreditDataSortedByTime(changeIndex, changeValue: nextPayDay, changeEntityName: creditNameOfNextPayDay)
        
        SQLLine.insertTotalData(GetAnalyseData.getCanUseToFloat() - Float(recivedData.number)!, time: getTime())
        MyToastView().showToast("还款成功！")
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    //重新保存
    func saveCredit(){
        
        if !checkData(){
            return
        }
        let timeNow = getTime()
        let date = Int(dateCreditData.text!)!
        let nextPayDay = CalculateCredit.getFirstPayDate(timeNow, day: date)
        let periods = Int(periodsCreditData.text!)!
        SQLLine.updateCreditDataSortedByTime(changeIndex ,periods: periods, number: Float(numberCreditData.text!)!,date: date, account: accountCreditData.text!,time: getTime(), nextPayDay: nextPayDay, leftPeriods: periods, type: "")
        
        MyToastView().showToast("修改成功！")
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    func checkData() -> Bool{
        
        if(periodsCreditData.text == "" || numberCreditData.text == "" ||  dateCreditData.text == "" || accountCreditData.text == ""){
            textAlertView("请输入内容！")
            return false
        }
        
        if(!stringIsInt(periodsCreditData.text! as String) || Int(periodsCreditData.text!)! <= 0 ){
            textAlertView("请输入正确还款期数！")
            return false
        }
        
        if(!stringIsFloat(numberCreditData.text! as String)){
            textAlertView("请输入正确还款金额！")
            return false
        }
        
        if(!stringIsInt(dateCreditData.text! as String)){
            textAlertView("请输入正确还款日期！")
            return false
        }
        
        if(Int(dateCreditData.text!) >= 29 || Int(dateCreditData.text!) <= 0){
            textAlertView("请输入正确还款日期！")
            return false
        }
        
        return true
    }
}
