//
//  AddSalaryViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/3/12.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class AddSalaryViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    var numberSalaryData = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "工资"
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        
        setupSalaryLable()
        
        // Do any additional setup after loading the view.
    }
    
    func setupSalaryLable(){
        let gap = CGFloat(10)
        
        let numberSalarySize = sizeWithText("工资金额：", font: introduceFont, maxSize: CGSizeMake(self.view.frame.width/2, 30))
        let numberSalary = UILabel(frame: CGRectMake(20, 90, numberSalarySize.width, 30))
        numberSalary.font = introduceFont
        numberSalary.textAlignment = NSTextAlignment.Left
        numberSalary.backgroundColor = UIColor.clearColor()
        numberSalary.textColor = UIColor.blackColor()
        numberSalary.text = "工资金额："
        self.view.addSubview(numberSalary)
        
        
        self.numberSalaryData = UITextField(frame: CGRectMake(numberSalary.frame.maxX, numberSalary.frame.minY, self.view.frame.size.width-numberSalary.frame.maxX-20, 30))
        self.numberSalaryData.font = introduceFont
        self.numberSalaryData.textAlignment = NSTextAlignment.Left
        self.numberSalaryData.borderStyle = UITextBorderStyle.RoundedRect
        self.numberSalaryData.clearButtonMode = UITextFieldViewMode.WhileEditing
        self.numberSalaryData.backgroundColor = UIColor.whiteColor()
        self.numberSalaryData.textColor = UIColor.blackColor()
        self.numberSalaryData.placeholder = "请输入金额..."
        self.numberSalaryData.keyboardType = UIKeyboardType.DecimalPad //激活时 弹出数字键盘
        self.numberSalaryData.becomeFirstResponder() //界面打开时就获取焦点
        self.numberSalaryData.returnKeyType = UIReturnKeyType.Done //表示完成输入
        self.view.addSubview(self.numberSalaryData)
        
        let save = UIButton(frame: CGRectMake(20, numberSalary.frame.maxY+gap*3, self.view.frame.size.width-40, 44))
        save.layer.backgroundColor = UIColor.redColor().CGColor
        save.layer.cornerRadius = 3
        save.setTitle("保  存", forState: UIControlState.Normal)
        save.addTarget(self,action: #selector(saveSalary),forControlEvents:.TouchUpInside)
        self.view.addSubview(save)
    }
    
    func saveSalary(){
        if(self.numberSalaryData.text == ""){
            textAlertView("请输入内容！")
            return
        }
        
        if(!stringIsFloat(self.numberSalaryData.text! as String)){
            textAlertView("请输入正确金额！")
            return
        }
        
        SQLLine.insertSalaryData(getTime(), number: Float(self.numberSalaryData.text!)!)
        CalculateCredit.changeTotal(-Float(self.numberSalaryData.text!)!)
        
        MyToastView().showToast("添加成功！")
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
