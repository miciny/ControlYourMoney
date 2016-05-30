//
//  AddSalaryViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/3/12.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class AddIncomeViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate{
    var numberSalaryData = UITextField()
    var nameArray: NSMutableArray!
    var accountData = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "收入"
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        setupSalaryLable()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        initData()
    }
    
    //获取数据
    func initData(){
        
        nameArray = NSMutableArray()
        let accountTempArray = IncomeName.selectAllData()
        
        if accountTempArray.count == 0{
            let alert = textAlertView("请先添加收入类型")
            alert.delegate = self
            return
        }
        
        for i in 0 ..< accountTempArray.count {
            let name = accountTempArray[i].valueForKey(creditAccountNameOfName) as! String
            nameArray.addObject(name)
        }
        
        if self.accountData.text == nil {
            self.accountData.text = nameArray.objectAtIndex(0) as? String
        }
    }
    
    //设置label
    func setupSalaryLable(){
        let gap = CGFloat(10)
        
        let numberSalarySize = sizeWithText("工资金额：", font: introduceFont, maxSize: CGSizeMake(self.view.frame.width/2, 30))
        let numberSalary = UILabel.introduceLabel()
        numberSalary.frame = CGRectMake(20, 90, numberSalarySize.width, 30)
        numberSalary.text = "收入金额："
        self.view.addSubview(numberSalary)
        
        self.numberSalaryData = UITextField.inputTextField()
        self.numberSalaryData.frame = CGRectMake(numberSalary.frame.maxX, numberSalary.frame.minY, self.view.frame.size.width-numberSalary.frame.maxX-20, 30)
        self.numberSalaryData.placeholder = "请输入金额..."
        self.numberSalaryData.keyboardType = UIKeyboardType.DecimalPad //激活时 弹出数字键盘
        self.numberSalaryData.becomeFirstResponder() //界面打开时就获取焦点
        self.numberSalaryData.returnKeyType = UIReturnKeyType.Done //表示完成输入
        self.view.addSubview(self.numberSalaryData)
        
        let account = UILabel.introduceLabel()
        account.frame = CGRectMake(20, numberSalary.frame.maxY+gap, numberSalarySize.width, 30)
        account.text = "收入类型："
        self.view.addSubview(account)
        
        self.accountData = UILabel.selectLabel(self, selector: #selector(goSelectAccount))
        self.accountData.frame = CGRectMake(account.frame.maxX, account.frame.minY, self.view.frame.size.width-account.frame.maxX-20, 30)
        self.view.addSubview(self.accountData)
        
        let save = UIButton(frame: CGRectMake(20, account.frame.maxY+gap*3, self.view.frame.size.width-40, 44))
        save.layer.backgroundColor = UIColor.redColor().CGColor
        save.layer.cornerRadius = 3
        save.setTitle("保  存", forState: UIControlState.Normal)
        save.addTarget(self,action: #selector(saveSalary),forControlEvents:.TouchUpInside)
        self.view.addSubview(save)
    }
    
    //确认框代理
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        let vc = AddIncomeAccountViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //保存
    func saveSalary(){
        //检查数据
        if(self.numberSalaryData.text == ""){
            textAlertView("请输入内容！")
            return
        }
        
        if(!stringIsFloat(self.numberSalaryData.text! as String)){
            textAlertView("请输入正确金额！")
            return
        }
        
        //保存
        Salary.insertIncomeData(getTime(), number: Float(self.numberSalaryData.text!)!, name: self.accountData.text!)
        CalculateCredit.changeTotal(-Float(self.numberSalaryData.text!)!)
        
        MyToastView().showToast("添加成功！")
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    //进入选择账号页
    func goSelectAccount(){
        let vc = IncomeNameListViewController()
        vc.delegate = self
        let vcNavigationController = UINavigationController(rootViewController: vc) //带导航栏
        self.navigationController?.presentViewController(vcNavigationController, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//账号选择的代理
extension AddIncomeViewController: accountListViewDelegate{
    func buttonClicked(name: String) {
        self.accountData.text = name
    }
}
