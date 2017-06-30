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
    class func getCashDetailShowArray(_ str: String) -> [NSMutableDictionary]{
        //获取数据
        var textData = Cash.selectAllData()
        let textDataDic = NSMutableDictionary()
        let textDataTotalDic = NSMutableDictionary()
        
        if textData.count == 0{
            return [textDataDic, textDataTotalDic]
        }
        //排序
        let time = NSSortDescriptor(key: cashNameOfTime, ascending: false)
        textData = textData.sortedArray(using: [time])
        
        //获取时间今天时间
        let textDataTitle = NSMutableArray()
        let timeNow = getTime()
        textDataTitle.add(dateToStringBySelf(timeNow, str: str))
        
        //计算今天总额总额
        let textDataTmp = NSMutableArray()
        var dayTotal: Float = 0
        
        for j in 0 ..< textData.count{
            if(dateToStringBySelf(textData.object(at: j).value(forKey: cashNameOfTime) as! Date, str: str) == textDataTitle[0] as! String){
                
                let useWhere = ((textData.object(at: j) as AnyObject).value(forKey: cashNameOfUseWhere) as! String)
                let useNumber = "-" + String((textData.object(at: j) as AnyObject).value(forKey: cashNameOfUseNumber) as! Float)
                let useTime = dateToString(textData.object(at: j).value(forKey: cashNameOfTime) as! Date)
                let type = ((textData.object(at: j) as AnyObject).value(forKey: cashNameOfType) as! String)
                let TempModul = CashDetailTableDataModul(useWhere: useWhere, useNumber: useNumber, useTime: useTime, type: type)
                textDataTmp.add(TempModul)
                
                if((textData.object(at: j) as AnyObject).value(forKey: cashNameOfUseNumber) as! Float > 0){
                    dayTotal += (textData.object(at: j) as AnyObject).value(forKey: cashNameOfUseNumber) as! Float
                }
            }
        }
        textDataTotalDic.setObject(dayTotal, forKey: textDataTitle[0] as! String as NSCopying)
        textDataDic.setObject(textDataTmp.copy(), forKey: textDataTitle[0] as! String as NSCopying)
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
    
    //因为自动还款的时间是
    //本月信用卡列表，包括还完的  , 下期还款时间是本月（不用判断剩余周期） 或 下期还款时间是下月但剩余周期小于总周期 (剩余周期此时不会为0)
    class func getThisMonthCreditListIncludeDone() -> [MainTableCreditModul]?{
        var creditArray = Credit.selectAllData()
        
        if creditArray.count == 0 {
            return nil
        }
        
        let timeNow = getTime()
        let timeStr = dateToStringBySelf(timeNow, str: "yyyy-MM")
        let nextTimeStr = dateToStringBySelf(CalculateCredit.calculateTime(timeNow, months: 1), str: "yyyy-MM")
        
        let time = NSSortDescriptor.init(key: creditNameOfNextPayDay, ascending: true)
        creditArray = creditArray.sortedArray(using: [time])
        
        var creditModul = [MainTableCreditModul]()
        let creditArrayCount = creditArray.count
        
        for i in 0 ..< creditArrayCount {
            
            let nextPayDay = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfNextPayDay) as! Date  // 下期还款日期
            let leftPeriods = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfLeftPeriods) as! Int  // 剩余还款期数
            let periods = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfPeriods) as! Int  // 还款期数
            let nextStr = dateToStringBySelf(nextPayDay, str: "yyyy-MM")
            
            if timeStr == nextStr || (nextTimeStr == nextStr && leftPeriods < periods){
                let type = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfType) as! String
                let number = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfNumber) as! Float // 每期还款金额
                let all = "-" + String(Float(leftPeriods) * number) // 总还款金额
                let accout = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfAccount)  as? String  // 账户
                
                let title = accout! + "—" + type
                
                let timeStr = dateToStringNoHH(nextPayDay) // 下期还款时间
                let dateStr = String((creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfDate) as! Int)  // 每期还款日期
                
                let tempCreditModul = MainTableCreditModul(periods: String(leftPeriods), number: String(number), title: title, all: all, time: timeStr, date: dateStr, account: accout, type: type, allPeriods: String(periods), index: i)
                creditModul.append(tempCreditModul)
            }
        }
        return creditModul
    }
    
    //本月信用卡列表，包括还完的  , 下期还款时间是本月
    class func getThisMonthCreditList() -> [MainTableCreditModul]?{
        var creditArray = Credit.selectAllData()
        
        if creditArray.count == 0 {
            return nil
        }
        
        let timeNow = getTime()
        let timeStr = dateToStringBySelf(timeNow, str: "yyyy-MM")
        
        let time = NSSortDescriptor.init(key: creditNameOfNextPayDay, ascending: true)
        creditArray = creditArray.sortedArray(using: [time])
        
        var creditModul = [MainTableCreditModul]()
        let creditArrayCount = creditArray.count
        
        for i in 0 ..< creditArrayCount {
            
            let nextPayDay = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfNextPayDay) as! Date  // 下期还款日期
            let leftPeriods = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfLeftPeriods) as! Int  // 剩余还款期数
            let nextStr = dateToStringBySelf(nextPayDay, str: "yyyy-MM")
            
            if timeStr == nextStr{
                let type = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfType) as! String
                let number = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfNumber) as! Float // 每期还款金额
                let all = "-" + String(Float(leftPeriods) * number) // 总还款金额
                let accout = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfAccount)  as? String  // 账户
                let title = accout! + "—" + type
                let timeStr = dateToStringNoHH(nextPayDay) // 下期还款时间
                let dateStr = String((creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfDate) as! Int)  // 每期还款日期
                let periods = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfPeriods) as! Int  // 还款期数
                
                let tempCreditModul = MainTableCreditModul(periods: String(leftPeriods), number: String(number), title: title, all: all, time: timeStr, date: dateStr, account: accout, type: type, allPeriods: String(periods), index: i)
                creditModul.append(tempCreditModul)
            }
            
        }
        return creditModul
    }
    
    //下月信用卡列表，不包括还完的  , 下期还款时间是下月 并 剩余周期大于0  下期还款时间是本月，并剩余周期大于1
    class func getNextMonthCreditList() -> [MainTableCreditModul]?{
        var creditArray = Credit.selectAllData()
        
        if creditArray.count == 0 {
            return nil
        }
        
        let timeNow = getTime()
        let timeStr = dateToStringBySelf(timeNow, str: "yyyy-MM")
        let nextTimeStr = dateToStringBySelf(CalculateCredit.calculateTime(timeNow, months: 1), str: "yyyy-MM")
        
        let time = NSSortDescriptor.init(key: creditNameOfNextPayDay, ascending: true)
        creditArray = creditArray.sortedArray(using: [time])
        
        var creditModul = [MainTableCreditModul]()
        let creditArrayCount = creditArray.count
        
        for i in 0 ..< creditArrayCount {
            
            let nextPayDay = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfNextPayDay) as! Date  // 下期还款日期
            let leftPeriods = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfLeftPeriods) as! Int  // 剩余还款期数
            let nextStr = dateToStringBySelf(nextPayDay, str: "yyyy-MM")
            
            if (timeStr == nextStr && leftPeriods > 1) || (nextTimeStr == nextStr && leftPeriods > 0){
                let type = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfType) as! String
                let number = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfNumber) as! Float // 每期还款金额
                let all = "-" + String(Float(leftPeriods) * number) // 总还款金额
                let periods = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfPeriods) as! Int  // 还款期数
                let accout = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfAccount)  as? String  // 账户
                
                let title = accout! + "—" + type
                
                let timeStr = dateToStringNoHH(nextPayDay) // 下期还款时间
                let dateStr = String((creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfDate) as! Int)  // 每期还款日期
                
                let tempCreditModul = MainTableCreditModul(periods: String(leftPeriods), number: String(number), title: title, all: all, time: timeStr, date: dateStr, account: accout, type: type, allPeriods: String(periods), index: i)
                creditModul.append(tempCreditModul)
            }
        }
        return creditModul
    }
    
    //所有信用卡余还列表，不包括还完的  , 只要剩余周期大于0
    class func getAllCreditLeftpayList() -> [MainTableCreditModul]?{
        var creditArray = Credit.selectAllData()
        
        if creditArray.count == 0 {
            return nil
        }
        
        let time = NSSortDescriptor.init(key: creditNameOfNextPayDay, ascending: true)
        creditArray = creditArray.sortedArray(using: [time])
        
        var creditModul = [MainTableCreditModul]()
        let creditArrayCount = creditArray.count
        
        for i in 0 ..< creditArrayCount {
            
            let nextPayDay = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfNextPayDay) as! Date  // 下期还款日期
            let leftPeriods = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfLeftPeriods) as! Int  // 剩余还款期数
            
            if leftPeriods > 0{
                let type = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfType) as! String
                let number = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfNumber) as! Float // 每期还款金额
                let all = "-" + String(Float(leftPeriods) * number) // 总还款金额
                let accout = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfAccount)  as? String  // 账户
                
                let title = accout! + "—" + type
                
                let timeStr = dateToStringNoHH(nextPayDay) // 下期还款时间
                let dateStr = String((creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfDate) as! Int)  // 每期还款日期
                let periods = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfPeriods) as! Int  // 还款期数
        
                let tempCreditModul = MainTableCreditModul(periods: String(leftPeriods), number: String(number), title: title, all: all, time: timeStr, date: dateStr, account: accout, type: type, allPeriods: String(periods), index: i)
                creditModul.append(tempCreditModul)
            }
        }
        return creditModul
    }
    
    //今年信用卡总还列表，包括还完的  , 第一期的还款时间是本年
    class func getThisYearCreditInludeDoneList() -> [MainTableCreditModul]?{
        var creditArray = Credit.selectAllData()
        
        if creditArray.count == 0 {
            return nil
        }
        
        let timeNow = getTime()
        
        let time = NSSortDescriptor.init(key: creditNameOfNextPayDay, ascending: true)
        creditArray = creditArray.sortedArray(using: [time])
        
        var creditModul = [MainTableCreditModul]()
        let creditArrayCount = creditArray.count
        
        for i in 0 ..< creditArrayCount {
            let time = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfTime) as! Date  // 记账日期
            let date = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfDate) as! Int  // 还款日
            let firstPayDay = CalculateCredit.getFirstPayDate(time, day: date)
            
            if timeNow.currentYear == firstPayDay.currentYear{
                let nextPayDay = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfNextPayDay) as! Date  // 下期还款日期
                let leftPeriods = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfLeftPeriods) as! Int  // 剩余还款期数
                let type = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfType) as! String
                let number = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfNumber) as! Float // 每期还款金额
                let all = "-" + String(Float(leftPeriods) * number) // 总还款金额
                let accout = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfAccount)  as? String  // 账户
                let periods = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfPeriods) as! Int  // 还款期数
                
                let title = accout! + "—" + type
                
                let timeStr = dateToStringNoHH(nextPayDay) // 下期还款时间
                let dateStr = String((creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfDate) as! Int)  // 每期还款日期
                
                let tempCreditModul = MainTableCreditModul(periods: String(leftPeriods), number: String(number), title: title, all: all, time: timeStr, date: dateStr, account: accout, type: type, allPeriods: String(periods), index: i)
                creditModul.append(tempCreditModul)
            }
        }
        return creditModul
    }
    
    //今年信用卡余还列表，不包括还完的  , 下期的还款时间是本年 并 剩余周期大于0
    class func getThisYearLeftPayList() -> [MainTableCreditModul]?{
        var creditArray = Credit.selectAllData()
        
        if creditArray.count == 0 {
            return nil
        }
        
        let time = NSSortDescriptor.init(key: creditNameOfNextPayDay, ascending: true)
        creditArray = creditArray.sortedArray(using: [time])
        
        var creditModul = [MainTableCreditModul]()
        let creditArrayCount = creditArray.count
        
        for i in 0 ..< creditArrayCount {
            
            let nextPayDay = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfNextPayDay) as! Date  // 下期还款日期
            let leftPeriods = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfLeftPeriods) as! Int  // 剩余还款期数
            
            if nextPayDay.currentYear == getTime().currentYear && leftPeriods > 0{
                let type = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfType) as! String
                let number = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfNumber) as! Float // 每期还款金额
                let all = "-" + String(Float(leftPeriods) * number) // 总还款金额
                let accout = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfAccount)  as? String  // 账户
                
                let title = accout! + "—" + type
                
                let timeStr = dateToStringNoHH(nextPayDay) // 下期还款时间
                let dateStr = String((creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfDate) as! Int)  // 每期还款日期
                let periods = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfPeriods) as! Int  // 还款期数
                
                let tempCreditModul = MainTableCreditModul(periods: String(leftPeriods), number: String(number), title: title, all: all, time: timeStr, date: dateStr, account: accout, type: type, allPeriods: String(periods), index: i)
                creditModul.append(tempCreditModul)
            }
        }
        return creditModul
    }

    
    //实际本月支出列表数据
    class func getThisMonthRealPay() -> NSMutableDictionary{
        let AllData = NSMutableDictionary()
        let creditModul =  GetAnalyseDataArray.getThisMonthCreditListIncludeDone()
        let cashModul =  GetDataArray.getCashShowArray()
        
        if creditModul != nil {
            AllData.setObject(creditModul!, forKey: keyOfCredit as NSCopying)
        }
        if cashModul != nil {
            AllData.setObject(cashModul!, forKey: keyOfCash as NSCopying)
        }
        return AllData
    }
    
    //本月信用总还列表数据
    class func getThisCreditRealPay() -> NSMutableDictionary{
        let AllData = NSMutableDictionary()
        let creditModul =  GetAnalyseDataArray.getThisMonthCreditListIncludeDone()
        
        if creditModul != nil {
            AllData.setObject(creditModul!, forKey: keyOfCredit as NSCopying)
        }
        return AllData
    }
    
    //本月信用余还列表数据
    class func getThisCreditLeftPay() -> NSMutableDictionary{
        let AllData = NSMutableDictionary()
        let creditModul =  GetAnalyseDataArray.getThisMonthCreditList()
        
        if creditModul != nil {
            AllData.setObject(creditModul!, forKey: keyOfCredit as NSCopying)
        }
        return AllData
    }
    
    //下月信用总还列表数据
    class func getNextMonthCreditPay() -> NSMutableDictionary{
        let AllData = NSMutableDictionary()
        let creditModul =  GetAnalyseDataArray.getNextMonthCreditList()
        
        if creditModul != nil {
            AllData.setObject(creditModul!, forKey: keyOfCredit as NSCopying)
        }
        return AllData
    }
    
    //所有信用余还列表数据，不包括已还完的
    class func getAllCreditLeftPay() -> NSMutableDictionary{
        let AllData = NSMutableDictionary()
        let creditModul =  GetAnalyseDataArray.getAllCreditLeftpayList()
        
        if creditModul != nil {
            AllData.setObject(creditModul!, forKey: keyOfCredit as NSCopying)
        }
        return AllData
    }
    
    //今年信用总还列表数据，包括已还完的
    class func getThisYearCreditPayIncludeDone() -> NSMutableDictionary{
        let AllData = NSMutableDictionary()
        let creditModul =  GetAnalyseDataArray.getThisYearCreditInludeDoneList()
        
        if creditModul != nil {
            AllData.setObject(creditModul!, forKey: keyOfCredit as NSCopying)
        }
        return AllData
    }
    
    //今年信用余还列表数据，不包括已还完的
    class func getThisYearCreditLeftPay() -> NSMutableDictionary{
        let AllData = NSMutableDictionary()
        let creditModul =  GetAnalyseDataArray.getThisYearLeftPayList()
        
        if creditModul != nil {
            AllData.setObject(creditModul!, forKey: keyOfCredit as NSCopying)
        }
        return AllData
    }
}
