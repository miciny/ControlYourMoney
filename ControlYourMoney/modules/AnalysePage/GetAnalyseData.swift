//
//  GetAnalyseData.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/13.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class GetAnalyseData: NSObject {
    //每月收入
    class func getEveryMonthSalary() -> Float{
        let salaryArray = SQLLine.selectAllData(entityNameOfSalary)
        var salary = Float(8500)
        if salaryArray.count == 0{
            return salary
        }
        salary = salaryArray.lastObject!.valueForKey(salaryNameOfNumber) as! Float
        return salary
    }
    
    //每年的一次性开销，如房租，不好记得，只好这样了
    class func getThisYearOnceUse() -> Float{
        let costArray = SQLLine.selectAllData(entityNameOfCost)
        var thisYearOnceUse = Float(0)
        
        if costArray.count == 0{
            return thisYearOnceUse
        }
        
        for i in 0 ..< costArray.count {
            let type = costArray.objectAtIndex(i).valueForKey(costNameOfType) as! Int
            if type == 1 {
                thisYearOnceUse += (costArray.objectAtIndex(i).valueForKey(costNameOfNumber) as? Float)!
            }
        }
        return thisYearOnceUse
    }

    
    //根据每月开销，计算本月到年底（包括本月 到 2月）的花费
    class func getThisYearEveryMonthsAllUse() -> Float{
        let costArray = SQLLine.selectAllData(entityNameOfCost)
        let timeNow = getTime()
        var thisyearEveryMonthsAllUse = Float(0)
        var months = Int()
        if timeNow.currentMonth <= 2 {
            months = 3 - timeNow.currentMonth
        }else{
            months = 15 - timeNow.currentMonth
        }
        
        if costArray.count == 0{
            return thisyearEveryMonthsAllUse
        }
        
        for i in 0 ..< costArray.count {
            let type = costArray.objectAtIndex(i).valueForKey(costNameOfType) as! Int
            if type == 0 {
                thisyearEveryMonthsAllUse += (costArray.objectAtIndex(i).valueForKey(costNameOfNumber) as? Float)! * Float(months)
            }
        }
        return thisyearEveryMonthsAllUse
    }
    
    //最后一月用钱总数
    class func getThisMonthUse() -> Float{
        var thisMonthUse : Float = 0
        
        let cashArray = SQLLine.selectAllData(entityNameOfCash)
        if cashArray.count == 0 {
            return thisMonthUse
        }
        
        for i in 0  ..< cashArray.count{
            let lastDayStr = dateToStringBySelf(cashArray.lastObject!.valueForKey(cashNameOfTime) as! NSDate, str: "yyyy-MM")
            let dayStr = dateToStringBySelf(cashArray.objectAtIndex(i).valueForKey(cashNameOfTime) as! NSDate, str: "yyyy-MM")
            if(lastDayStr == dayStr){
                thisMonthUse = thisMonthUse + (cashArray.objectAtIndex(i).valueForKey(cashNameOfUseNumber) as! Float)
            }
        }
        return thisMonthUse
    }
    
    //最后一日用钱总数
    class func getTodayUse() -> Float{
        var todayUse : Float = 0
        
        let cashArray = SQLLine.selectAllData(entityNameOfCash)
        if cashArray.count == 0 {
            return todayUse
        }
        
        for i in 0  ..< cashArray.count{
            let lastDayStr = dateToStringBySelf(cashArray.lastObject!.valueForKey(cashNameOfTime) as! NSDate, str: "yyyy-MM-dd")
            let dayStr = dateToStringBySelf(cashArray.objectAtIndex(i).valueForKey(cashNameOfTime) as! NSDate, str: "yyyy-MM-dd")
            if(lastDayStr == dayStr){
                todayUse = todayUse + (cashArray.objectAtIndex(i).valueForKey(cashNameOfUseNumber) as! Float)
            }
        }
        return todayUse
    }
    
    
    //信用卡所有剩余应还
    class func getCreditTotalPay() -> Float{
        let creditArray = SQLLine.selectAllData(entityNameOfCredit)
        var creditTotal = Float(0)
        
        if creditArray.count == 0 {
            return creditTotal
        }
        for i in 0  ..< creditArray.count{
            let number = creditArray.objectAtIndex(i).valueForKey(creditNameOfNumber) as! Float
            let leftPeriods = creditArray.objectAtIndex(i).valueForKey(creditNameOfLeftPeriods) as! NSInteger
            if leftPeriods > 0{
                creditTotal = creditTotal + number*Float(leftPeriods)
            }
        }
        return creditTotal
    }
    
    //本月信用卡剩余应还
    class func getCreditThisMonthLeftPay() -> Float{
        var shouldPayData : Float = 0
        let creditArray = SQLLine.selectAllData(entityNameOfCredit)
        
        if creditArray.count == 0 {
            return shouldPayData
        }
        let timeNow = getTime()
        let MM = timeNow.currentMonth
        
        for i in 0  ..< creditArray.count{
            let nextPayDay = creditArray.objectAtIndex(i).valueForKey(creditNameOfNextPayDay) as! NSDate
            let number = creditArray.objectAtIndex(i).valueForKey(creditNameOfNumber) as! Float
            let leftPeriods = creditArray.objectAtIndex(i).valueForKey(creditNameOfLeftPeriods) as! NSInteger
            
            if(MM == nextPayDay.currentMonth && leftPeriods > 0){
                shouldPayData = shouldPayData + number
            }
        }
        
        return shouldPayData
    }
    
    //本月信用卡总还
    class func getCreditThisMonthPay() -> Float{
        var creditThisMonthPay: Float = 0
        
        let creditArray = SQLLine.selectAllData(entityNameOfCredit)
        if creditArray.count == 0 {
            return creditThisMonthPay
        }
    
        let timeNow = getTime()
        let MM = timeNow.currentMonth
        let yyyy = timeNow.currentYear
        
        for i in 0  ..< creditArray.count{
            let number = creditArray.objectAtIndex(i).valueForKey(creditNameOfNumber) as! Float
            let time = creditArray.objectAtIndex(i).valueForKey(creditNameOfTime) as! NSDate
            let date = creditArray.objectAtIndex(i).valueForKey(creditNameOfDate) as! Int
            
            let firstPayDay = CalculateCredit.getFirstPayDate(time, day: date)
            let firstMM = firstPayDay.currentMonth
            let firstYYYY = firstPayDay.currentYear
            
            let timeOffset = firstPayDay.timeIntervalSinceDate(timeNow)
            
            if((MM==firstMM&&yyyy==firstYYYY) || timeOffset < 0){
                creditThisMonthPay = creditThisMonthPay + number
            }
        }
        return creditThisMonthPay
    }
    
    //下月信用卡总还
    class func getCreditNextMonthPay() -> Float{
        var creditNextMonthPay: Float = 0
        
        let creditArray = SQLLine.selectAllData(entityNameOfCredit)
        if creditArray.count == 0 {
            return creditNextMonthPay
        }
        let timeNow = getTime()
        let MM = timeNow.currentMonth
        
        for i in 0  ..< creditArray.count{
            let nextPayDay = creditArray.objectAtIndex(i).valueForKey(creditNameOfNextPayDay) as! NSDate
            let number = creditArray.objectAtIndex(i).valueForKey(creditNameOfNumber) as! Float
            let leftPeriods = creditArray.objectAtIndex(i).valueForKey(creditNameOfLeftPeriods) as! NSInteger
            
            let MM1 = nextPayDay.currentMonth
            var MM2 = MM + 1
            if MM2 == 13 {
                MM2 = 1
            }
            //本月未还  剩余周期大于1 或者  本月还了 剩余周期大于0
            if((MM == MM1 && leftPeriods > 1) || (MM2 == MM1 && leftPeriods > 0)){
                creditNextMonthPay = creditNextMonthPay + number
            }
        }
        return creditNextMonthPay
    }

    //预计本月总支出 ， 为 每月支出 ＋ 信用卡
    class func getThisMonthPay() -> Float{
        var thisMonthPay: Float = 0
        let costArray = SQLLine.selectAllData(entityNameOfCost)
        if costArray.count == 0{
            thisMonthPay += getCreditThisMonthPay()
            return thisMonthPay
        }
        
        for i in 0 ..< costArray.count {
            let type = costArray.objectAtIndex(i).valueForKey(costNameOfType) as! Int
            if type == 0 {
                thisMonthPay += (costArray.objectAtIndex(i).valueForKey(costNameOfNumber) as? Float)!
            }
        }
        
        thisMonthPay += getCreditThisMonthPay()
        return thisMonthPay
    }
    
    //预计今年结余，为 今年总收入(不包括本月的收入) ＋ 现有的 － 今年总开支
    class func getThisYearLeft() -> Float{
        var thisYearLeft: Float = 0
        
        let timeNow = getTime()
        var months = Int()
        if timeNow.currentMonth <= 2 {
            months = 3 - timeNow.currentMonth
        }else{
            months = 15 - timeNow.currentMonth
        }
        
        let thisYearPay = getEveryMonthSalary()*Float(months) + getCanUseToFloat()
        thisYearLeft = thisYearPay-getThisYearPay()
        return thisYearLeft
    }
    
    //预计本年支出, 为每月支出＊剩余月份 ＋ 每年一次性支出  ＋ 信用卡剩余应还
    class func getThisYearPay() -> Float{
        var thisYearPay: Float = 0
        thisYearPay = getThisYearEveryMonthsAllUse()+getThisYearOnceUse()+getCreditTotalPay()
        return thisYearPay
    }
    
    //本月现结余，为 现有的 － 本月总支出（预计支出 ＋ 信用卡本月剩余应还）
    class func getNowLeft() -> Float{
        var nowLeft : Float = 0
        let thisMonthLeft = getCanUseToFloat()
        let thisMonthPay = getThisMonthPay()-getCreditThisMonthPay()+getCreditThisMonthLeftPay()
        nowLeft = thisMonthLeft-thisMonthPay
        return nowLeft
    }
    
    //获取可用余额
    class func getCanUseToFloat() -> Float{
        let data = SQLLine.selectAllData(entityNameOfTotal)
        if(data.count == 0){
            return 0
        }else{
            return SQLLine.selectAllData(entityNameOfTotal).valueForKey(TotalNameOfCanUse).lastObject as! Float
        }
    }
}
