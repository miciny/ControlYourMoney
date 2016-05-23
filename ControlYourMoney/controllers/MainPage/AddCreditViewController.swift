//
//  AddCreditViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/3/12.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class AddCreditViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate, accountListViewDelegate, costNameListViewDelegate{
    
    var periodsCreditData = UITextField()
    var numberCreditData = UITextField()
    var dateCreditData = UITextField()
    var accountCreditData = UILabel()
    var accountArray = NSMutableArray()
    var typeArray = NSMutableArray()
    var accountData = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        self.title = "添加信用卡（电子分期）"
        setupCreditLable()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        initData()
    }
    
    func initData(){
        accountArray = NSMutableArray()
        let accountTempArray = SQLLine.selectAllData(entityNameOfCreditAccount)
        
        if accountTempArray.count == 0{
            let alert = textAlertView("请先添加信用卡账户")
            alert.tag = 0
            alert.delegate = self
            return
        }
        
        typeArray = NSMutableArray()
        let typeTempArray = SQLLine.selectAllData(entityNameOfPayName)
        
        if typeTempArray.count == 0{
            let alert = textAlertView("请先添加支出类型")
            alert.tag = 1
            alert.delegate = self
            return
        }
        
        for i in 0 ..< accountTempArray.count {
            let name = accountTempArray[i].valueForKey(creditAccountNameOfName) as! String
            accountArray.addObject(name)
        }
        
        for i in 0 ..< typeTempArray.count {
            let name = typeTempArray[i].valueForKey(payNameNameOfName) as! String
            typeArray.addObject(name)
        }
        
        if self.accountCreditData.text == nil {
            self.accountCreditData.text = accountArray.objectAtIndex(0) as? String
        }
        
        if self.accountData.text == nil {
            self.accountData.text = typeArray.objectAtIndex(0) as? String
        }
    }
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        var vc = UIViewController()
        if alertView.tag == 0 {
            vc = AddCreditAccountViewController()
        }else if alertView.tag == 1{
            vc = AddCostNameViewController()
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupCreditLable(){
        let gap = CGFloat(10)
        
        let periodsCreditSize = sizeWithText("还款期数：", font: introduceFont, maxSize: CGSizeMake(self.view.frame.width/2, 30))
        let periodsCredit = UILabel.introduceLabel()
        periodsCredit.frame = CGRectMake(20, 90, periodsCreditSize.width, 30)
        periodsCredit.text = "还款期数："
        self.view.addSubview(periodsCredit)
        
        let numberCredit = UILabel.introduceLabel()
        numberCredit.frame = CGRectMake(20, periodsCredit.frame.maxY+gap, periodsCreditSize.width, 30)
        numberCredit.text = "每期金额："
        self.view.addSubview(numberCredit)
        
        let dateCredit = UILabel.introduceLabel()
        dateCredit.frame = CGRectMake(20, numberCredit.frame.maxY+gap, periodsCreditSize.width, 30)
        dateCredit.text = "还款日期："
        self.view.addSubview(dateCredit)
        
        let account = UILabel.introduceLabel()
        account.frame = CGRectMake(20, dateCredit.frame.maxY+gap, periodsCreditSize.width, 30)
        account.text = "信用账户："
        self.view.addSubview(account)
        
        self.periodsCreditData = UITextField.inputTextField()
        self.periodsCreditData.frame = CGRectMake(periodsCredit.frame.maxX, periodsCredit.frame.minY, self.view.frame.size.width-periodsCredit.frame.maxX-20, 30)
        self.periodsCreditData.placeholder = "还款期数..."
        self.periodsCreditData.keyboardType = UIKeyboardType.NumberPad //激活时 弹出数字键盘
        self.periodsCreditData.becomeFirstResponder() //界面打开时就获取焦点
        self.periodsCreditData.returnKeyType = UIReturnKeyType.Done //表示完成输入
        self.view.addSubview(self.periodsCreditData)
        
        self.numberCreditData = UITextField.inputTextField()
        self.numberCreditData.frame = CGRectMake(numberCredit.frame.maxX, numberCredit.frame.minY, self.view.frame.size.width-numberCredit.frame.maxX-20, 30)
        self.numberCreditData.placeholder = "每期金额..."
        self.numberCreditData.keyboardType = UIKeyboardType.DecimalPad //激活时 弹出数字键盘
        self.numberCreditData.returnKeyType = UIReturnKeyType.Done //表示完成输入
        self.view.addSubview(self.numberCreditData)
        
        self.dateCreditData = UITextField.inputTextField()
        self.dateCreditData.frame = CGRectMake(dateCredit.frame.maxX, dateCredit.frame.minY, self.view.frame.size.width-dateCredit.frame.maxX-20, 30)
        self.dateCreditData.placeholder = "还款日期..."
        self.dateCreditData.keyboardType = UIKeyboardType.DecimalPad //激活时 弹出数字键盘
        self.dateCreditData.returnKeyType = UIReturnKeyType.Done //表示完成输入
        self.view.addSubview(self.dateCreditData)
        
        self.accountCreditData = UILabel.selectLabel(self, selector: #selector(goSelectAccount))
        self.accountCreditData.frame = CGRectMake(account.frame.maxX, account.frame.minY, self.view.frame.size.width-account.frame.maxX-20, 30)
        self.view.addSubview(self.accountCreditData)
        
        let type = UILabel.introduceLabel()
        type.frame = CGRectMake(20, account.frame.maxY+gap, periodsCreditSize.width, 30)
        type.text = "支出类型："
        self.view.addSubview(type)
        
        self.accountData = UILabel.selectLabel(self, selector: #selector(goSelectType))
        self.accountData.frame = CGRectMake(type.frame.maxX, type.frame.minY, self.view.frame.size.width-type.frame.maxX-20, 30)
        self.view.addSubview(self.accountData)
        
        let save = UIButton(frame: CGRectMake(20, type.frame.maxY+gap*3, self.view.frame.size.width-40, 44))
        save.layer.backgroundColor = UIColor.redColor().CGColor
        save.layer.cornerRadius = 3
        save.setTitle("保  存", forState: UIControlState.Normal)
        save.addTarget(self, action: #selector(saveCredit), forControlEvents:.TouchUpInside)
        self.view.addSubview(save)
        
    }
    
    func goSelectType(){
        let vc = CostNameListViewController()
        vc.delegate = self
        let vcNavigationController = UINavigationController(rootViewController: vc) //带导航栏
        self.navigationController?.presentViewController(vcNavigationController, animated: true, completion: nil)
    }
    
    func goSelectAccount(){
        let vc = AccountListViewController()
        vc.delegate = self
        let vcNavigationController = UINavigationController(rootViewController: vc) //带导航栏
        self.navigationController?.presentViewController(vcNavigationController, animated: true, completion: nil)
    }
    
    func buttonClicked(name: String) {
        self.accountCreditData.text = name
    }
    
    func costNameClicked(name: String) {
        self.accountData.text = name
    }

    func saveCredit(){
        if !checkData() {
            return
        }
        
        let timeNow = getTime()
        let date = Int(dateCreditData.text!)!
        let nextPayDay = CalculateCredit.getFirstPayDate(timeNow, day: date)
        let periods = Int(periodsCreditData.text!)!
        
        SQLLine.insertCrediData(periods, number: Float(numberCreditData.text!)!, time: timeNow, account: accountCreditData.text!, date: date, nextPayDay: nextPayDay, leftPeriods: periods, type: self.accountData.text!)
        
        MyToastView().showToast("添加成功！")
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool { //键盘上的完成按钮 相应事件
        //收起键盘
        textField.resignFirstResponder()
        return true
    }

}
