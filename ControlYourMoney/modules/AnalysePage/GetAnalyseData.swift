//
//  GetAnalyseData.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/13.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class GetAnalyseData: NSObject {
    //收入比例
    class func getIncomePercent() -> NSMutableDictionary?{
        let incomePercent = NSMutableDictionary()
        let accountArray = SQLLine.selectAllData(entityNameOfIncomeName)
        var nameArray = [String]()
        
        if accountArray.count == 0{
            return nil
        }
        
        for i in 0 ..< accountArray.count{
            let name = accountArray.objectAtIndex(i).valueForKey(incomeOfName) as! String
            nameArray.append(name)
        }
        
        let incomeArray = SQLLine.selectAllData(entityNameOfIncome)
        if incomeArray.count > 0{
            for i in 0  ..< incomeArray.count{
                let type = incomeArray.objectAtIndex(i).valueForKey(incomeOfName) as! String
                if(nameArray.contains(type)){
                    let number = incomeArray.objectAtIndex(i).valueForKey(incomeOfNumber) as! Float
                    
                    if let numberTemp = incomePercent.valueForKey(type){
                        incomePercent.setValue((numberTemp as! Float)+number, forKey: type)
                    }else{
                        incomePercent.setValue(number, forKey: type)
                    }
                }
            }
        }
        
        return incomePercent
    }

    //花费比例
    class func getCostPercent() -> NSMutableDictionary?{
        let costPercent = NSMutableDictionary()
        let accountArray = SQLLine.selectAllData(entityNameOfPayName)
        var nameArray = [String]()
        
        if accountArray.count == 0{
            return nil
        }
        
        for i in 0 ..< accountArray.count{
            let name = accountArray.objectAtIndex(i).valueForKey(payNameNameOfName) as! String
            nameArray.append(name)
        }
        
        let cashArray = SQLLine.selectAllData(entityNameOfCash)
        if cashArray.count > 0{
            for i in 0  ..< cashArray.count{
                let type = cashArray.objectAtIndex(i).valueForKey(cashNameOfType) as! String
                if(nameArray.contains(type)){
                    let number = cashArray.objectAtIndex(i).valueForKey(cashNameOfUseNumber) as! Float
                    
                    if let numberTemp = costPercent.valueForKey(type){
                        costPercent.setValue((numberTemp as! Float)+number, forKey: type)
                    }else{
                        costPercent.setValue(number, forKey: type)
                    }
                }
            }
        }
        
        let creditArray = SQLLine.selectAllData(entityNameOfCredit)
        if creditArray.count > 0 {
            for i in 0  ..< creditArray.count{
                let type = creditArray.objectAtIndex(i).valueForKey(creditNameOfType) as! String
                if nameArray.contains(type){
                    let number = creditArray.objectAtIndex(i).valueForKey(creditNameOfNumber) as! Float
                    let periods = creditArray.objectAtIndex(i).valueForKey(creditNameOfPeriods) as! Int
                    
                    if let numberTemp = costPercent.valueForKey(type){
                        costPercent.setValue((numberTemp as! Float)+number*Float(periods), forKey: type)
                    }else{
                        costPercent.setValue(number*Float(periods), forKey: type)
                    }
                }
            }
        }
        return costPercent
    }
    
/////////////////////////////////////////////////////////////////////////////////////
    //本月目前每日支出
    class func getEveryDayPay() -> [Float]{
        var todayUse = [Float]()
        let timeNow = getTime()
        
        for i in 1 ..< timeNow.currentDay+1 {
            let single = getDayPay(i)
            todayUse.append(single)
        }
        return todayUse
    }
    
    //1月到12月，每月现金实际支出
    class func getEveryMonthPay() -> [Float]{
        var thisMonthUse = [Float]()
        let timeNow = getTime()
        
        for i in 1 ..< 13 {
            let single = getMonthPay(timeNow.currentYear, month: i)
            thisMonthUse.append(single)
        }
        return thisMonthUse
    }
    
    //1月到12月，预计每月支出 现金加信用
    class func getPreEveryMonthPay() -> [Float]{
        var thisMonthUse = [Float]()
        let timeNow = getTime()
        let cash = getPreThisMonthCashPay()
        for i in 1 ..< 13 {
            let timeArray = NSMutableArray()
            if i > 9 {
                timeArray.addObject("\(timeNow.currentYear)-\(i)")
            }else{
                timeArray.addObject("\(timeNow.currentYear)-0\(i)")
            }
            
            let credit = getWhichMonthCreditPayIncludeDone(timeArray)
            
            thisMonthUse.append(credit+cash)
        }
        return thisMonthUse
    }
    

//    实际
/////////////////////////////////////////////////////////////////////////////////////
    
    //某天现金支出
    class func getDayPay(day: Int) -> Float{
        
        var todayUse : Float = 0
        let cashArray = SQLLine.selectAllData(entityNameOfCash)
        
        guard cashArray.count > 0 else{
            return todayUse
        }
        
        let timeNow = getTime()
        let todayDayStr = dateToStringNoHH(stringToDateNoHH("\(timeNow.currentYear)-\(timeNow.currentMonth)-\(day)"))
        
        for i in 0  ..< cashArray.count{
            let dayStr = dateToStringBySelf(cashArray.objectAtIndex(i).valueForKey(cashNameOfTime) as! NSDate, str: "yyyy-MM-dd")
            if(todayDayStr == dayStr){
                todayUse = todayUse + (cashArray.objectAtIndex(i).valueForKey(cashNameOfUseNumber) as! Float)
            }
        }
        return todayUse
    }
    
    //某月现金支出
    class func getMonthPay(yyyy: Int, month: Int) -> Float{
        var thisMonthUse : Float = 0
        let cashArray = SQLLine.selectAllData(entityNameOfCash)
        
        if cashArray.count == 0 {
            return thisMonthUse
        }
        
        let yyyy = yyyy
        let timeStr = dateToStringBySelf(stringToDateNoHH("\(yyyy)-\(month)-\(1)"), str: "yyyy-MM")
        
        for i in 0  ..< cashArray.count{
            let dayStr = dateToStringBySelf(cashArray.objectAtIndex(i).valueForKey(cashNameOfTime) as! NSDate, str: "yyyy-MM")
            if(timeStr == dayStr){
                thisMonthUse = thisMonthUse + (cashArray.objectAtIndex(i).valueForKey(cashNameOfUseNumber) as! Float)
            }
        }
        return thisMonthUse
    }
    
    //今年现金支出 (到次年2月)
    class func getThisYearPayTotal() -> Float{
        var thisYearUse : Float = 0
        let timeNow = getTime()
        let month = timeNow.currentMonth
        let year = timeNow.currentYear
        
        if month < 3 {
            for i in 1  ..< 13{
                if(i < 3){
                    thisYearUse = thisYearUse + getMonthPay(year, month: i)
                }else{
                    thisYearUse = thisYearUse + getMonthPay(year-1, month: i)
                }
            }
        }else{
            for i in 1  ..< 13{
                if(i < 3){
                    thisYearUse = thisYearUse + getMonthPay(year+1, month: i)
                }else{
                    thisYearUse = thisYearUse + getMonthPay(year, month: i)
                }
            }
        }
        return thisYearUse
    }
    
    //预计每月收入
    class func getEveryMonthSalary() -> Float{
        let salaryArray = SQLLine.selectAllData(entityNameOfIncome)
        var salary = Float(8500)
        if salaryArray.count == 0{
            return salary
        }
        salary = Float(0)
        let date = salaryArray.lastObject!.valueForKey(incomeOfTime) as! NSDate
        let dateStr = dateToStringBySelf(date, str: "yyyy-MM")
        
        for i in 0 ..< salaryArray.count {
            let dateOne = salaryArray.objectAtIndex(i).valueForKey(incomeOfTime) as! NSDate
            let dateOneStr = dateToStringBySelf(dateOne, str: "yyyy-MM")
            
            if dateStr == dateOneStr{
                let number = salaryArray.objectAtIndex(i).valueForKey(incomeOfNumber) as! Float
                salary += number
            }
        }
        return salary
    }
    
    //今年总收入
    class func getAllRealSalary() -> Float{
        let salaryArray = SQLLine.selectAllData(entityNameOfIncome)
        var salary = Float(0)
        let timeNow = getTime()
        if salaryArray.count == 0{
            return salary
        }
        for i in 0 ..< salaryArray.count {
            let time = salaryArray.objectAtIndex(i).valueForKey(incomeOfTime) as! NSDate
            if time.currentYear == timeNow.currentYear{
                let number = salaryArray.objectAtIndex(i).valueForKey(incomeOfNumber) as! Float
                salary += number
            }
            
        }
        return salary
    }

/////////////////////////////////////////////////////////////////////////////////////
    //每年的一次性开销，如房租，不好记得，只好这样了
    class func getThisYearOnceUse() -> Float{
        let costArray = SQLLine.selectAllData(entityNameOfCost)
        var thisYearOnceUse = Float(0)
        
        let timeNow = getTime()
        var months = Int()
        if timeNow.currentMonth <= 2 {
            months = 3 - timeNow.currentMonth
        }else{
            months = 15 - timeNow.currentMonth
        }
        
        if costArray.count == 0{
            return thisYearOnceUse
        }
        
        for i in 0 ..< costArray.count {
            let type = costArray.objectAtIndex(i).valueForKey(costNameOfPeriod) as! Int
            if type == 1 {
                thisYearOnceUse += (costArray.objectAtIndex(i).valueForKey(costNameOfNumber) as? Float)!
            }
        }
        
        thisYearOnceUse = thisYearOnceUse/12*Float(months)
        return thisYearOnceUse
    }

    
    //根据每月开销，计算本月到年底（包括本月 到 2月）的花费
    class func getThisYearEveryMonthsAllUse() -> Float{
        let timeNow = getTime()
        var thisyearEveryMonthsAllUse = Float(0)
        var months = Int()
        if timeNow.currentMonth <= 2 {
            months = 3 - timeNow.currentMonth
        }else{
            months = 15 - timeNow.currentMonth
        }
        
        thisyearEveryMonthsAllUse = getPreThisMonthCashPay() * Float(months)
        return thisyearEveryMonthsAllUse
    }
    
/////////////////////////////////////////////////////////////////////////////////////
    
    //本月现金总数
    class func getThisMonthUse() -> Float{
        var thisMonthUse: Float = 0
        
        let cashArray = SQLLine.selectAllData(entityNameOfCash)
        if cashArray.count == 0 {
            return thisMonthUse
        }
        let todayDayStr = dateToStringBySelf(getTime(), str: "yyyy-MM")
        
        for i in 0  ..< cashArray.count{
            let dayStr = dateToStringBySelf(cashArray.objectAtIndex(i).valueForKey(cashNameOfTime) as! NSDate, str: "yyyy-MM")
            if(todayDayStr == dayStr){
                thisMonthUse = thisMonthUse + (cashArray.objectAtIndex(i).valueForKey(cashNameOfUseNumber) as! Float)
            }
        }
        return thisMonthUse
    }
    
    //今日现金总数
    class func getTodayUse() -> Float{
        var todayUse : Float = 0
        
        let cashArray = SQLLine.selectAllData(entityNameOfCash)
        if cashArray.count == 0 {
            return todayUse
        }
        
        let todayDayStr = dateToStringBySelf(getTime(), str: "yyyy-MM-dd")
        for i in 0  ..< cashArray.count{
            let dayStr = dateToStringBySelf(cashArray.objectAtIndex(i).valueForKey(cashNameOfTime) as! NSDate, str: "yyyy-MM-dd")
            if(todayDayStr == dayStr){
                todayUse = todayUse + (cashArray.objectAtIndex(i).valueForKey(cashNameOfUseNumber) as! Float)
            }
        }
        return todayUse
    }
    
    //预计本月现金开支  cost里type为0 的
    class func getPreThisMonthCashPay() -> Float{
        var thisMonthPay: Float = 0
        let costArray = SQLLine.selectAllData(entityNameOfCost)
        if costArray.count == 0{
            return thisMonthPay
        }
        
        for i in 0 ..< costArray.count {
            let type = costArray.objectAtIndex(i).valueForKey(costNameOfPeriod) as! Int
            if type == 0 {
                thisMonthPay += (costArray.objectAtIndex(i).valueForKey(costNameOfNumber) as? Float)!
            }
        }
        return thisMonthPay
    }
    
/////////////////////////////////////////////////////////////////////////////////////
    
    //信用卡今年所有总应还 到次年的2月
    class func getCreditThisYearTotalPay() -> Float{
        var creditTotal = Float(0)
        let creditArray = SQLLine.selectAllData(entityNameOfCredit)
        
        if creditArray.count == 0 {
            return creditTotal
        }
    
        let timeNow = getTime()
        let month = timeNow.currentMonth
        let year = timeNow.currentYear
        
        let monthArrya = NSMutableArray()
        
        if month < 3 {
            for i in 1  ..< 13{
                if(i < 3){
                    monthArrya.addObject("\(year)-0\(i)")
                }else if i > 9{
                    monthArrya.addObject("\(year-1)-\(i)")
                }else{
                    monthArrya.addObject("\(year-1)-0\(i)")
                }
            }
        }else{
            for i in 1  ..< 13{
                if(i < 3){
                    monthArrya.addObject("\(year+1)-0\(i)")
                }else if i > 9{
                    monthArrya.addObject("\(year)-\(i)")
                }else{
                    monthArrya.addObject("\(year)-0\(i)")
                }
            }
        }
        
        for i in 0  ..< creditArray.count{
            let time = creditArray.objectAtIndex(i).valueForKey(creditNameOfTime) as! NSDate
            let date = creditArray.objectAtIndex(i).valueForKey(creditNameOfDate) as! Int
            let periods = creditArray.objectAtIndex(i).valueForKey(creditNameOfPeriods) as! Int
            for j in 0 ..< periods {
                let lastPayDay = CalculateCredit.getLastPayDate(time, day: date, periods: j+1)
                let lastStr = dateToStringBySelf(lastPayDay, str: "yyyy-MM")
                let number = creditArray.objectAtIndex(i).valueForKey(creditNameOfNumber) as! Float
                if monthArrya.containsObject(lastStr){
                    creditTotal += number
                }
            }
        }
        return creditTotal
    }
    
    //信用卡今年所有剩余应还 到次年的2月，不包括还了的, 所以应该是 去掉本月 然后，本月剩余应还，加上下月到年底剩余应还的
    class func getCreditThisYearLeftPay() -> Float{
        var creditTotal = Float(0)
        
        let timeNow = getTime()
        let month = timeNow.currentMonth
        let year = timeNow.currentYear
        
        let monthArrya = NSMutableArray()
        
        creditTotal += getCreditThisMonthLeftPay()
        
        if month == 1 {
            monthArrya.addObject("\(year)-02")
        }else if month > 2{
            for i in month+1 ..< 13{
                if i > 9{
                    monthArrya.addObject("\(year)-\(i)")
                }else{
                    monthArrya.addObject("\(year)-0\(i)")
                }
            }
            for i in 1 ..< 3{
                monthArrya.addObject("\(year+1)-0\(i)")
            }
        }
        
        creditTotal += getWhichMonthCreditPay(monthArrya)
        return creditTotal
    }
    
    //信用卡所有剩余应还
    class func getCreditTotalLeftPay() -> Float{
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
    
    //某月信用卡总还,没还完的 调用次数过多会很慢
    class func getWhichMonthCreditPay(strArray: NSMutableArray) -> Float{
        
        var thisMonthPay : Float = 0
        let creditArray = SQLLine.selectAllData(entityNameOfCredit)
        
        if creditArray.count == 0 {
            return thisMonthPay
        }
        for i in 0  ..< creditArray.count{
            let leftPeriods = creditArray.objectAtIndex(i).valueForKey(creditNameOfLeftPeriods) as! Int
            if leftPeriods > 0 {
                let time = creditArray.objectAtIndex(i).valueForKey(creditNameOfTime) as! NSDate
                let date = creditArray.objectAtIndex(i).valueForKey(creditNameOfDate) as! Int
                let periods = creditArray.objectAtIndex(i).valueForKey(creditNameOfPeriods) as! Int
                for j in 0 ..< periods {
                    let lastPayDay = CalculateCredit.getLastPayDate(time, day: date, periods: j+1)
                    let lastStr = dateToStringBySelf(lastPayDay, str: "yyyy-MM")
                    let number = creditArray.objectAtIndex(i).valueForKey(creditNameOfNumber) as! Float
                    if strArray.containsObject(lastStr){
                        thisMonthPay += number
                    }
                }
                
            }
        }
        return thisMonthPay
    }
    
    //某月信用卡总还,还完的也算
    class func getWhichMonthCreditPayIncludeDone(timeArray: NSMutableArray) -> Float{
        
        var thisMonthPay : Float = 0
        let creditArray = SQLLine.selectAllData(entityNameOfCredit)
        
        if creditArray.count == 0 {
            return thisMonthPay
        }
        
        for i in 0  ..< creditArray.count{
            let time = creditArray.objectAtIndex(i).valueForKey(creditNameOfTime) as! NSDate
            let date = creditArray.objectAtIndex(i).valueForKey(creditNameOfDate) as! Int
            let periods = creditArray.objectAtIndex(i).valueForKey(creditNameOfPeriods) as! Int
            for j in 0 ..< periods {
                let lastPayDay = CalculateCredit.getLastPayDate(time, day: date, periods: j+1)
                let lastStr = dateToStringBySelf(lastPayDay, str: "yyyy-MM")
                if timeArray.containsObject(lastStr){
                    let number = creditArray.objectAtIndex(i).valueForKey(creditNameOfNumber) as! Float
                    thisMonthPay += number
                }
            }
            
        }
        return thisMonthPay
    }

    
    //本月信用卡剩余应还
    class func getCreditThisMonthLeftPay() -> Float{
        var shouldPayData : Float = 0
        let creditArray = SQLLine.selectAllData(entityNameOfCredit)
        
        if creditArray.count == 0 {
            return shouldPayData
        }
        let timeNow = getTime()
        let todayMonthStr = dateToStringBySelf(timeNow, str: "yyyy-MM")
        
        for i in 0  ..< creditArray.count{
            let nextPayDay = creditArray.objectAtIndex(i).valueForKey(creditNameOfNextPayDay) as! NSDate
            let nextMonthStr = dateToStringBySelf(nextPayDay, str: "yyyy-MM")
            
            let number = creditArray.objectAtIndex(i).valueForKey(creditNameOfNumber) as! Float
            let leftPeriods = creditArray.objectAtIndex(i).valueForKey(creditNameOfLeftPeriods) as! NSInteger
            
            if(todayMonthStr == nextMonthStr && leftPeriods > 0){
                shouldPayData = shouldPayData + number
            }
        }
        return shouldPayData
    }
    
    //本月信用卡总还
    class func getCreditThisMonthAllPay() -> Float{
        var shouldPayData : Float = 0
        let timeNow = getTime()
        let timeArray = NSMutableArray()
        if timeNow.currentMonth > 9{
            timeArray.addObject("\(timeNow.currentYear)-\(timeNow.currentMonth)")
        }else{
            timeArray.addObject("\(timeNow.currentYear)-0\(timeNow.currentMonth)")
        }
        shouldPayData += getWhichMonthCreditPay(timeArray)
        return shouldPayData
    }
    
    //下月信用卡总还
    class func getCreditNextMonthAllPay() -> Float{
        var shouldPayData : Float = 0
        let timeNow = getTime()
        let timeArrayOne = NSMutableArray()
        if timeNow.currentMonth == 12{
            timeArrayOne.addObject("\(timeNow.currentYear+1)-01")
        }else if timeNow.currentMonth > 8{
            timeArrayOne.addObject("\(timeNow.currentYear)-\(timeNow.currentMonth+1)")
        }else{
            timeArrayOne.addObject("\(timeNow.currentYear)-0\(timeNow.currentMonth+1)")
        }
        shouldPayData += getWhichMonthCreditPay(timeArrayOne)
        return shouldPayData
    }
    
    //本月月信用卡总还,包括本月还了就还完的，也应该算在本月
    class func getCreditThisMonthAllPayIncludeDone() -> Float{
        var shouldPayData : Float = 0
        let timeNow = getTime()
        
        let timeArray = NSMutableArray()
        if timeNow.currentMonth > 9{
            timeArray.addObject("\(timeNow.currentYear)-\(timeNow.currentMonth)")
        }else{
            timeArray.addObject("\(timeNow.currentYear)-0\(timeNow.currentMonth)")
        }
        
        shouldPayData = GetAnalyseData.getWhichMonthCreditPayIncludeDone(timeArray)

        return shouldPayData
    }
    
//    预计
/////////////////////////////////////////////////////////////////////////////////////
    
    //预计本月总支出 ， 为 预计的本月现金开支 ＋ 信用卡本月总还
    class func getPreThisMonthPay() -> Float{
        var thisMonthPay: Float = 0
        thisMonthPay = getCreditThisMonthAllPay() + getPreThisMonthCashPay()
        return thisMonthPay
    }
    
    //预计今年结余，为 今年总收入(不包括本月的收入) ＋ 现有的 － 今年总开支  年底双薪
    class func getPreThisYearLeft() -> Float{
        var thisYearLeft: Float = 0
        
        let timeNow = getTime()
        var months = Int()
        if timeNow.currentMonth <= 2 {
            months = 3 - timeNow.currentMonth
        }else{
            months = 15 - timeNow.currentMonth
        }
        
        let thisYearPay = getEveryMonthSalary()*Float(months) + getCanUseToFloat()
        thisYearLeft = thisYearPay-getPreThisYearPay()
        return thisYearLeft
    }
    
    //预计本年支出（从现在开始算起，到次年2月）, 为每月预计的支出＊剩余月份 ＋ 每年一次性支出  ＋ 信用卡今年剩余应还
    class func getPreThisYearPay() -> Float{
        var thisYearPay: Float = 0
        thisYearPay = getThisYearEveryMonthsAllUse() + getThisYearOnceUse() + getCreditThisYearLeftPay()
        return thisYearPay
    }
    
    //本月现结余，为 现有的 － 本月总支出（预计现金支出 ＋ 信用卡本月剩余应还）
    class func getPreNowLeft() -> Float{ //不准
        var nowLeft : Float = 0
        let thisMonthLeft = getCanUseToFloat()
        let thisMonthPay = getPreThisMonthCashPay() + getCreditThisMonthLeftPay()
        nowLeft = thisMonthLeft-thisMonthPay
        return nowLeft
    }
    
    //获取可用余额
    class func getCanUseToFloat() -> Float{
        let data = SQLLine.selectAllData(entityNameOfTotal)
        if(data.count == 0){
            return 0
        }else{
            return SQLLine.selectAllData(entityNameOfTotal).valueForKey(totalNameOfCanUse).lastObject as! Float
        }
    }
/////////////////////////////////////////////////////////////////////////////////////
}
