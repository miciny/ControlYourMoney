//
//  AddCreditAccpuntViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/12.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class AddCreditAccountViewController: UIViewController {

    var creditAccountText = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "信用帐号"
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        
        //取消按钮
        let rightBarBtn = UIBarButtonItem(title: "取消", style: .Plain, target: self,
                                         action: #selector(AddCreditAccountViewController.backToPrevious))
        self.navigationItem.rightBarButtonItem = rightBarBtn

        setupLable()
        // Do any additional setup after loading the view.
    }
    
    func backToPrevious(){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func setupLable(){
        let gap = CGFloat(10)
        
        let creditAccountSize = sizeWithText("信用账号：", font: introduceFont, maxSize: CGSizeMake(self.view.frame.width/2, 30))
        let creditAccount = UILabel(frame: CGRectMake(20, 90, creditAccountSize.width, 30))
        creditAccount.font = introduceFont
        creditAccount.textAlignment = NSTextAlignment.Left
        creditAccount.backgroundColor = UIColor.clearColor()
        creditAccount.textColor = UIColor.blackColor()
        creditAccount.text = "信用账号："
        self.view.addSubview(creditAccount)
        
        
        self.creditAccountText = UITextField(frame: CGRectMake(creditAccount.frame.maxX, creditAccount.frame.minY, self.view.frame.size.width-creditAccount.frame.maxX-20, 30))
        self.creditAccountText.font = introduceFont
        self.creditAccountText.textAlignment = NSTextAlignment.Left
        self.creditAccountText.borderStyle = UITextBorderStyle.RoundedRect
        self.creditAccountText.clearButtonMode = UITextFieldViewMode.WhileEditing
        self.creditAccountText.backgroundColor = UIColor.whiteColor()
        self.creditAccountText.textColor = UIColor.blackColor()
        self.creditAccountText.placeholder = "请输入信用账号..."
        self.creditAccountText.keyboardType = UIKeyboardType.Default //激活时
        self.creditAccountText.becomeFirstResponder() //界面打开时就获取焦点
        self.creditAccountText.returnKeyType = UIReturnKeyType.Done //表示完成输入
        self.view.addSubview(self.creditAccountText)
        
        let save = UIButton(frame: CGRectMake(20, creditAccount.frame.maxY+gap*3, self.view.frame.size.width-40, 44))
        save.layer.backgroundColor = UIColor.redColor().CGColor
        save.layer.cornerRadius = 3
        save.setTitle("保  存", forState: UIControlState.Normal)
        save.addTarget(self,action: #selector(saveAccount),forControlEvents:.TouchUpInside)
        self.view.addSubview(save)
    }

    
    func saveAccount(){
        if(self.creditAccountText.text == ""){
            textAlertView("请输入内容！")
            return
        }
        
        let str = self.creditAccountText.text
        let accountArray = SQLLine.selectAllData(entityNameOfCreditAccount)
        
        for i in 0 ..< accountArray.count {
            let name = accountArray[i].valueForKey(creditAccountNameOfName) as! String
            if name == str {
                textAlertView("已存在")
                return
            }
        }
        
        SQLLine.insertAccountData(str!, time: getTime())
        MyToastView().showToast("添加成功！")
        self.navigationController?.popViewControllerAnimated(true)
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
