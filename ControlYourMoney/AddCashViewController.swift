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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "现金记账"
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)

        setupCashLable()
        
    }
    
    func setupCashLable(){
        let numberUsed = UILabel(frame: CGRectMake(20, 140, self.view.frame.size.width / 5, 30))
        numberUsed.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        numberUsed.textAlignment = NSTextAlignment.Left
        numberUsed.backgroundColor = UIColor.clearColor()
        numberUsed.textColor = UIColor.blackColor()
        numberUsed.text = "金额："
        self.view.addSubview(numberUsed)
        
        let whereUsed = UILabel(frame: CGRectMake(20, 200, self.view.frame.size.width / 5, 30))
        whereUsed.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        whereUsed.textAlignment = NSTextAlignment.Left
        whereUsed.backgroundColor = UIColor.clearColor()
        whereUsed.textColor = UIColor.blackColor()
        whereUsed.text = "用处："
        self.view.addSubview(whereUsed)
        
        numberUsedData = UITextField(frame: CGRectMake(self.view.frame.size.width / 5 + 20, 140, self.view.frame.size.width * 2 / 3 - 20, 30))
        numberUsedData.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        numberUsedData.textAlignment = NSTextAlignment.Left
        numberUsedData.borderStyle = UITextBorderStyle.RoundedRect
        numberUsedData.clearButtonMode = UITextFieldViewMode.WhileEditing
        numberUsedData.backgroundColor = UIColor.whiteColor()
        numberUsedData.textColor = UIColor.blackColor()
        numberUsedData.placeholder = "请输入金额..."
        numberUsedData.keyboardType = UIKeyboardType.DecimalPad //激活时 弹出数字键盘
        numberUsedData.becomeFirstResponder() //界面打开时就获取焦点
        numberUsedData.returnKeyType = UIReturnKeyType.Done //表示完成输入
        self.view.addSubview(numberUsedData)
        
        whereUsedData = UITextField(frame: CGRectMake(self.view.frame.size.width / 5 + 20, 200, self.view.frame.size.width * 2 / 3 - 20, 30))
        whereUsedData.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        whereUsedData.textAlignment = NSTextAlignment.Left
        whereUsedData.borderStyle = UITextBorderStyle.RoundedRect
        whereUsedData.clearButtonMode = UITextFieldViewMode.WhileEditing
        whereUsedData.backgroundColor = UIColor.whiteColor()
        whereUsedData.textColor = UIColor.blackColor()
        whereUsedData.placeholder = "请输入用处..."
        whereUsedData.text = "早中晚餐"
        self.view.addSubview(whereUsedData)
        
        let save = UIButton(frame: CGRectMake(self.view.frame.size.width / 3 - 30, 260, self.view.frame.size.width / 3 + 60, 44))
        save.layer.backgroundColor = UIColor.redColor().CGColor
        save.setTitle("保  存", forState: UIControlState.Normal)
        save.addTarget(self,action:Selector("saveCash:"),forControlEvents:.TouchUpInside)
        self.view.addSubview(save)
    }
    
    @IBAction func saveCash(sender : AnyObject){
        
        if(numberUsedData.text == "" || whereUsedData.text == ""){
            textView("请输入金额和用处！")
        }else{
            if(stringIsFloat(numberUsedData.text! as String)){
                InsertCashData(whereUsedData.text!, useNumber: Float(numberUsedData.text!)!, time: getTime())
                
                let countTmp = SelectAllData(entityNameOfTotal).count
                if(countTmp == 0){
                    InsertTotaleData(0 - Float(numberUsedData.text!)!, time: getTime())
                }else{
                    var canTmp = getCanUseToFloat()
                    canTmp = canTmp - Float(numberUsedData.text!)!
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
