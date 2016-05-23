//
//  EveryMonthSalaryViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/16.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

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
    
    func setUpElesCon(){
        let nameUsed = "每月收入"
        let namelbSize = sizeWithText("每月收入：", font: introduceFont, maxSize: CGSizeMake(self.view.frame.width/2, 30))
        let namelb = UILabel.introduceLabel()
        namelb.frame = CGRectMake(20, 90, namelbSize.width, 30)
        namelb.text = nameUsed
        namelb.tag = 1
        self.view.addSubview(namelb)
        
        let numberText = UITextField.inputTextField()
        numberText.frame = CGRectMake(namelb.frame.maxX, namelb.frame.minY, self.view.frame.size.width-namelb.frame.maxX-20, 30)
        numberText.keyboardType = UIKeyboardType.DecimalPad //激活时
        numberText.returnKeyType = UIReturnKeyType.Done //表示完成输入
        numberText.text = String(GetAnalyseData.getEveryMonthSalary())
        self.view.addSubview(numberText)
        numberText.tag = 2
        numberText.enabled = false
        
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
