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
    
    @IBAction func saveSalary(sender : AnyObject){
        if(numberSalaryData.text == ""){
            textView("请输入内容！")
        }else{
            if(stringIsFloat(numberSalaryData.text! as String)){
                InsertSalaryData(getTime(), number: Float(numberSalaryData.text!)!)
                
                let countTmp = SelectAllData(entityNameOfTotal).count
                if(countTmp == 0){
                    let floatTmp = (Float(numberSalaryData.text!)!)
                    InsertTotaleData(floatTmp, time: getTime() )
                }else{
                    var canTmp = getCanUseToFloat()
                    canTmp = canTmp + (Float(numberSalaryData.text!)!)
                    InsertTotaleData(canTmp, time: getTime())
                }
                
                showToast().showToast("添加成功！")
                self.navigationController?.popToRootViewControllerAnimated(true)
            }else{
                textView("请输入正确金额！")
            }
        }
    }
    
    func textView(str :String) -> UIAlertView{
        let alert=UIAlertView()
        alert.message=str
        alert.addButtonWithTitle("Ok")
        alert.delegate=self
        alert.show()
        return alert
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
