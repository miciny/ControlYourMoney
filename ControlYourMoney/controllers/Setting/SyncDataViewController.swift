//
//  SyncDataViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/27.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//


//=====================================================================================================
/**
 MARK: - 同步数据使
 **/
//=====================================================================================================

import UIKit
import SwiftyJSON

class SyncDataViewController: UIViewController {
    let downLoad = UIButton()
    let textView = UITextView()
    let copyBtn = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitle()
        setUpBtn()
        // Do any additional setup after loading the view.
    }
    
    func setUpTitle(){
        self.title = "说明"
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
    }
    
    //设置按钮
    func setUpBtn(){
        let upLoad = UIButton()
        upLoad.frame = CGRect(x: 20, y: 80, width: Width-40, height: 50)
        upLoad.backgroundColor = UIColor(red: 0/255, green: 205/255, blue: 0/255, alpha: 1.0)
        upLoad.setTitle("上传数据", forState: .Normal)
        upLoad.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        upLoad.layer.cornerRadius = 5
        upLoad.addTarget(self, action: #selector(upLoadData), forControlEvents: .TouchUpInside)
        self.view.addSubview(upLoad)
        
        downLoad.frame = CGRect(x: 20, y: upLoad.frame.maxY+20, width: Width-40, height: 50)
        downLoad.backgroundColor = UIColor.whiteColor()
        downLoad.setTitle("下载数据", forState: .Normal)
        downLoad.setTitleColor(UIColor.blackColor(), forState: .Normal)
        downLoad.addTarget(self, action: #selector(downLoadData), forControlEvents: .TouchUpInside)
        downLoad.layer.cornerRadius = 5
        self.view.addSubview(downLoad)
        
        copyBtn.frame = CGRect(x: 20, y: downLoad.frame.maxY+10, width: 40, height: 20)
        copyBtn.setTitle("复制", forState: .Normal)
        copyBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
        copyBtn.backgroundColor = UIColor.lightGrayColor()
        copyBtn.addTarget(self, action: #selector(copyText), forControlEvents: .TouchUpInside)
        copyBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        copyBtn.enabled = false
        copyBtn.hidden = true //一开始不显示复制按钮
        self.view.addSubview(copyBtn)
        
        textView.frame = CGRect(x: 20, y: copyBtn.frame.maxY+10, width: Width-40, height: Height-copyBtn.frame.maxY-20)
        textView.backgroundColor = UIColor.clearColor()
        textView.font = standardFont
        textView.textColor = UIColor.blackColor()
        textView.editable = false
        self.view.addSubview(textView)
        
        //这种判断有点问题，先这样吧
        let cash = Cash.selectAllData()
        if cash.count > 0 {
            downLoad.enabled = false
            downLoad.backgroundColor = UIColor.lightGrayColor()
        }
    }
    
    //复制文本
    func copyText(){
        let toast = MyToastView()
        guard let str = textView.text where str != "" else{
            toast.showToast("无数据")
            return
        }
        
        UIPasteboard.generalPasteboard().string = str
        toast.showToast("复制成功")
    }
    
    //下载数据，就是导入数据到数据库
    func downLoadData(){
        let wiatView = MyWaitToast()
        wiatView.title = "计算中..."
        wiatView.showWait(self.view)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),{
            self.insertData()
            dispatch_async(dispatch_get_main_queue(), {
                wiatView.hideView()
                let toast = MyToastView()
                toast.showToast("导入成功！")
                
                self.downLoad.enabled = false
                self.downLoad.backgroundColor = UIColor.lightGrayColor()
            })
        })
    }
    
    //只能导入一次
    func insertData(){
        var json: JSON = JSON.null
        
        if let file = NSBundle.mainBundle().pathForResource("json", ofType: "json") {
            let data = NSData(contentsOfFile: file)!
            json = JSON(data: data)
        }
        
        let cashDic = json[entityNameOfCash]
        if cashDic != nil{
            for i in 0 ..< cashDic.count {
                let row = cashDic[i]
                
                let time = row[cashNameOfTime].stringValue
                let type = row[cashNameOfType].stringValue
                let useWhere = row[cashNameOfUseWhere].stringValue
                let useNumber = row[cashNameOfUseNumber].stringValue
                
                Cash.insertCashData(useWhere, useNumber: Float(useNumber)!, type: type,
                                    time: stringToDateBySelf(time, formate: "yyyy-MM-dd HH:mm:ss.ssss"))
            }
        }
        
        let incomeDic = json[entityNameOfIncome]
        if incomeDic != nil{
            for i in 0 ..< incomeDic.count {
                let row = incomeDic[i]
                
                let time = row[incomeOfTime].stringValue
                let name = row[incomeOfName].stringValue
                let number = row[incomeOfNumber].stringValue
                
                Salary.insertIncomeData(stringToDateBySelf(time, formate: "yyyy-MM-dd HH:mm:ss.ssss"),
                                        number: Float(number)!, name: name)
            }
        }
        
        let incomeNameDic = json[entityNameOfIncomeName]
        if incomeNameDic != nil{
            for i in 0 ..< incomeNameDic.count {
                let row = incomeNameDic[i]
                
                let time = row[incomeNameOfTime].stringValue
                let name = row[incomeNameOfName].stringValue
                
                IncomeName.insertIncomeNameData(stringToDateBySelf(time, formate: "yyyy-MM-dd HH:mm:ss.ssss"), name: name)
            }
        }
        
        let costDic = json[entityNameOfCost]
        if costDic != nil{
            for i in 0 ..< costDic.count {
                let row = costDic[i]
                
                let time = row[costNameOfTime].stringValue
                let name = row[costNameOfName].stringValue
                let type = row[costNameOfType].stringValue
                let number = row[costNameOfNumber].stringValue
                let period = row[costNameOfPeriod].stringValue
                
                Cost.insertCostData(name, time: stringToDateBySelf(time, formate: "yyyy-MM-dd HH:mm:ss.ssss"),
                                    type: type, number: Float(number)!, period: Int(period)!)
            }
        }
        
        let totalDic = json[entityNameOfTotal]
        if totalDic != nil{
            for i in 0 ..< totalDic.count {
                let row = totalDic[i]
                
                let time = row[totalNameOfTime].stringValue
                let canUse = row[totalNameOfCanUse].stringValue
                
                Total.insertTotalData(Float(canUse)!, time: stringToDateBySelf(time, formate: "yyyy-MM-dd HH:mm:ss.ssss"))
            }
        }
        
        let payNameDic = json[entityNameOfPayName]
        if payNameDic != nil{
            for i in 0 ..< payNameDic.count {
                let row = payNameDic[i]
                
                let time = row[payNameNameOfTime].stringValue
                let name = row[payNameNameOfName].stringValue
                
                PayName.insertPayNameData(name, time: stringToDateBySelf(time, formate: "yyyy-MM-dd HH:mm:ss.ssss"))
            }
        }
        
        let creditAccountDic = json[entityNameOfCreditAccount]
        if creditAccountDic != nil{
            for i in 0 ..< creditAccountDic.count {
                let row = creditAccountDic[i]
                
                let time = row[creditAccountNameOfTime].stringValue
                let name = row[creditAccountNameOfName].stringValue
                
                CreditAccount.insertAccountData(name, time: stringToDateBySelf(time, formate: "yyyy-MM-dd HH:mm:ss.ssss"))
            }
        }
        
        let creditDic = json[entityNameOfCredit]
        if creditDic != nil{
            for i in 0 ..< creditDic.count {
                let row = creditDic[i]
                
                let time = row[creditNameOfTime].stringValue
                let account = row[creditNameOfAccount].stringValue
                let date = row[creditNameOfDate].stringValue
                let type = row[creditNameOfType].stringValue
                let number = row[creditNameOfNumber].stringValue
                let periods = row[creditNameOfPeriods].stringValue
                let nextpayDay = row[creditNameOfNextPayDay].stringValue
                let leftPeriods = row[creditNameOfLeftPeriods].stringValue
                
                Credit.insertCrediData(Int(periods)!,
                                       number: Float(number)!,
                                       time: stringToDateBySelf(time, formate: "yyyy-MM-dd HH:mm:ss.ssss"),
                                       account: account,
                                       date: Int(date)!,
                                       nextPayDay: stringToDateBySelf(nextpayDay, formate: "yyyy-MM-dd HH:mm:ss.ssss"),
                                       leftPeriods: Int(leftPeriods)!,
                                       type: type
                )
            }
        }
    }
    
    //上传数据
    func upLoadData(){
        let allDic = NSMutableDictionary()
        allDic.setValue(DataToArray.setCashDataToArray(), forKey: entityNameOfCash)
        
        allDic.setValue(DataToArray.setCostDataToArray(), forKey: entityNameOfCost)
        
        allDic.setValue(DataToArray.setCreditAccountDataToArray(), forKey: entityNameOfCreditAccount)

        allDic.setValue(DataToArray.setCreditDataToArray(), forKey: entityNameOfCredit)
        
        allDic.setValue(DataToArray.setIncomeDataToArray(), forKey: entityNameOfIncome)
        
        allDic.setValue(DataToArray.setIncomeNameDataToArray(), forKey: entityNameOfIncomeName)
        
        allDic.setValue(DataToArray.setPayNameDataToArray(), forKey: entityNameOfPayName)
        
        allDic.setValue(DataToArray.setTotalDataToArray(), forKey: entityNameOfTotal)
        
        let jsonStr = dicToJson(allDic)
        print(jsonStr)
        
        textView.text = ""
        textView.text = jsonStr
        textView.backgroundColor = UIColor.whiteColor()
        
        copyBtn.backgroundColor = UIColor.whiteColor()
        copyBtn.enabled = true
        copyBtn.hidden = false
        
    }

    // 处理数据成json格式
    func dicToJson(dic: NSMutableDictionary) -> String {
        let dataArray = dic
        var str = String()
        
        do {
            let dataFinal = try NSJSONSerialization.dataWithJSONObject(dataArray, options:NSJSONWritingOptions(rawValue:0))
            let string = NSString(data: dataFinal, encoding: NSUTF8StringEncoding)
            str = string as! String
            
        }catch{
            
        }
        return str
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
