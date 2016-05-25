//
//  CalculateCredit.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/16.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation

class CalculateCredit: NSObject {
    
    //获取第一期还款时间
    class func getFirstPayDate(time: NSDate, day: Int) -> NSDate{
        var yyyy = time.currentYear
        var MM = time.currentMonth
        let dd = time.currentDay
        let dd1 = day
        
        if isThisMonthPaied(dd, dd2: dd1){
            MM += 1
            if MM == 13{
                yyyy += 1
                MM = 1
            }
        }
        return stringToDateNoHH("\(yyyy)-\(MM)-\(dd1)")
    }
    
    //获取最后一期还款时间
    class func getLastPayDate(time: NSDate, day: Int, periods: Int) -> NSDate{
        let first = getFirstPayDate(time, day: day)
        let last = calculateTime(first, months: periods-1)
        return last
    }
    
    //获取最后一期还款时间
    class func getLastPayDate(nextTime: NSDate, leftPeriods: Int) -> NSDate{
        let last = calculateTime(nextTime, months: leftPeriods)
        return last
    }
    
    //获取信用卡的月份差，与日也有关系
    class func getMonthOffset(time1: NSDate, time2: NSDate) -> Int{
        
        let yyyy1 = time1.currentYear
        let MM1 = time1.currentMonth
        let dd1 = time1.currentDay
        
        let yyyy2 = time2.currentYear
        let MM2 = time2.currentMonth
        let dd2 = time2.currentDay
        
        var months = 0
        
        if yyyy1 == yyyy2{  //同一年
            if MM1 >= MM2{ //目前时间的月份大于或等于记账时间的月份
                if dd1 < dd2 {
                    months = MM1-MM2
                }else{
                    months = MM1-MM2+1
                }
            }else{ //目前时间的月份小于了记账时间的月份
                months = 0
            }
        }else if yyyy1 > yyyy2{ //目前时间的年大于记账时间
            if dd1 < dd2 {
                months = 12+MM1-MM2
            }else{
                months = 12+MM1-MM2+1
            }
        }else{ //目前时间的年小于了记账时间
            months = 0
        }
        return months
    }
    
    //是否本月已换,已还返回true
    class func isThisMonthPaied(dd1: Int, dd2: Int) -> Bool{
        if dd1 < dd2 {
            return false
        }else{
            return true
        }
    }
    
    class func calculateCredit(){
        var creditArray = SQLLine.selectAllData(entityNameOfCredit)
        let time = NSSortDescriptor.init(key: creditNameOfTime, ascending: true)
        creditArray = creditArray.sortedArrayUsingDescriptors([time])
        
        guard creditArray.count > 0 else{
            print("excute guard")
            return
        }
        
        let timeNow = getTime()
        for i in 0 ..< creditArray.count {
            let nextPayDay = creditArray.objectAtIndex(i).valueForKey(creditNameOfNextPayDay) as! NSDate  // 下期还款日期
            let leftPeriods = creditArray.objectAtIndex(i).valueForKey(creditNameOfLeftPeriods) as! Int  // 剩余还款期数
            
            if leftPeriods > 0 {
                let months = getMonthOffset(timeNow, time2: nextPayDay)
                let number = creditArray.objectAtIndex(i).valueForKey(creditNameOfNumber) as! Float  //
                if months < leftPeriods && months > 0{
                    
                    let nextPay = calculateTime(nextPayDay, months: months)
                    SQLLine.updateCreditDataSortedByTime(i, changeValue: leftPeriods-months, changeEntityName: creditNameOfLeftPeriods)
                    SQLLine.updateCreditDataSortedByTime(i, changeValue: nextPay, changeEntityName: creditNameOfNextPayDay)
                    changeTotal(Float(months)*number)
                    
                }else if(months >= leftPeriods){
                    let nextPay = calculateTime(nextPayDay, months: leftPeriods)
                    SQLLine.updateCreditDataSortedByTime(i, changeValue: 0, changeEntityName: creditNameOfLeftPeriods)
                    SQLLine.updateCreditDataSortedByTime(i, changeValue: nextPay, changeEntityName: creditNameOfNextPayDay)
                    changeTotal(Float(leftPeriods)*number)
                }
            }
        }
    }
    
    //给定时间 和 月份差（大于0），返回一个时间
    class func calculateTime(time: NSDate, months: Int) -> NSDate{
        var yyyy = time.currentYear
        var MM = time.currentMonth
        let dd = time.currentDay
        
        MM = MM + months
        
        yyyy = yyyy + Int(MM/13)
        MM = MM%13
        if MM == 0 {
            MM = 1
        }
        
        let nextPay = stringToDateNoHH("\(yyyy)-\(MM)-\(dd)")
        return nextPay
    }
    
    //改变总剩余
    class func changeTotal(useNumber: Float){
        let countTmp = SQLLine.selectAllData(entityNameOfTotal).count
        if(countTmp == 0){
            SQLLine.insertTotalData(0 - useNumber, time: getTime())
        }else{
            var canTmp = GetAnalyseData.getCanUseToFloat()
            canTmp = canTmp - useNumber
            SQLLine.insertTotalData(canTmp, time: getTime())
        }
    }
}