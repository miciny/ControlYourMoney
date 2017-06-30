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
        var textData = Cash.selectAllData()
        let textDataDic = NSMutableDictionary()
        let textDataTotalDic = NSMutableDictionary()
        
        if textData.count == 0{
            return [textDataDic, textDataTotalDic]
        }
        
        let textDataTitle = NSMutableArray()
        
        //排序
        let time = NSSortDescriptor(key: cashNameOfTime, ascending: false)
        textData = textData.sortedArray(using: [time])
        
        //获取时间序列
        let textDataTmp = NSMutableArray()
        for i in 0 ..< (textData.value(forKey: cashNameOfTime) as AnyObject).count{
            textDataTmp.add(dateToStringBySelf(textData.object(at: i).value(forKey: cashNameOfTime) as! Date, str: "yyyy-MM"))
        }
        
        //去重,时间在同一个月的
        for i in 0 ..< textDataTmp.count{
            if(textDataTitle.contains(textDataTmp[i]) == false){
                textDataTitle.add(textDataTmp[i])
            }
        }
        
        //计算这个月总额
        textDataTmp.removeAllObjects()
        var monthTotal: Float = 0
        
        for i in 0 ..< textDataTitle.count{
            monthTotal = 0
            textDataTmp.removeAllObjects()
            for j in 0 ..< textData.count{
                if(dateToStringBySelf(textData.object(at: j).value(forKey: cashNameOfTime) as! Date, str: "yyyy-MM") == textDataTitle[i] as! String){
                    
                    let useWhere = ((textData.object(at: j) as AnyObject).value(forKey: cashNameOfUseWhere) as! String)
                    let useNumber = "-" + String((textData.object(at: j) as AnyObject).value(forKey: cashNameOfUseNumber) as! Float)
                    let useTime = dateToString(textData.object(at: j).value(forKey: cashNameOfTime) as! Date)
                    let type = ((textData.object(at: j) as AnyObject).value(forKey: cashNameOfType) as! String)
                    let TempModul = CashDetailTableDataModul(useWhere: useWhere, useNumber: useNumber, useTime: useTime, type: type)
                    textDataTmp.add(TempModul)
                    
                    if((textData.object(at: j) as AnyObject).value(forKey: cashNameOfUseNumber) as! Float > 0){
                        monthTotal = monthTotal + ((textData.object(at: j) as AnyObject).value(forKey: cashNameOfUseNumber) as! Float)
                    }
                }
            }
            textDataTotalDic.setObject(monthTotal, forKey: textDataTitle[i] as! String as NSCopying)
            textDataDic.setObject(textDataTmp.copy(), forKey: textDataTitle[i] as! String as NSCopying)
        }
        
        return [textDataDic, textDataTotalDic]
    }
    
    
    //工资详细列表页
    class func getSalaryDetailShowArray() -> [SalaryDetailTableDataModul]?{
        
        var textData = Salary.selectAllData()
        
        if textData.count == 0 {
            return nil
        }
        
        var AllData = [SalaryDetailTableDataModul]()
        let time : NSSortDescriptor = NSSortDescriptor(key: incomeOfTime, ascending: false)
        textData = textData.sortedArray(using: [time])
        
        for i in 0 ..< textData.count {
            let type = ((textData.object(at: i)) as AnyObject).value(forKey: incomeOfName) as! String
            let date = String(((textData.object(at: i) as AnyObject).value(forKey: incomeOfTime) as! Date).currentMonth) + "月" + keyOfIncome
            let number = String(((textData.object(at: i)) as AnyObject).value(forKey: incomeOfNumber) as! Float)
            let time = dateToStringNoHH((textData.object(at: i)).value(forKey: incomeOfTime) as! Date)
            let tempModul = SalaryDetailTableDataModul(time: time, number: number, date: date, type: type)
            AllData.append(tempModul)
        }
        return AllData
    }
    
    //首页应该展示的现金列表
    class func getCashShowArray() -> [MainTableCashModul]?{
        let cashArray = Cash.selectAllData()
        
        if cashArray.count == 0 {
            return nil
        }
        var cashModul = [MainTableCashModul]()
        
        let type = (cashArray.lastObject! as AnyObject).value(forKey: cashNameOfType) as? String
        let useWhere = (cashArray.lastObject! as AnyObject).value(forKey: cashNameOfUseWhere) as? String
        let title = type! + "—" + useWhere!
        let useNumber = String((cashArray.lastObject! as AnyObject).value(forKey: cashNameOfUseNumber) as! Float)
        let useTime = dateToString(cashArray.lastObject!.value(forKey: cashNameOfTime) as! Date)
        
        let useTotalDay = GetAnalyseData.getTodayUse()
        let useTotal = GetAnalyseData.getThisMonthUse()
        let useTotalDayStr = String(useTotalDay)
        let useTotalStr = String(useTotal)
        let tempCashModul = MainTableCashModul(useWhere: title, useNumber: useNumber, useTime: useTime, useTotalDayStr: useTotalDayStr, useTotalStr: useTotalStr)
        cashModul.append(tempCashModul)
        
        return cashModul
    }
    
    //首页应该展示的工资列表
    
    class func getSalaryShowArray() -> [MainTableSalaryModul]?{
        
        let salaryArray = Salary.selectAllData()
        
        if salaryArray.count == 0 {
            return nil
        }
        
        var salaryModul = [MainTableSalaryModul]()
        
        let type = (salaryArray.lastObject! as AnyObject).value(forKey: incomeOfName) as! String
        let title = String(((salaryArray.lastObject! as AnyObject).value(forKey: incomeOfTime) as! Date).currentMonth)+"月"+keyOfIncome + "—" + type
        let number = String((salaryArray.lastObject! as AnyObject).value(forKey: incomeOfNumber) as! Float)
        let time = dateToStringNoHH(salaryArray.lastObject!.value(forKey: incomeOfTime) as! Date)
        let tempSalaryModul = MainTableSalaryModul(number: number, date: title, time: time)
        salaryModul.append(tempSalaryModul)
        
        return salaryModul
    }
    
    
    //首页应该展示的信用卡列表
    class func getCreditShowArray() -> [MainTableCreditModul]?{
        
        var creditArray = Credit.selectAllData()
        
        if creditArray.count == 0 {
            return nil
        }
        
        let time = NSSortDescriptor.init(key: creditNameOfNextPayDay, ascending: true)
        creditArray = creditArray.sortedArray(using: [time])
        
        var creditModul = [MainTableCreditModul]()
        let creditArrayCount = creditArray.count
        
        for i in 0 ..< creditArrayCount {
            let leftPeriods = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfLeftPeriods) as! Int  // 剩余还款期数
            
            if leftPeriods > 0 {
                let type = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfType) as! String
                let number = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfNumber) as! Float // 每期还款金额
                let all = "-" + String(Float(leftPeriods) * number) // 总还款金额
                let accout = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfAccount)  as? String  // 账户
                let nextPayDay = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfNextPayDay) as! Date  // 下期还款日期
                let periods = (creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfPeriods) as! Int  //  总还款期数
                
                let title = accout! + "—" + type
                
                let timeStr = dateToStringNoHH(nextPayDay) // 下期还款时间
                let dateStr = String((creditArray.object(at: i) as AnyObject).value(forKey: creditNameOfDate) as! Int)  // 每期还款日期
                
                let periodsStr = String(leftPeriods) //
                let tempCreditModul = MainTableCreditModul(periods: periodsStr, number: String(number), title: title, all: all, time: timeStr, date: dateStr, account: accout, type: type, allPeriods: String(periods), index: i)
                creditModul.append(tempCreditModul)
            }
        }
        return creditModul
    }
}
