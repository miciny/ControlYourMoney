//
//  AddCreditViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/3/12.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
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
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
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


class AddCreditViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate{
    
    var periodsCreditData = UITextField()  //周期输入框
    var numberCreditData = UITextField() //每期额度输入框
    var dateCreditData = UITextField() //每期还款时间数据框
    var accountCreditData = UILabel() //账户的label
    var accountArray = NSMutableArray() //保存账户的数组
    var typeArray = NSMutableArray() //支出类型的数组
    var accountData = UILabel() //支出类型的label

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        self.title = "添加信用卡（电子分期）"
        setupCreditLable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        initData()
    }
    
    //初始化数据
    func initData(){
        accountArray = NSMutableArray()
        
        //如果没有账户的话，先添加
        let accountTempArray = CreditAccount.selectAllData()
        if accountTempArray.count == 0{
            let alert = textAlertView("请先添加信用卡账户")
            alert.tag = 0
            alert.delegate = self
            return
        }
        
        typeArray = NSMutableArray()
        let typeTempArray = PayName.selectAllData()
        //如果没有类型的话，先添加
        if typeTempArray.count == 0{
            let alert = textAlertView("请先添加支出类型")
            alert.tag = 1
            alert.delegate = self
            return
        }
        
        //保存账户和类型
        for i in 0 ..< accountTempArray.count {
            let name = (accountTempArray[i] as AnyObject).value(forKey: creditAccountNameOfName) as! String
            accountArray.add(name)
        }
        
        for i in 0 ..< typeTempArray.count {
            let name = (typeTempArray[i] as AnyObject).value(forKey: payNameNameOfName) as! String
            typeArray.add(name)
        }
        
        //默认显示第一个
        if self.accountCreditData.text == nil {
            self.accountCreditData.text = accountArray.object(at: 0) as? String
        }
        
        if self.accountData.text == nil {
            self.accountData.text = typeArray.object(at: 0) as? String
        }
    }
    
    //确认框事件
    func alertView(_ alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        var vc = UIViewController()
        if alertView.tag == 0 {
            vc = AddCreditAccountViewController()
        }else if alertView.tag == 1{
            vc = AddCostNameViewController()
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //设置页面元素
    func setupCreditLable(){
        let gap = CGFloat(10)
        
        //五个label
        let periodsCreditSize = sizeWithText("还款期数：", font: introduceFont, maxSize: CGSize(width: self.view.frame.width/2, height: 30))
        let periodsCredit = UILabel.introduceLabel()
        periodsCredit.frame = CGRect(x: 20, y: 90, width: periodsCreditSize.width, height: 30)
        periodsCredit.text = "还款期数："
        self.view.addSubview(periodsCredit)
        
        let numberCredit = UILabel.introduceLabel()
        numberCredit.frame = CGRect(x: 20, y: periodsCredit.frame.maxY+gap, width: periodsCreditSize.width, height: 30)
        numberCredit.text = "每期金额："
        self.view.addSubview(numberCredit)
        
        let dateCredit = UILabel.introduceLabel()
        dateCredit.frame = CGRect(x: 20, y: numberCredit.frame.maxY+gap, width: periodsCreditSize.width, height: 30)
        dateCredit.text = "还款日期："
        self.view.addSubview(dateCredit)
        
        let account = UILabel.introduceLabel()
        account.frame = CGRect(x: 20, y: dateCredit.frame.maxY+gap, width: periodsCreditSize.width, height: 30)
        account.text = "信用账户："
        self.view.addSubview(account)
        
        let type = UILabel.introduceLabel()
        type.frame = CGRect(x: 20, y: account.frame.maxY+gap, width: periodsCreditSize.width, height: 30)
        type.text = "支出类型："
        self.view.addSubview(type)
        
        //三个输入框
        self.periodsCreditData = UITextField.inputTextField()
        self.periodsCreditData.frame = CGRect(x: periodsCredit.frame.maxX, y: periodsCredit.frame.minY, width: self.view.frame.size.width-periodsCredit.frame.maxX-20, height: 30)
        self.periodsCreditData.placeholder = "还款期数..."
        self.periodsCreditData.keyboardType = UIKeyboardType.numberPad //激活时 弹出数字键盘
        self.periodsCreditData.becomeFirstResponder() //界面打开时就获取焦点
        self.periodsCreditData.returnKeyType = UIReturnKeyType.done //表示完成输入
        self.view.addSubview(self.periodsCreditData)
        
        self.numberCreditData = UITextField.inputTextField()
        self.numberCreditData.frame = CGRect(x: numberCredit.frame.maxX, y: numberCredit.frame.minY, width: self.view.frame.size.width-numberCredit.frame.maxX-20, height: 30)
        self.numberCreditData.placeholder = "每期金额..."
        self.numberCreditData.keyboardType = UIKeyboardType.decimalPad //激活时 弹出数字键盘
        self.numberCreditData.returnKeyType = UIReturnKeyType.done //表示完成输入
        self.view.addSubview(self.numberCreditData)
        
        self.dateCreditData = UITextField.inputTextField()
        self.dateCreditData.frame = CGRect(x: dateCredit.frame.maxX, y: dateCredit.frame.minY, width: self.view.frame.size.width-dateCredit.frame.maxX-20, height: 30)
        self.dateCreditData.placeholder = "还款日期..."
        self.dateCreditData.keyboardType = UIKeyboardType.decimalPad //激活时 弹出数字键盘
        self.dateCreditData.returnKeyType = UIReturnKeyType.done //表示完成输入
        self.view.addSubview(self.dateCreditData)
        
        //两个选择的label
        self.accountCreditData = UILabel.selectLabel(self, selector: #selector(goSelectAccount))
        self.accountCreditData.frame = CGRect(x: account.frame.maxX, y: account.frame.minY, width: self.view.frame.size.width-account.frame.maxX-20, height: 30)
        self.view.addSubview(self.accountCreditData)
        
        self.accountData = UILabel.selectLabel(self, selector: #selector(goSelectType))
        self.accountData.frame = CGRect(x: type.frame.maxX, y: type.frame.minY, width: self.view.frame.size.width-type.frame.maxX-20, height: 30)
        self.view.addSubview(self.accountData)
        
        //保存按钮
        let save = UIButton(frame: CGRect(x: 20, y: type.frame.maxY+gap*3, width: self.view.frame.size.width-40, height: 44))
        save.layer.backgroundColor = UIColor.red.cgColor
        save.layer.cornerRadius = 3
        save.setTitle("保  存", for: UIControlState())
        save.addTarget(self, action: #selector(saveCredit), for:.touchUpInside)
        self.view.addSubview(save)
        
    }
    
    //进入选择支出类型的页面
    func goSelectType(){
        let vc = CostNameListViewController()
        vc.delegate = self
        let vcNavigationController = UINavigationController(rootViewController: vc) //带导航栏
        self.navigationController?.present(vcNavigationController, animated: true, completion: nil)
    }
    
    //进入选择账户的页面
    func goSelectAccount(){
        let vc = AccountListViewController()
        vc.delegate = self
        let vcNavigationController = UINavigationController(rootViewController: vc) //带导航栏
        self.navigationController?.present(vcNavigationController, animated: true, completion: nil)
    }

    //保存数据
    func saveCredit(){
        
        if !checkData() {
            return
        }
        
        let timeNow = getTime()
        let date = Int(dateCreditData.text!)!
        let nextPayDay = CalculateCredit.getFirstPayDate(timeNow, day: date)
        let periods = Int(periodsCreditData.text!)!
        
        Credit.insertCrediData(periods, number: Float(numberCreditData.text!)!, time: timeNow, account: accountCreditData.text!, date: date, nextPayDay: nextPayDay, leftPeriods: periods, type: self.accountData.text!)
        
        MyToastView().showToast("添加成功！")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //检查输入框
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
    
    /**
     MARK text field delegate
     **/
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { //键盘上的完成按钮 相应事件
        //收起键盘
        textField.resignFirstResponder()
        return true
    }
}

//支出类型的代理
extension AddCreditViewController: costNameListViewDelegate{
    func costNameClicked(_ name: String) {
        self.accountData.text = name
    }
}

//账户的代理
extension AddCreditViewController: accountListViewDelegate{
    func buttonClicked(_ name: String) {
        self.accountCreditData.text = name
    }
}
