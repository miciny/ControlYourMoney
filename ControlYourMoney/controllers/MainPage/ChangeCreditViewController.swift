//
//  ChangeViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 15/12/24.
//  Copyright © 2015年 maocaiyuan. All rights reserved.
//

import UIKit
import CoreData
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class ChangeCreditViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate{
    
    var changeIndex = 0 //改变的数据，在数据库的位置
    var nextPaydayString = String() //下期还款的时间
    var recivedData: MainTableCreditModul! //列表点击的，传进来的数据
    
    //六个输入框
    var whereUsedData = UITextField()
    var numberSalaryData = UITextField()
    var nextPaydayText = UITextField()
    var periodsCreditData = UITextField()
    var numberCreditData = UITextField()
    var dateCreditData = UITextField()
    
    //两个选择label
    var accountCreditData = UILabel() //账户
    var typeData = UILabel() //支出类型
    
    //三个按钮
    var save = UIButton() //保存按钮
    var alreadyPay = UIButton() //本月已还
    var alreadyPayAll = UIButton() //全部已还
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTitle()
        self.setupCreditLable()
        self.setUpText()
    }
    
    //设置显示的数据
    func setUpText(){
        self.periodsCreditData.text = self.recivedData.periods
        self.numberCreditData.text = self.recivedData.number
        self.dateCreditData.text = self.recivedData.date
        self.accountCreditData.text = self.recivedData.account
        self.typeData.text = self.recivedData.type
        
        if Int(self.recivedData.periods) <= 0 {
            save.isEnabled = false
            alreadyPay.isEnabled = false
            alreadyPayAll.isEnabled = false
            
            save.backgroundColor = UIColor.lightGray
            alreadyPay.backgroundColor = UIColor.lightGray
            alreadyPayAll.backgroundColor = UIColor.lightGray
        }
    }
    
    //设置title
    func setUpTitle(){
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        self.title = "修改信用卡（电子分期）"
        
        self.nextPaydayString = self.recivedData.time
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //设置页面元素
    func setupCreditLable(){
        let gap = CGFloat(10)
        
        //六个label
        let nextPaydaySize = sizeWithText("下期还款：", font: introduceFont, maxSize: CGSize(width: Width, height: 30))
        let nextPayday = UILabel.introduceLabel()
        nextPayday.frame = CGRect(x: 20, y: 90, width: nextPaydaySize.width, height: 30)
        nextPayday.text = "下期还款："
        self.view.addSubview(nextPayday)
        
        let periodsCredit = UILabel.introduceLabel()
        periodsCredit.frame = CGRect(x: 20, y: nextPayday.frame.maxY+gap, width: nextPaydaySize.width, height: 30)
        periodsCredit.text = "还款期数："
        self.view.addSubview(periodsCredit)
        
        let numberCredit = UILabel.introduceLabel()
        numberCredit.frame = CGRect(x: 20, y: periodsCredit.frame.maxY+gap, width: nextPaydaySize.width, height: 30)
        numberCredit.text = "每期金额："
        self.view.addSubview(numberCredit)
        
        let dateCredit = UILabel.introduceLabel()
        dateCredit.frame = CGRect(x: 20, y: numberCredit.frame.maxY+gap, width: nextPaydaySize.width, height: 30)
        dateCredit.text = "还款日期："
        self.view.addSubview(dateCredit)
        
        let account = UILabel.introduceLabel()
        account.frame = CGRect(x: 20, y: dateCredit.frame.maxY+gap, width: nextPaydaySize.width, height: 30)
        account.text = "信用账户："
        self.view.addSubview(account)
        
        let type = UILabel.introduceLabel()
        type.frame = CGRect(x: 20, y: account.frame.maxY+gap, width: nextPaydaySize.width, height: 30)
        type.text = "支出类型："
        self.view.addSubview(type)
        
        //四个输入框
        self.nextPaydayText = UITextField.inputTextField()
        self.nextPaydayText.frame = CGRect(x: nextPayday.frame.maxX, y: nextPayday.frame.minY, width: self.view.frame.size.width-nextPayday.frame.maxX-20, height: 30)
        self.nextPaydayText.text = self.nextPaydayString
        self.view.addSubview(self.nextPaydayText)
        self.nextPaydayText.isEnabled = false
        
        self.periodsCreditData = UITextField.inputTextField()
        self.periodsCreditData.frame = CGRect(x: periodsCredit.frame.maxX, y: periodsCredit.frame.minY, width: self.view.frame.size.width-periodsCredit.frame.maxX-20, height: 30)
        self.periodsCreditData.placeholder = "还款期数..."
        self.view.addSubview(self.periodsCreditData)
        
        self.numberCreditData = UITextField.inputTextField()
        self.numberCreditData.frame = CGRect(x: numberCredit.frame.maxX, y: numberCredit.frame.minY, width: self.view.frame.size.width-numberCredit.frame.maxX-20, height: 30)
        self.numberCreditData.placeholder = "每期金额..."
        self.view.addSubview(self.numberCreditData)
        
        self.dateCreditData = UITextField.inputTextField()
        self.dateCreditData.frame = CGRect(x: dateCredit.frame.maxX, y: dateCredit.frame.minY, width: self.view.frame.size.width-dateCredit.frame.maxX-20, height: 30)
        self.dateCreditData.placeholder = "还款日期..."
        self.view.addSubview(dateCreditData)
        
        //两个选择label
        self.accountCreditData = UILabel.inputLabel()
        self.accountCreditData.frame = CGRect(x: account.frame.maxX, y: account.frame.minY, width: self.view.frame.size.width-account.frame.maxX-20, height: 30)
        self.view.addSubview(self.accountCreditData)
        
        self.typeData = UILabel.inputLabel()
        self.typeData.frame = CGRect(x: type.frame.maxX, y: type.frame.minY, width: self.view.frame.size.width-type.frame.maxX-20, height: 30)
        self.view.addSubview(self.typeData)
        
        //四个按钮
        save = UIButton(frame: CGRect(x: 20, y: type.frame.maxY+gap*3, width: self.view.frame.size.width - 40, height: 44))
        save.layer.backgroundColor = UIColor.red.cgColor
        save.setTitle("保  存", for: UIControlState())
        save.layer.cornerRadius = 3
        save.addTarget(self,action:#selector(ChangeCreditViewController.saveCredit),for:.touchUpInside)
        self.view.addSubview(save)
        
        alreadyPay = UIButton(frame: CGRect(x: 20, y: save.frame.maxY+gap, width: self.view.frame.size.width - 40, height: 44))
        alreadyPay.layer.backgroundColor = UIColor.red.cgColor
        alreadyPay.setTitle("本月已还", for: UIControlState())
        alreadyPay.layer.cornerRadius = 3
        alreadyPay.addTarget(self,action:#selector(ChangeCreditViewController.alreadyPayCredit),for:.touchUpInside)
        self.view.addSubview(alreadyPay)
        
        alreadyPayAll = UIButton(frame: CGRect(x: 20, y: alreadyPay.frame.maxY+gap, width: self.view.frame.size.width - 40, height: 44))
        alreadyPayAll.layer.backgroundColor = UIColor.red.cgColor
        alreadyPayAll.setTitle("全部已还", for: UIControlState())
        alreadyPayAll.layer.cornerRadius = 3
        alreadyPayAll.addTarget(self,action:#selector(ChangeCreditViewController.alreadyPayAllCredit),for:.touchUpInside)
        self.view.addSubview(alreadyPayAll)
        
        let deleteBtn = UIButton(frame: CGRect(x: 20, y: alreadyPayAll.frame.maxY+gap, width: self.view.frame.size.width - 40, height: 44))
        deleteBtn.layer.backgroundColor = UIColor.red.cgColor
        deleteBtn.setTitle("删   除", for: UIControlState())
        deleteBtn.layer.cornerRadius = 3
        deleteBtn.addTarget(self,action:#selector(ChangeCreditViewController.deleteBtnClicked),for:.touchUpInside)
        self.view.addSubview(deleteBtn)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { //键盘上的完成按钮 相应事件
        //收起键盘
        textField.resignFirstResponder()
        return true
    }
    
    //已还全部
    func alreadyPayAllCredit(){
        let alert = UIAlertView(title: "是否确认全部还完？", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alert.tag = 1
        alert.show()
    }
    
    //删除
    func deleteBtnClicked(){
        let alert = UIAlertView(title: "是否确认删除？", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alert.tag = 2
        alert.show()
    }

    //已还本月
    func alreadyPayCredit(){
        
        if !checkData(){
            return
        }
        
        let alert = UIAlertView(title: "是否确认本月已还？", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alert.tag = 3
        alert.show()
    }
    
    //重新保存
    func saveCredit(){

        if !checkData(){
        return
        }
        
        let alert = UIAlertView(title: "是否确认重新保存？", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alert.tag = 4
        alert.show()
    }
    
    //确认框的代理
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        switch alertView.tag {
        case 1:  //全部还完
            if buttonIndex == 1 {
                payAll()
            }
        case 2:  //删除
            if buttonIndex == 1 {
                deleteCredit()
            }
        case 3: //本月已还
            if buttonIndex == 1 {
                payThisMonth()
            }
        case 4: //重新保存
            if buttonIndex == 1 {
                reSave()
            }
        default:
            break
        }
    }
    
    //重新保存
    func reSave(){
        let timeNow = getTime()
        let date = Int(dateCreditData.text!)!
        let nextPayDay = CalculateCredit.getFirstPayDate(timeNow, day: date)
        let periods = Int(periodsCreditData.text!)!
        Credit.updateCreditDataSortedByTime(changeIndex ,periods: periods, number: Float(numberCreditData.text!)!,date: date, account: accountCreditData.text!,time: getTime(), nextPayDay: nextPayDay, leftPeriods: periods, type: recivedData.type)
        
        MyToastView().showToast("修改成功！")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //本月已还
    func payThisMonth(){
        let periods = Int(recivedData.periods)!-1
        Credit.updateCreditDataSortedByTime(changeIndex, changeValue: periods, changeFieldName: creditNameOfLeftPeriods)
        
        //如果剩余周期为0 了 就不保存下期还款时间了
        if periods > 0 {
            let thisPayDay = stringToDateNoHH(recivedData.time)
            let nextPayDay = CalculateCredit.calculateTime(thisPayDay, months: 1)
            //由于按nextPayDay排序，必须先保存周期
            
            Credit.updateCreditDataSortedByTime(changeIndex, changeValue: nextPayDay, changeFieldName: creditNameOfNextPayDay)
        }
        
        Total.insertTotalData(GetAnalyseData.getCanUseToFloat() - Float(recivedData.number)!, time: getTime())
        MyToastView().showToast("还款成功！")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //删除，不需要改变余额
    func deleteCredit(){
        
        Credit.deleteCreditDataSortedByTime(changeIndex)
        MyToastView().showToast("删除成功！")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //全部还款，需要改变剩余额度
    func payAll(){
        Total.insertTotalData(GetAnalyseData.getCanUseToFloat() - Float(recivedData.number)! * Float(recivedData.periods)!, time: getTime())
        
        let nextTime = stringToDateNoHH(recivedData.time)
        let nextPayDay = CalculateCredit.getLastPayDate(nextTime, leftPeriods: Int(recivedData.periods)!-1)
        let periods = 0
        
        //由于按nextPayDay排序，必须先保存周期
        Credit.updateCreditDataSortedByTime(changeIndex, changeValue: periods, changeFieldName: creditNameOfLeftPeriods)
        Credit.updateCreditDataSortedByTime(changeIndex, changeValue: nextPayDay, changeFieldName: creditNameOfNextPayDay)
        
        MyToastView().showToast("还款成功！")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //检查输入的数据
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
