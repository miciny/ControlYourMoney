//
//  AddCreditViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/3/12.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class AddCreditViewController: UIViewController , UITextFieldDelegate, UITextViewDelegate{
    var periodsCreditData = UITextField()
    var numberCreditData = UITextField()
    var dateCreditData = UITextField()
    var accountCreditData = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        self.title = "添加信用卡（电子分期）"
        
        setupCreditLable()

        // Do any additional setup after loading the view.
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

    @IBAction func saveCredit(sender : AnyObject){
        if(periodsCreditData.text == "" || numberCreditData.text == "" ||  dateCreditData.text == "" || accountCreditData.text == ""){
            textView("请输入内容！")
        }else{
            if(stringIsInt(periodsCreditData.text! as String) && Int(periodsCreditData.text!)!>0){
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
                                InsertTotaleData(0, time: getTime())
                            }else{
                                InsertTotaleData(getCanUseToFloat(), time: getTime())
                            }
                            showToast().showToast("添加成功！")
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
    
    func textView(str :String){
        let alert=UIAlertView()
        alert.message=str
        alert.addButtonWithTitle("Ok")
        alert.delegate=self
        alert.show()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool { //键盘上的完成按钮 相应事件
        //收起键盘
        textField.resignFirstResponder()
        return true
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
