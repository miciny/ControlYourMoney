//
//  MonthCostViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/16.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class MonthCostViewController: UIViewController {
    var nameArray : NSMutableArray? //保存已保存的数据的名字
    var numberArray : NSMutableArray? //保存已保存数据的额度
    var saveBtn: UIButton? //保存按钮
    var lastY: CGFloat? //最后的Y，用于点击添加按钮，输入框的位置
    var gap: CGFloat? //每个栏的间隔
    var lastTag: Int? //最后的tag，用于点击添加按钮，输入框的tag

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitle()
        setUpData()
        setUpEles()
        setUpElesCon()
    }
    
    //设置title
    func setUpTitle(){
        self.title = "设置每月花费"
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
     
        
        let addItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(MonthCostViewController.addCost))
        self.navigationItem.rightBarButtonItem = addItem
    }
    
    //设置固定显示的本月已用
    func setUpElesCon(){
        let nameUsed = "本月已用"
        let namelbSize = sizeWithText("本月已用：", font: introduceFont, maxSize: CGSize(width: self.view.frame.width/2, height: 30))
        let namelb = UILabel.introduceLabel()
        namelb.frame = CGRect(x: 20, y: 90, width: namelbSize.width, height: 30)
        namelb.text = nameUsed
        namelb.tag = 1
        self.view.addSubview(namelb)
        
        let numberText = UITextField.inputTextField()
        numberText.frame = CGRect(x: namelb.frame.maxX, y: namelb.frame.minY, width: self.view.frame.size.width-namelb.frame.maxX-20, height: 30)
        numberText.keyboardType = UIKeyboardType.decimalPad //激活时
        numberText.returnKeyType = UIReturnKeyType.done //表示完成输入
        numberText.text = String(GetAnalyseData.getThisMonthUse())
        self.view.addSubview(numberText)
        numberText.tag = 2
        numberText.isEnabled = false
        
    }
    
    //设置数据，提取已经保存的月消费名字和额度
    func setUpData(){
        self.lastY = CGFloat(120)
        self.lastTag = Int(2)
        self.gap = CGFloat(10)
        
        let costArray = Cost.selectAllData()
        self.nameArray = NSMutableArray()
        self.numberArray = NSMutableArray()
        if costArray.count == 0{
            return
        }
        
        for i in 0 ..< costArray.count {
            let type = (costArray.object(at: i) as AnyObject).value(forKey: costNameOfPeriod) as! Int
            if type == 0 {
                self.nameArray?.add(((costArray.object(at: i) as AnyObject).value(forKey: costNameOfName) as? String)!)
                self.numberArray?.add(((costArray.object(at: i) as AnyObject).value(forKey: costNameOfNumber) as? Float)!)
            }
        }
    }
    
    //显示已保存的数据
    func setUpEles(){
        
        let count = nameArray!.count
        
        for i in 0 ..< count {
            let nameStr = nameArray![i] as! String
            let numberStr = String(numberArray![i] as! Float)
            
            let namelbSize = sizeWithText("本月已用：", font: introduceFont, maxSize: CGSize(width: self.view.frame.width/2, height: 30))
            let namelb = UILabel.introduceLabel()
            namelb.frame = CGRect(x: 20, y: 130+(30+gap!)*CGFloat(i), width: namelbSize.width, height: 30)
            namelb.text = nameStr
            namelb.tag = i*2+3
            self.view.addSubview(namelb)
            
            let numberText = UITextField.inputTextField()
            numberText.frame = CGRect(x: namelb.frame.maxX, y: namelb.frame.minY, width: self.view.frame.size.width-namelb.frame.maxX-20, height: 30)
            numberText.placeholder = "请输入金额..."
            numberText.keyboardType = UIKeyboardType.decimalPad //激活时
            numberText.returnKeyType = UIReturnKeyType.done //表示完成输入
            numberText.text = numberStr
            numberText.tag = i*2+4
            self.view.addSubview(numberText)
            
            lastY = numberText.frame.maxY
            lastTag = numberText.tag
        }
        
        self.saveBtn = UIButton()
        self.saveBtn!.frame = CGRect(x: 20, y: lastY!+gap!*3, width: self.view.frame.size.width-40, height: 44)
        self.saveBtn!.layer.backgroundColor = UIColor.red.cgColor
        self.saveBtn!.layer.cornerRadius = 3
        self.saveBtn!.setTitle("确  定", for: UIControlState())
        self.saveBtn!.addTarget(self, action: #selector(saveData), for:.touchUpInside)
        self.view.addSubview(self.saveBtn!)
    }
    
    //保存数据，先检查数据，再数据库全删除，再全部显示
    func saveData(){
        let nameViewArray = NSMutableArray()
        let numberViewArray = NSMutableArray()
        let uiViews = self.view.subviews
        for view in uiViews{
            let tag = view.tag
            if tag>2 && tag%2==1 {
                nameViewArray.add(view)
            }
            if tag>2 && tag%2==0 {
                numberViewArray.add(view)
            }
        }
        
        let nameArray = NSMutableArray()
        let numberArray = NSMutableArray()
        
        for i in 0 ..< nameViewArray.count {
            let view = nameViewArray[i]
            let viewText = numberViewArray[i] as! UITextField
            
            if viewText.text != "" && stringIsFloat(viewText.text!){
                if (view as AnyObject).isKind(of: UILabel) {
                    let lb = view as! UILabel
                    if lb.text != ""{
                        nameArray.add(lb.text!)
                        numberArray.add(viewText.text!)
                    }
                }else if (view as AnyObject).isKind(of: UITextField) {
                    let lb = view as! UITextField
                    if lb.text != ""{
                        nameArray.add(lb.text!)
                        numberArray.add(viewText.text!)
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
            Cost.insertCostData(nameStr, time: timeNow, type: "", number: number!, period: 0)
        }
        let toast = MyToastView()
        toast.showToast("保存成功")
        
        rebuildFace()
    }
    
    //重新显示界面
    func rebuildFace(){
        //删除页面元素
        let uiViews = self.view.subviews
        for view in uiViews{
            view.removeFromSuperview()
        }
        
        setUpData()
        setUpEles()
        setUpElesCon()
    }
    
    //删除数据库，type＝0的，＝1的是年消费的
    func deleteSQLData(){
        let costArray = Cost.selectAllData()
        var count = 0
        for i in 0 ..< costArray.count{
            let type = (costArray.object(at: i) as AnyObject).value(forKey: costNameOfPeriod) as! Int
            if type == 0 {
                count += 1
            }
        }
        
        for _ in 0 ..< count {
            let TempCostArray = Cost.selectAllData()
            for j in 0 ..< TempCostArray.count{
                let type = (TempCostArray.object(at: j) as AnyObject).value(forKey: costNameOfPeriod) as! Int
                if type == 0 {
                    Cost.deleteData(j)
                    break
                }
            }
        }
    }
    
    //添加数据时，显示的两个输入框，用tag区分
    func addCost(){
        let nameTextSize = sizeWithText("本月已用", font: introduceFont, maxSize: CGSize(width: self.view.frame.width/2, height: 30))
        let nameText = UITextField.inputTextField()
        nameText.frame = CGRect(x: 20, y: lastY!+gap!, width: nameTextSize.width, height: 30)
        nameText.placeholder = "名称"
        nameText.keyboardType = UIKeyboardType.default //激活时
        nameText.returnKeyType = UIReturnKeyType.done //表示完成输入
        nameText.tag = lastTag! + 1
        self.view.addSubview(nameText)
        
        let lb = UILabel(frame: CGRect(x: nameText.frame.maxX, y: nameText.frame.minY, width: 20, height: 30))
        lb.text = "："
        self.view.addSubview(lb)
        
        let numberText = UITextField.inputTextField()
        numberText.frame = CGRect(x: lb.frame.maxX, y: nameText.frame.minY, width: self.view.frame.size.width-lb.frame.maxX-20, height: 30)
        numberText.placeholder = "金额"
        numberText.keyboardType = UIKeyboardType.decimalPad //激活时
        numberText.returnKeyType = UIReturnKeyType.done //表示完成输入
        numberText.tag = lastTag! + 2
        self.view.addSubview(numberText)
        
        lastY = numberText.frame.maxY
        lastTag = numberText.tag
        
        self.saveBtn!.frame = CGRect(x: 20, y: lastY!+gap!*3, width: self.view.frame.size.width-40, height: 44)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
