//
//  EveryMonthSalaryViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/16.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//


//=====================================================================================================
/**
 MARK: - 只是显示每月收入
 **/
//=====================================================================================================

import UIKit

class EveryMonthSalaryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitle()
        setUpElesCon()
        // Do any additional setup after loading the view.
    }
    
    func setUpTitle(){
        self.title = "每月收入"
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        
    }
    
    // 显示元素
    func setUpElesCon(){
        let nameUsed = "每月收入"
        let namelbSize = sizeWithText("每月收入：", font: introduceFont, maxSize: CGSize(width: self.view.frame.width/2, height: 30))
        let namelb = UILabel.introduceLabel()
        namelb.frame = CGRect(x: 20, y: 90, width: namelbSize.width, height: 30)
        namelb.text = nameUsed
        namelb.tag = 1
        self.view.addSubview(namelb)
        
        let numberText = UITextField.inputTextField()
        numberText.frame = CGRect(x: namelb.frame.maxX, y: namelb.frame.minY, width: self.view.frame.size.width-namelb.frame.maxX-20, height: 30)
        numberText.keyboardType = UIKeyboardType.decimalPad //激活时
        numberText.returnKeyType = UIReturnKeyType.done //表示完成输入
        numberText.text = String(GetAnalyseData.getEveryMonthSalary())
        self.view.addSubview(numberText)
        numberText.tag = 2
        numberText.isEnabled = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
