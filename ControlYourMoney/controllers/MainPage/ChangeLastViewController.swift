//
//  ChangeTotalViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 15/12/22.
//  Copyright © 2015年 maocaiyuan. All rights reserved.
//

import UIKit

class ChangeLastViewController: UIViewController {
    
    var totalData = UITextField()  //总额度的输入框
    var lastStr: String? //进入页面 传入的值

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "修改可用余额"
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        
        self.setUpLabel()
    }
    
    //设置页面元素
    func setUpLabel(){
        let gap = CGFloat(10)
        
        //label
        let totlaSize = sizeWithText("可用总额：", font: introduceFont, maxSize: CGSizeMake(self.view.frame.width/2, 30))
        let total = UILabel.introduceLabel()
        total.frame = CGRectMake(20, 90, totlaSize.width, 30)
        total.text = "可用总额："
        self.view.addSubview(total)
        
        //输入框
        self.totalData = UITextField.inputTextField()
        self.totalData.frame = CGRectMake(total.frame.maxX, total.frame.minY, self.view.frame.size.width-total.frame.maxX-20, 30)
        self.totalData.placeholder = "请输入金额..."
        self.totalData.text = lastStr
        self.totalData.becomeFirstResponder() //界面打开时就获取焦点
        self.view.addSubview(self.totalData)
        
        let save = UIButton(frame: CGRectMake(20, total.frame.maxY+gap*3, self.view.frame.size.width-40, 44))
        save.layer.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1).CGColor
        save.setTitle("保  存", forState: UIControlState.Normal)
        save.layer.cornerRadius = 3
        save.addTarget(self,action: #selector(saveLast),forControlEvents:.TouchUpInside)
        self.view.addSubview(save)
    }

    //保存数据
    func saveLast(){
        //检查数据
        if(totalData.text == "" ){
            textAlertView("请输入内容！")
            return
        }
        
        if(!stringIsFloat(totalData.text! as String)){
            textAlertView("请输入正确金额！")
            return
        }
        
        //保存数据
        Total.insertTotalData(Float(totalData.text!)!, time: getTime())
        MyToastView().showToast("修改成功！")
        self.navigationController?.popToRootViewControllerAnimated(true)
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
