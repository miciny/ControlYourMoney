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
    class func getFirstPayDate(_ time: Date, day: Int) -> Date{
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
    class func getLastPayDate(_ time: Date, day: Int, periods: Int) -> Date{
        let first = getFirstPayDate(time, day: day)
        let last = calculateTime(first, months: periods-1)
        return last
    }
    
    //获取最后一期还款时间
    class func getLastPayDate(_ nextTime: Date, leftPeriods: Int) -> Date{
        let last = calculateTime(nextTime, months: leftPeriods)
        return last
    }
    
    //获取信用卡的月份差，与日也有关系
    class func getMonthOffset(_ time1: Date, time2: Date) -> Int{
        
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
    class func isThisMonthPaied(_ dd1: Int, dd2: Int) -> Bool{
        if dd1 < dd2 {
            return false
        }else{
            return true
        }
    }
    
    //给定时间 和 月份差（大于0），返回一个时间
    class func calculateTime(_ time: Date, months: Int) -> Date{
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
    class func changeTotal(_ useNumber: Float){
        let countTmp = Total.selectAllData().count
        if(countTmp == 0){
            Total.insertTotalData(0 - useNumber, time: getTime())
        }else{
            var canTmp = GetAnalyseData.getCanUseToFloat()
            canTmp = canTmp - useNumber
            Total.insertTotalData(canTmp, time: getTime())
        }
    }
}
