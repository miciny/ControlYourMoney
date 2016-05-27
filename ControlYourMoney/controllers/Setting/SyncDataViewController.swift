//
//  SyncDataViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/27.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import SwiftyJSON

class SyncDataViewController: UIViewController {

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
    
    func setUpBtn(){
        let upLoad = UIButton()
        upLoad.frame = CGRect(x: 20, y: 100, width: Width-40, height: 50)
        upLoad.backgroundColor = UIColor(red: 0/255, green: 205/255, blue: 0/255, alpha: 1.0)
        upLoad.setTitle("上传数据", forState: .Normal)
        upLoad.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        upLoad.layer.cornerRadius = 5
        upLoad.addTarget(self, action: #selector(upLoadData), forControlEvents: .TouchUpInside)
        self.view.addSubview(upLoad)
        
        let downLoad = UIButton()
        downLoad.frame = CGRect(x: 20, y: upLoad.frame.maxY+20, width: Width-40, height: 50)
        downLoad.backgroundColor = UIColor.whiteColor()
        downLoad.setTitle("下载数据", forState: .Normal)
        downLoad.setTitleColor(UIColor.blackColor(), forState: .Normal)
        downLoad.addTarget(self, action: #selector(downLoadData), forControlEvents: .TouchUpInside)
        downLoad.layer.cornerRadius = 5
        self.view.addSubview(downLoad)
    }
    
    func downLoadData(){
        var json: JSON = JSON.null
        
        if let file = NSBundle.mainBundle().pathForResource("json", ofType: "json") {
            let data = NSData(contentsOfFile: file)!
            json = JSON(data: data)
        }
        
        let cashDic = json[entityNameOfCash]
        for i in 0 ..< cashDic.count {
            let row = cashDic[i]
            
            let time = row[cashNameOfTime].stringValue
            let type = row[cashNameOfType].stringValue
            let useWhere = row[cashNameOfUseWhere].stringValue
            let useNumber = row[cashNameOfUseNumber].stringValue
            
            print(time)
            print(type)
            print(useWhere)
            print(useNumber)
        }
    }
    
    
    
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
