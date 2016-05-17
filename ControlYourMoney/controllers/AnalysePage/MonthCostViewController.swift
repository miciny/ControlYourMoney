//
//  MonthCostViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/16.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class MonthCostViewController: UIViewController {
    var nameArray : NSMutableArray?
    var numberArray : NSMutableArray?
    var saveBtn: UIButton?
    var lastY: CGFloat?
    var gap: CGFloat?
    var lastTag: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitle()
        setUpData()
        setUpEles()
        setUpElesCon()
    }
    
    func setUpTitle(){
        self.title = "设置每月花费"
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
     
        
        let addItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(MonthCostViewController.addCost))
        self.navigationItem.rightBarButtonItem = addItem
    }
    
    func setUpElesCon(){
        let nameUsed = "本月已用"
        let namelbSize = sizeWithText("本月已用：", font: introduceFont, maxSize: CGSizeMake(self.view.frame.width/2, 30))
        let namelb = UILabel(frame: CGRectMake(20, 90, namelbSize.width, 30))
        namelb.font = introduceFont
        namelb.textAlignment = NSTextAlignment.Left
        namelb.backgroundColor = UIColor.clearColor()
        namelb.textColor = UIColor.blackColor()
        namelb.text = nameUsed
        namelb.tag = 1
        self.view.addSubview(namelb)
        
        let numberText = UITextField(frame: CGRectMake(namelb.frame.maxX, namelb.frame.minY, self.view.frame.size.width-namelb.frame.maxX-20, 30))
        numberText.font = introduceFont
        numberText.textAlignment = NSTextAlignment.Left
        numberText.borderStyle = UITextBorderStyle.RoundedRect
        numberText.clearButtonMode = UITextFieldViewMode.WhileEditing
        numberText.backgroundColor = UIColor.whiteColor()
        numberText.textColor = UIColor.blackColor()
        numberText.keyboardType = UIKeyboardType.DecimalPad //激活时
        numberText.returnKeyType = UIReturnKeyType.Done //表示完成输入
        numberText.text = String(GetAnalyseData.getThisMonthUse())
        self.view.addSubview(numberText)
        numberText.tag = 2
        numberText.enabled = false
        
    }
    
    func setUpData(){
        self.lastY = CGFloat(120)
        self.lastTag = Int(2)
        self.gap = CGFloat(10)
        
        let costArray = SQLLine.selectAllData(entityNameOfCost)
        self.nameArray = NSMutableArray()
        self.numberArray = NSMutableArray()
        if costArray.count == 0{
            return
        }
        
        for i in 0 ..< costArray.count {
            let type = costArray.objectAtIndex(i).valueForKey(costNameOfType) as! Int
            if type == 0 {
                self.nameArray?.addObject((costArray.objectAtIndex(i).valueForKey(costNameOfName) as? String)!)
                self.numberArray?.addObject((costArray.objectAtIndex(i).valueForKey(costNameOfNumber) as? Float)!)
            }
        }
    }
    
    func setUpEles(){
        
        let count = nameArray!.count
        
        for i in 0 ..< count {
            let nameStr = nameArray![i] as! String
            let numberStr = String(numberArray![i] as! Float)
            
            let namelbSize = sizeWithText("本月已用：", font: introduceFont, maxSize: CGSizeMake(self.view.frame.width/2, 30))
            let namelb = UILabel(frame: CGRectMake(20, 130+(30+gap!)*CGFloat(i), namelbSize.width, 30))
            namelb.font = introduceFont
            namelb.textAlignment = NSTextAlignment.Left
            namelb.backgroundColor = UIColor.clearColor()
            namelb.textColor = UIColor.blackColor()
            namelb.text = nameStr
            namelb.tag = i*2+3
            self.view.addSubview(namelb)
            
            let numberText = UITextField(frame: CGRectMake(namelb.frame.maxX, namelb.frame.minY, self.view.frame.size.width-namelb.frame.maxX-20, 30))
            numberText.font = introduceFont
            numberText.textAlignment = NSTextAlignment.Left
            numberText.borderStyle = UITextBorderStyle.RoundedRect
            numberText.clearButtonMode = UITextFieldViewMode.WhileEditing
            numberText.backgroundColor = UIColor.whiteColor()
            numberText.textColor = UIColor.blackColor()
            numberText.placeholder = "请输入金额..."
            numberText.keyboardType = UIKeyboardType.DecimalPad //激活时
            numberText.returnKeyType = UIReturnKeyType.Done //表示完成输入
            numberText.text = numberStr
            numberText.tag = i*2+4
            self.view.addSubview(numberText)
            
            lastY = numberText.frame.maxY
            lastTag = numberText.tag
        }
        
        self.saveBtn = UIButton()
        self.saveBtn!.frame = CGRectMake(20, lastY!+gap!*3, self.view.frame.size.width-40, 44)
        self.saveBtn!.layer.backgroundColor = UIColor.redColor().CGColor
        self.saveBtn!.layer.cornerRadius = 3
        self.saveBtn!.setTitle("确  定", forState: UIControlState.Normal)
        self.saveBtn!.addTarget(self, action: #selector(saveData), forControlEvents:.TouchUpInside)
        self.view.addSubview(self.saveBtn!)
    }
    
    func saveData(){
        let nameViewArray = NSMutableArray()
        let numberViewArray = NSMutableArray()
        let uiViews = self.view.subviews
        for view in uiViews{
            let tag = view.tag
            if tag>2 && tag%2==1 {
                nameViewArray.addObject(view)
            }
            if tag>2 && tag%2==0 {
                numberViewArray.addObject(view)
            }
        }
        
        let nameArray = NSMutableArray()
        let numberArray = NSMutableArray()
        
        for i in 0 ..< nameViewArray.count {
            let view = nameViewArray[i]
            let viewText = numberViewArray[i] as! UITextField
            
            if viewText.text != "" && stringIsFloat(viewText.text!){
                if view.isKindOfClass(UILabel) {
                    let lb = view as! UILabel
                    if lb.text != ""{
                        nameArray.addObject(lb.text!)
                        numberArray.addObject(viewText.text!)
                    }
                }else if view.isKindOfClass(UITextField) {
                    let lb = view as! UITextField
                    if lb.text != ""{
                        nameArray.addObject(lb.text!)
                        numberArray.addObject(viewText.text!)
                    }
                }
            }else{
                textAlertView("数据错误")
                return
            }
        }
        deleteSQLData()
        
        let timeNow = getTime()
        for i in 0 ..< nameArray.count {
            let nameStr = nameArray[i] as! String
            let number = Float(numberArray[i] as! String)
            SQLLine.insertCostData(nameStr, time: timeNow, type: 0, number: number!)
        }
        let toast = MyToastView()
        toast.showToast("保存成功")
        
        rebuildFace()
    }
    
    func rebuildFace(){
        
        let uiViews = self.view.subviews
        for view in uiViews{
            view.removeFromSuperview()
        }
        
        setUpData()
        setUpEles()
        setUpElesCon()
    }
    
    func deleteSQLData(){
        let costArray = SQLLine.selectAllData(entityNameOfCost)
        var count = 0
        for i in 0 ..< costArray.count{
            let type = costArray.objectAtIndex(i).valueForKey(costNameOfType) as! Int
            if type == 0 {
                count += 1
            }
        }
        
        for _ in 0 ..< count {
            let TempCostArray = SQLLine.selectAllData(entityNameOfCost)
            for j in 0 ..< TempCostArray.count{
                let type = TempCostArray.objectAtIndex(j).valueForKey(costNameOfType) as! Int
                if type == 0 {
                    SQLLine.deleteData(entityNameOfCost, indexPath: j)
                    break
                }
            }
        }
    }
    
    func addCost(){
        let nameTextSize = sizeWithText("本月已用", font: introduceFont, maxSize: CGSizeMake(self.view.frame.width/2, 30))
        let nameText = UITextField(frame: CGRectMake(20, lastY!+gap!, nameTextSize.width, 30))
        nameText.font = introduceFont
        nameText.textAlignment = NSTextAlignment.Left
        nameText.borderStyle = UITextBorderStyle.RoundedRect
        nameText.backgroundColor = UIColor.whiteColor()
        nameText.textColor = UIColor.blackColor()
        nameText.placeholder = "名称"
        nameText.keyboardType = UIKeyboardType.Default //激活时
        nameText.returnKeyType = UIReturnKeyType.Done //表示完成输入
        nameText.tag = lastTag! + 1
        self.view.addSubview(nameText)
        
        let lb = UILabel(frame: CGRectMake(nameText.frame.maxX, nameText.frame.minY, 20, 30))
        lb.text = "："
        self.view.addSubview(lb)
        
        let numberText = UITextField(frame: CGRectMake(lb.frame.maxX, nameText.frame.minY, self.view.frame.size.width-lb.frame.maxX-20, 30))
        numberText.font = introduceFont
        numberText.textAlignment = NSTextAlignment.Left
        numberText.borderStyle = UITextBorderStyle.RoundedRect
        numberText.clearButtonMode = UITextFieldViewMode.WhileEditing
        numberText.backgroundColor = UIColor.whiteColor()
        numberText.textColor = UIColor.blackColor()
        numberText.placeholder = "金额"
        numberText.keyboardType = UIKeyboardType.DecimalPad //激活时
        numberText.returnKeyType = UIReturnKeyType.Done //表示完成输入
        numberText.tag = lastTag! + 2
        self.view.addSubview(numberText)
        
        lastY = numberText.frame.maxY
        lastTag = numberText.tag
        
        self.saveBtn!.frame = CGRectMake(20, lastY!+gap!*3, self.view.frame.size.width-40, 44)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
