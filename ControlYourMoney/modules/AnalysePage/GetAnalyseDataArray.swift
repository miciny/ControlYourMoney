//
//  GetAnalyseDataArray.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/19.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class GetAnalyseDataArray: NSObject {
    //根据参数，日 月 年
    class func getCashDetailShowArray(str: String) -> [NSMutableDictionary]{
        //获取数据
        var textData = SQLLine.selectAllData(entityNameOfCash)
        let textDataDic = NSMutableDictionary()
        let textDataTotalDic = NSMutableDictionary()
        
        if textData.count == 0{
            return [textDataDic, textDataTotalDic]
        }
        //排序
        let time = NSSortDescriptor(key: cashNameOfTime, ascending: false)
        textData = textData.sortedArrayUsingDescriptors([time])
        
        //获取时间今天时间
        let textDataTitle = NSMutableArray()
        let timeNow = getTime()
        textDataTitle.addObject(dateToStringBySelf(timeNow, str: str))
        
        //计算今天总额总额
        let textDataTmp = NSMutableArray()
        var dayTotal: Float = 0
        
        for j in 0 ..< textData.count{
            if(dateToStringBySelf(textData.objectAtIndex(j).valueForKey(cashNameOfTime) as! NSDate, str: str) == textDataTitle[0] as! String){
                
                let useWhere = (textData.objectAtIndex(j).valueForKey(cashNameOfUseWhere) as! String)
                let useNumber = "-" + String(textData.objectAtIndex(j).valueForKey(cashNameOfUseNumber) as! Float)
                let useTime = dateToString(textData.objectAtIndex(j).valueForKey(cashNameOfTime) as! NSDate)
                let type = (textData.objectAtIndex(j).valueForKey(cashNameOfType) as! String)
                let TempModul = CashDetailTableDataModul(useWhere: useWhere, useNumber: useNumber, useTime: useTime, type: type)
                textDataTmp.addObject(TempModul)
                
                if(textData.objectAtIndex(j).valueForKey(cashNameOfUseNumber) as! Float > 0){
                    dayTotal += textData.objectAtIndex(j).valueForKey(cashNameOfUseNumber) as! Float
                }
            }
        }
        textDataTotalDic.setObject(dayTotal, forKey: textDataTitle[0] as! String)
        textDataDic.setObject(textDataTmp.copy(), forKey: textDataTitle[0] as! String)
        return [textDataDic, textDataTotalDic]
    }
    
    //现金本日列表页
    class func getTodayCashDetailShowArray() -> [NSMutableDictionary]{
        //获取数据
        var data = [NSMutableDictionary]()
        data = getCashDetailShowArray("yyyy-MM-dd")
        return data
    }
    
    //现金本月列表页
    class func getThisMonthCashDetailShowArray() -> [NSMutableDictionary]{
        //获取数据
        var data = [NSMutableDictionary]()
        data = getCashDetailShowArray("yyyy-MM")
        return data
    
    }
}
