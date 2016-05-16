//
//  GetDataArray.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/13.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class GetDataArray: NSObject {
    //现金详细列表页
    class func getCashDetailShowArray() -> [NSMutableDictionary]{
        //获取数据
        var textData = SQLLine.selectAllData(entityNameOfCash)
        let textDataDic = NSMutableDictionary()
        let textDataTotalDic = NSMutableDictionary()
        
        if textData.count == 0{
            return [textDataDic, textDataTotalDic]
        }
        
        let textDataTitle = NSMutableArray()
        
        //排序
        let time = NSSortDescriptor.init(key: salaryNameOfTime, ascending: false)
        textData = textData.sortedArrayUsingDescriptors([time])
        
        //获取时间序列
        let textDataTmp = NSMutableArray()
        for i in 0 ..< textData.valueForKey(cashNameOfTime).count{
            textDataTmp.addObject(dateToStringBySelf(textData.objectAtIndex(i).valueForKey(cashNameOfTime) as! NSDate, str: "yyyy-MM"))
        }
        
        //去重,时间在同一个月的
        for i in 0 ..< textDataTmp.count{
            if(textDataTitle.containsObject(textDataTmp[i]) == false){
                textDataTitle.addObject(textDataTmp[i])
            }
        }
        
        //计算这个月总额
        textDataTmp.removeAllObjects()
        var monthTotal: Float = 0
        
        for i in 0 ..< textDataTitle.count{
            monthTotal = 0
            textDataTmp.removeAllObjects()
            for j in 0 ..< textData.count{
                if(dateToStringBySelf(textData.objectAtIndex(j).valueForKey(cashNameOfTime) as! NSDate, str: "yyyy-MM") == textDataTitle[i] as! String){
                    
                    let useWhere = (textData.objectAtIndex(j).valueForKey(cashNameOfUseWhere) as! String)
                    let useNumber = "-" + String(textData.objectAtIndex(j).valueForKey(cashNameOfUseNumber) as! Float)
                    let useTime = dateToString(textData.objectAtIndex(j).valueForKey(cashNameOfTime) as! NSDate)
                    let TempModul = CashDetailTableDataModul(useWhere: useWhere, useNumber: useNumber, useTime: useTime)
                    textDataTmp.addObject(TempModul)
                    
                    if(textData.objectAtIndex(j).valueForKey(cashNameOfUseNumber) as! Float > 0){
                        monthTotal = monthTotal + (textData.objectAtIndex(j).valueForKey(cashNameOfUseNumber) as! Float)
                    }
                }
            }
            textDataTotalDic.setObject(monthTotal, forKey: textDataTitle[i] as! String)
            textDataDic.setObject(textDataTmp.copy(), forKey: textDataTitle[i] as! String)
        }
        
        return [textDataDic, textDataTotalDic]
    }
    
    
    //工资详细列表页
    class func getSalaryDetailShowArray() -> [SalaryDetailTableDataModul]?{
        
        var textData = SQLLine.selectAllData(entityNameOfSalary)
        
        if textData.count == 0 {
            return nil
        }
        
        var AllData = [SalaryDetailTableDataModul]()
        let time : NSSortDescriptor = NSSortDescriptor.init(key: salaryNameOfTime, ascending: false)
        textData = textData.sortedArrayUsingDescriptors([time])
        
        for i in 0 ..< textData.count {
            let date = String((textData.objectAtIndex(i).valueForKey(salaryNameOfTime) as! NSDate).currentMonth) + "月" + keyOfSalary
            let number = String((textData.objectAtIndex(i)).valueForKey(salaryNameOfNumber) as! Float)
            let time = dateToStringNoHH((textData.objectAtIndex(i)).valueForKey(salaryNameOfTime) as! NSDate)
            let tempModul = SalaryDetailTableDataModul(time: time, number: number, date: date)
            AllData.append(tempModul)
        }
        return AllData
    }
    
    //首页应该展示的现金列表
    class func getCashShowArray() -> [MainTableCashModul]?{
        let cashArray = SQLLine.selectAllData(entityNameOfCash)
        
        if cashArray.count == 0 {
            return nil
        }
        var cashModul = [MainTableCashModul]()
        
        let useWhere = cashArray.lastObject!.valueForKey(cashNameOfUseWhere) as? String
        let useNumber = String(cashArray.lastObject!.valueForKey(cashNameOfUseNumber) as! Float)
        let useTime = dateToString(cashArray.lastObject!.valueForKey(cashNameOfTime) as! NSDate)
        
        let useTotalDay = GetAnalyseData.getTodayUse()
        let useTotal = GetAnalyseData.getThisMonthUse()
        let useTotalDayStr = String(useTotalDay)
        let useTotalStr = String(useTotal)
        let tempCashModul = MainTableCashModul(useWhere: useWhere, useNumber: useNumber, useTime: useTime, useTotalDayStr: useTotalDayStr, useTotalStr: useTotalStr)
        cashModul.append(tempCashModul)
        
        return cashModul
    }
    
    //首页应该展示的工资列表
    
    class func getSalaryShowArray() -> [MainTableSalaryModul]?{
        
        let salaryArray = SQLLine.selectAllData(entityNameOfSalary)
        
        if salaryArray.count == 0 {
            return nil
        }
        
        var salaryModul = [MainTableSalaryModul]()
        
        let date = String((salaryArray.lastObject!.valueForKey(salaryNameOfTime) as! NSDate).currentMonth) + "月" + keyOfSalary
        let number = String(salaryArray.lastObject!.valueForKey(salaryNameOfNumber) as! Float)
        let time = dateToStringNoHH(salaryArray.lastObject!.valueForKey(salaryNameOfTime) as! NSDate)
        let tempSalaryModul = MainTableSalaryModul(number: number, date: date, time: time)
        salaryModul.append(tempSalaryModul)
        
        return salaryModul
    }
    
    
    //首页应该展示的信用卡列表
    class func getCreditShowArray() -> [MainTableCreditModul]?{
        
        var creditArray = SQLLine.selectAllData(entityNameOfCredit)
        
        if creditArray.count == 0 {
            return nil
        }
        
        let time = NSSortDescriptor.init(key: creditNameOfNextPayDay, ascending: true)
        creditArray = creditArray.sortedArrayUsingDescriptors([time])
        
        var creditModul = [MainTableCreditModul]()
        let creditArrayCount = creditArray.count
        
        for i in 0 ..< creditArrayCount {
            let number = String(creditArray.objectAtIndex(i).valueForKey(creditNameOfNumber) as! Float) // 每期还款金额
            let all = "-" + String(Float(creditArray.objectAtIndex(i).valueForKey(creditNameOfPeriods) as! NSInteger) *
                (creditArray.objectAtIndex(i).valueForKey(creditNameOfNumber) as! Float)) // 总还款金额
            let accout = creditArray.objectAtIndex(i).valueForKey(creditNameOfAccount)  as? String  // 账户
            let nextPayDay = creditArray.objectAtIndex(i).valueForKey(creditNameOfNextPayDay) as! NSDate  // 下期还款日期
            let leftPeriods = creditArray.objectAtIndex(i).valueForKey(creditNameOfLeftPeriods) as! Int  // 剩余还款期数
            
            let timeStr = dateToStringNoHH(nextPayDay) // 下期还款时间
            let dateStr = String(creditArray.objectAtIndex(i).valueForKey(creditNameOfDate) as! Int)  // 每期还款日期
            
            if leftPeriods > 0 {
                let periodsStr = String(leftPeriods) //
                let tempCreditModul = MainTableCreditModul(periods: periodsStr, number: number, accout: accout, all: all, time: timeStr, date: dateStr)
                creditModul.append(tempCreditModul)
            }
        }
        return creditModul
    }
}