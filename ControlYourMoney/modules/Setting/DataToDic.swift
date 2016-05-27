//
//  DataToDic.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/27.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class DataToArray: NSObject {
    class func setCashDataToArray() -> NSMutableArray{
        let dic = NSMutableArray()
        
        let cashArray = Cash.selectAllData()
        
        if cashArray.count == 0{
            return dic
        }
        
        for i in 0 ..< cashArray.count {
            let dataDic = NSMutableDictionary()
            let row = cashArray.objectAtIndex(i) as! Cash
            dataDic.setValue(dateToStringBySelf(row.time!, str: "yyyy-MM-dd HH:mm:ss.ssss"), forKey: cashNameOfTime)
            dataDic.setValue(String(row.useNumber!), forKey: cashNameOfUseNumber)
            dataDic.setValue(row.useWhere!, forKey: cashNameOfUseWhere)
            dataDic.setValue(row.type!, forKey: cashNameOfType)
            
            dic.addObject(dataDic)
        }
        return dic
    }
    
    class func setPayNameDataToArray() -> NSMutableArray{
        let dic = NSMutableArray()
        
        let allArray = PayName.selectAllData()
        
        if allArray.count == 0{
            return dic
        }
        
        for i in 0 ..< allArray.count {
            let dataDic = NSMutableDictionary()
            let row = allArray.objectAtIndex(i) as! PayName
            dataDic.setValue(dateToStringBySelf(row.time!, str: "yyyy-MM-dd HH:mm:ss.ssss"), forKey: payNameNameOfTime)
            dataDic.setValue(String(row.name!), forKey: payNameNameOfName)
            
            dic.addObject(dataDic)
        }
        return dic
    }
    
    class func setCostDataToArray() -> NSMutableArray{
        let dic = NSMutableArray()
        
        let allArray = Cost.selectAllData()
        
        if allArray.count == 0{
            return dic
        }
        
        for i in 0 ..< allArray.count {
            let dataDic = NSMutableDictionary()
            let row = allArray.objectAtIndex(i) as! Cost
            dataDic.setValue(dateToStringBySelf(row.time!, str: "yyyy-MM-dd HH:mm:ss.ssss"), forKey: costNameOfTime)
            dataDic.setValue(row.name!, forKey: costNameOfName)
            dataDic.setValue(String(row.number!), forKey: costNameOfNumber)
            dataDic.setValue(row.type!, forKey: costNameOfType)
            dataDic.setValue(String(row.period!), forKey: costNameOfPeriod)
            
            dic.addObject(dataDic)
        }
        return dic
    }
    
    class func setCreditDataToArray() -> NSMutableArray{
        let dic = NSMutableArray()
        
        let allArray = Credit.selectAllData()
        
        if allArray.count == 0{
            return dic
        }
        
        for i in 0 ..< allArray.count {
            let dataDic = NSMutableDictionary()
            let row = allArray.objectAtIndex(i) as! Credit
            dataDic.setValue(dateToStringBySelf(row.time!, str: "yyyy-MM-dd HH:mm:ss.ssss"), forKey: creditNameOfTime)
            dataDic.setValue(String(row.number!), forKey: creditNameOfNumber)
            dataDic.setValue(row.account!, forKey: creditNameOfAccount)
            dataDic.setValue(row.type!, forKey: creditNameOfType)
            dataDic.setValue(String(row.date!), forKey: creditNameOfDate)
            dataDic.setValue(String(row.periods!), forKey: creditNameOfPeriods)
            dataDic.setValue(String(row.leftPeriods!), forKey: creditNameOfLeftPeriods)
            dataDic.setValue(dateToStringBySelf(row.nextPayDay!, str: "yyyy-MM-dd HH:mm:ss.ssss"), forKey: creditNameOfNextPayDay)
            
            dic.addObject(dataDic)
        }
        return dic
    }
    
    class func setCreditAccountDataToArray() -> NSMutableArray{
        let dic = NSMutableArray()
        
        let allArray = CreditAccount.selectAllData()
        
        if allArray.count == 0{
            return dic
        }
        
        for i in 0 ..< allArray.count {
            let dataDic = NSMutableDictionary()
            let row = allArray.objectAtIndex(i) as! CreditAccount
            dataDic.setValue(dateToStringBySelf(row.time!, str: "yyyy-MM-dd HH:mm:ss.ssss"), forKey: creditAccountNameOfTime)
            dataDic.setValue(row.name!, forKey: creditAccountNameOfName)
            
            dic.addObject(dataDic)
        }
        return dic
    }
    
    class func setTotalDataToArray() -> NSMutableArray{
        let dic = NSMutableArray()
        
        let allArray = Total.selectAllData()
        
        if allArray.count == 0{
            return dic
        }
        
        for i in 0 ..< allArray.count {
            let dataDic = NSMutableDictionary()
            let row = allArray.objectAtIndex(i) as! Total
            dataDic.setValue(dateToStringBySelf(row.time!, str: "yyyy-MM-dd HH:mm:ss.ssss"), forKey: totalNameOfTime)
            dataDic.setValue(String(row.canUse!), forKey: totalNameOfCanUse)
            
            dic.addObject(dataDic)
        }
        return dic
    }
    
    class func setIncomeDataToArray() -> NSMutableArray{
        let dic = NSMutableArray()
        
        let allArray = Salary.selectAllData()
        
        if allArray.count == 0{
            return dic
        }
        
        for i in 0 ..< allArray.count {
            let dataDic = NSMutableDictionary()
            let row = allArray.objectAtIndex(i) as! Salary
            dataDic.setValue(dateToStringBySelf(row.time!, str: "yyyy-MM-dd HH:mm:ss.ssss"), forKey: incomeOfName)
            dataDic.setValue(String(row.number!), forKey: incomeOfNumber)
            dataDic.setValue(row.name!, forKey: incomeOfName)
            
            dic.addObject(dataDic)
        }
        return dic
    }
    
    class func setIncomeNameDataToArray() -> NSMutableArray{
        let dic = NSMutableArray()
        
        let cashArray = IncomeName.selectAllData()
        
        if cashArray.count == 0{
            return dic
        }
        
        for i in 0 ..< cashArray.count {
            let dataDic = NSMutableDictionary()
            let cash = cashArray.objectAtIndex(i) as! IncomeName
            dataDic.setValue(dateToStringBySelf(cash.time!, str: "yyyy-MM-dd HH:mm:ss.ssss"), forKey: incomeNameOfTime)
            dataDic.setValue(cash.name!, forKey: incomeNameOfName)
            
            dic.addObject(dataDic)
        }
        return dic
    }
}
