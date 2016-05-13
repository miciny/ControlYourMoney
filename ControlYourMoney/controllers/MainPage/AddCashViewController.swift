//
//  AddCashViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/3/12.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class AddCashViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    var numberUsedData = UITextField()
    var whereUsedData = UITextField()
    var isCreditCheck: UIButton! //

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "现金记账"
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)

        setupCashLable()
    }
    
    func setupCashLable(){
        let gap = CGFloat(10)
        
        let numberUsedSize = sizeWithText("金额：", font: introduceFont, maxSize: CGSizeMake(self.view.frame.width/2, 30))
        let numberUsed = UILabel(frame: CGRectMake(20, 90, numberUsedSize.width, 30))
        numberUsed.font = introduceFont
        numberUsed.textAlignment = NSTextAlignment.Left
        numberUsed.backgroundColor = UIColor.clearColor()
        numberUsed.textColor = UIColor.blackColor()
        numberUsed.text = "金额："
        self.view.addSubview(numberUsed)
        
        let whereUsed = UILabel(frame: CGRectMake(20, numberUsed.frame.maxY+gap, numberUsedSize.width, 30))
        whereUsed.font = introduceFont
        whereUsed.textAlignment = NSTextAlignment.Left
        whereUsed.backgroundColor = UIColor.clearColor()
        whereUsed.textColor = UIColor.blackColor()
        whereUsed.text = "用处："
        self.view.addSubview(whereUsed)
        
        isCreditCheck = UIButton(type: UIButtonType.Custom)
        isCreditCheck.frame = CGRect(x: 20, y: whereUsed.frame.maxY+gap+5, width: 20, height: 20)
        isCreditCheck.setImage(UIImage(named: "CheckOff"), forState:UIControlState.Normal)
        isCreditCheck.setImage(UIImage(named: "CheckOn"), forState:UIControlState.Selected)
        isCreditCheck.addTarget(self, action: #selector(AddCashViewController.isCreditSeleted), forControlEvents:.TouchUpInside)
        isCreditCheck.selected = false
        self.view.addSubview(isCreditCheck)
        let size1 = sizeWithText("信用账号", font: introduceFont, maxSize: CGSizeMake(Width, 30))
        let isCreditCheckButtonText = UILabel(frame: CGRect(x: isCreditCheck.frame.maxX+10, y: isCreditCheck.frame.minY-5, width: size1.width, height: 30))
        isCreditCheckButtonText.text = "信用账号"
        isCreditCheckButtonText.textAlignment = NSTextAlignment.Left
        isCreditCheckButtonText.font = introduceFont
        isCreditCheckButtonText.textColor = UIColor.blackColor()
        isCreditCheckButtonText.userInteractionEnabled = true //打开点击事件
        let tap1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddCashViewController.isCreditSeleted))
        isCreditCheckButtonText.addGestureRecognizer(tap1)
        self.view.addSubview(isCreditCheckButtonText)
        
        self.numberUsedData = UITextField(frame: CGRectMake(numberUsed.frame.maxX, numberUsed.frame.minY, self.view.frame.size.width-numberUsed.frame.maxX-20, 30))
        self.numberUsedData.font = introduceFont
        self.numberUsedData.textAlignment = NSTextAlignment.Left
        self.numberUsedData.borderStyle = UITextBorderStyle.RoundedRect
        self.numberUsedData.clearButtonMode = UITextFieldViewMode.WhileEditing
        self.numberUsedData.backgroundColor = UIColor.whiteColor()
        self.numberUsedData.textColor = UIColor.blackColor()
        self.numberUsedData.placeholder = "请输入金额..."
        self.numberUsedData.keyboardType = UIKeyboardType.DecimalPad //激活时 弹出数字键盘
        self.numberUsedData.becomeFirstResponder() //界面打开时就获取焦点
        self.numberUsedData.returnKeyType = UIReturnKeyType.Done //表示完成输入
        self.view.addSubview(self.numberUsedData)
        
        self.whereUsedData = UITextField(frame: CGRectMake(whereUsed.frame.maxX, whereUsed.frame.minY, self.view.frame.size.width-whereUsed.frame.maxX-20, 30))
        self.whereUsedData.font = introduceFont
        self.whereUsedData.textAlignment = NSTextAlignment.Left
        self.whereUsedData.borderStyle = UITextBorderStyle.RoundedRect
        self.whereUsedData.clearButtonMode = UITextFieldViewMode.WhileEditing
        self.whereUsedData.backgroundColor = UIColor.whiteColor()
        self.whereUsedData.textColor = UIColor.blackColor()
        self.whereUsedData.placeholder = "请输入用处..."
        self.whereUsedData.text = "早中晚餐"
        self.view.addSubview(self.whereUsedData)
        
        let save = UIButton(frame: CGRectMake(20, isCreditCheck.frame.maxY+gap*3, self.view.frame.size.width - 40, 44))
        save.layer.backgroundColor = UIColor.redColor().CGColor
        save.layer.cornerRadius = 3
        save.setTitle("保  存", forState: UIControlState.Normal)
        save.addTarget(self,action: #selector(saveCash),forControlEvents:.TouchUpInside)
        self.view.addSubview(save)
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
            SQLLine.insertCashData(self.whereUsedData.text!, useNumber: Float(self.numberUsedData.text!)!, time: getTime())
            
            let countTmp = SQLLine.selectAllData(entityNameOfTotal).count
            if(countTmp == 0){
                SQLLine.insertTotalData(0 - Float(self.numberUsedData.text!)!, time: getTime())
            }else{
                var canTmp = getCanUseToFloat()
                canTmp = canTmp - Float(self.numberUsedData.text!)!
                SQLLine.insertTotalData(canTmp, time: getTime())
            }
            MyToastView().showToast("添加成功！")
            self.navigationController?.popToRootViewControllerAnimated(true)
        }else{
            var isIn = false
            var index = 0
            let timeNow = getTime()
            var account = String()
            
            if(myOwnAccountBillDay <= dateToInt(timeNow, dd: "dd")){
                account = myOwnAccount + String(dateToInt(timeNow, dd: "MM")+1)
            }else{
                account = myOwnAccount + String(dateToInt(timeNow, dd: "MM"))
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
                if(myOwnAccountBillDay <= dateToInt(timeNow, dd: "dd")){
                    if(dateToInt(timeNow, dd: "MM") == 12){
                        refundDate = stringToDateNoHH(String(dateToInt(timeNow, dd: "yyyy") + 1) + "-1-" + String(myOwnAccountPayDay))
                    }else{
                        refundDate = stringToDateNoHH(String(dateToInt(timeNow, dd: "yyyy")) + "-" + String(dateToInt(timeNow, dd: "MM") + 1) + "-" + String(myOwnAccountPayDay))
                    }
                }else{
                    refundDate = stringToDateNoHH(String(dateToInt(timeNow, dd: "yyyy")) + "-" + String(dateToInt(timeNow, dd: "MM")) + "-" + String(myOwnAccountPayDay))
                }
                
                SQLLine.insertCrediData(1, number: Float(numberUsedData.text!)!, time: refundDate, account: account, date: myOwnAccountPayDay)
            }else{
                let oldNumber = creditArray[index].valueForKey(creditNameOfNumber) as! Float
                SQLLine.updateCreditData(index, changeValue: oldNumber+Float(numberUsedData.text!)!, changeEntityName: creditNameOfNumber)
               
            }
            
            //更新时间
            let countTmp = SQLLine.selectAllData(entityNameOfTotal).count
            if(countTmp == 0){
                SQLLine.insertTotalData(0, time: getTime())
            }else{
                SQLLine.insertTotalData(getCanUseToFloat(), time: getTime())
            }
            MyToastView().showToast("添加成功！")
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        
    }
    
    func isCreditSeleted(){
        isCreditCheck.selected = !isCreditCheck.selected
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
