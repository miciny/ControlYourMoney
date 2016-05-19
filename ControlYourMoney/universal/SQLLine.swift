//
//  Cash.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 15/12/19.
//  Copyright © 2015年 maocaiyuan. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class SQLLine: NSObject{
    //所有的数据
    class func selectAllData(entityName: String) -> NSArray{
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        var textData : NSArray = []
        let fetchData = NSFetchRequest(entityName: entityName)
        do {
            _ = try
                textData =  allDataSource.executeFetchRequest(fetchData)
        }catch _ as NSError{
        }
        return textData
    }
    //删一条数据
    class func deleteData(entityName: String, indexPath: Int){
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        var data = NSArray()
        data = selectAllData(entityName)
        allDataSource.deleteObject(data[indexPath] as! NSManagedObject)
        saveData()
    }
    
    //save
    class func saveData(){
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        do {
            _ = try
                allDataSource.save()
        }catch _ as NSError{}
    }
    
    //Cash插入一条数据
    class func insertCashData(useWhere: String, useNumber: Float, type: String, time: NSDate){
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let row : AnyObject = NSEntityDescription.insertNewObjectForEntityForName(entityNameOfCash, inManagedObjectContext: allDataSource)
        
        row.setValue(useWhere, forKey: cashNameOfUseWhere)
        row.setValue(useNumber, forKey: cashNameOfUseNumber)
        row.setValue(time, forKey: cashNameOfTime)
        row.setValue(type, forKey: cashNameOfType)
        saveData()
    }
    
    //Credit插入一条数据
    class func insertCrediData(periods: Int, number: Float, time: NSDate, account: String, date: Int, nextPayDay: NSDate, leftPeriods: Int, type: String){
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let row : AnyObject = NSEntityDescription.insertNewObjectForEntityForName(entityNameOfCredit, inManagedObjectContext: allDataSource)
        
        row.setValue(periods, forKey: creditNameOfPeriods)
        row.setValue(number, forKey: creditNameOfNumber)
        row.setValue(date, forKey: creditNameOfDate)
        row.setValue(account, forKey: creditNameOfAccount)
        row.setValue(time, forKey: creditNameOfTime)
        row.setValue(nextPayDay, forKey: creditNameOfNextPayDay)
        row.setValue(leftPeriods, forKey: creditNameOfLeftPeriods)
        row.setValue(type, forKey: creditNameOfType)
        saveData()
    }
    
    //Credit改一条数据
    class func updateCreditDataSortedByTime(indexPath: Int, periods: Int, number: Float, date: Int, account: String, time: NSDate, nextPayDay: NSDate, leftPeriods: Int, type: String){
        var data = NSArray()
        data = selectAllData(entityNameOfCredit)
        
        let time1 = NSSortDescriptor.init(key: creditNameOfNextPayDay, ascending: true)
        data = data.sortedArrayUsingDescriptors([time1])
        
        data[indexPath].setValue(periods, forKey: creditNameOfPeriods)
        data[indexPath].setValue(number, forKey: creditNameOfNumber)
        data[indexPath].setValue(date, forKey: creditNameOfDate)
        data[indexPath].setValue(account, forKey: creditNameOfAccount)
        data[indexPath].setValue(time, forKey: creditNameOfTime)
        data[indexPath].setValue(nextPayDay, forKey: creditNameOfNextPayDay)
        data[indexPath].setValue(leftPeriods, forKey: creditNameOfLeftPeriods)
        data[indexPath].setValue(type, forKey: creditNameOfType)
        saveData()
    }
    
    class func updateCreditDataSortedByTime(indexPath: Int, changeValue: AnyObject, changeEntityName: String){
        var data = NSArray()
        data = selectAllData(entityNameOfCredit)
        
        let time = NSSortDescriptor.init(key: creditNameOfNextPayDay, ascending: true)
        data = data.sortedArrayUsingDescriptors([time])
        
        data[indexPath].setValue(changeValue, forKey: changeEntityName)
        saveData()
    }
    
    //Credit删一条数据
    class func deleteCreditDataSortedByTime(indexPath: Int){
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        var data = NSArray()
        data = selectAllData(entityNameOfCredit)
        
        let time = NSSortDescriptor.init(key: creditNameOfNextPayDay, ascending: true)
        data = data.sortedArrayUsingDescriptors([time])
        
        allDataSource.deleteObject(data[indexPath] as! NSManagedObject)
        saveData()
    }
    
    //Income插入一条数据
    class func insertIncomeData(time: NSDate, number: Float, name: String){
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let row : AnyObject = NSEntityDescription.insertNewObjectForEntityForName(entityNameOfIncome, inManagedObjectContext: allDataSource)
        
        row.setValue(time, forKey: incomeOfTime)
        row.setValue(number, forKey: incomeOfNumber)
        row.setValue(name, forKey: incomeOfName)
        saveData()
    }
    
    //Income改一条数据
    class func updateIncomeData(indexPath: Int, time: NSDate, number: Float, name: String){
        var data = NSArray()
        data = selectAllData(entityNameOfIncome)
        
        data[indexPath].setValue(time, forKey: incomeOfTime)
        data[indexPath].setValue(number, forKey: incomeOfNumber)
        data[indexPath].setValue(name, forKey: incomeOfName)
        saveData()
    }
    
    //IncomeName插入一条数据
    class func insertIncomeNameData(time: NSDate, name: String){
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let row : AnyObject = NSEntityDescription.insertNewObjectForEntityForName(entityNameOfIncomeName, inManagedObjectContext: allDataSource)
        
        row.setValue(time, forKey: incomeNameOfTime)
        row.setValue(name, forKey: incomeNameOfName)
        saveData()
    }
    
    //IncomeName改一条数据
    class func updateIncomeNameData(indexPath: Int, time: NSDate, name: String){
        var data = NSArray()
        data = selectAllData(entityNameOfIncomeName)
        
        data[indexPath].setValue(time, forKey: incomeNameOfTime)
        data[indexPath].setValue(name, forKey: incomeNameOfName)
        saveData()
    }
    
    //Total插入一条数据
    class func insertTotalData(canUse: Float, time: NSDate){
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let row : AnyObject = NSEntityDescription.insertNewObjectForEntityForName(entityNameOfTotal, inManagedObjectContext: allDataSource)
        row.setValue(canUse, forKey: totalNameOfCanUse)
        row.setValue(time, forKey: totalNameOfTime)
        saveData()
    }
    //Total改一条数据
    class func updateTotalData(indexPath: Int, canUse: Float, time: NSDate){
        var data = NSArray()
        data = selectAllData(entityNameOfTotal)
        data[indexPath].setValue(canUse, forKey: totalNameOfCanUse)
        data[indexPath].setValue(time, forKey: totalNameOfTime)
        saveData()
    }
    
    //CreditAccount插入一条数据
    class func insertAccountData(name: String, time: NSDate){
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let row : AnyObject = NSEntityDescription.insertNewObjectForEntityForName(entityNameOfCreditAccount, inManagedObjectContext: allDataSource)
        row.setValue(name, forKey: creditAccountNameOfName)
        row.setValue(time, forKey: creditAccountNameOfTime)
        saveData()
    }
    
    //CreditAccount改一条数
    class func updateAccountData(indexPath: Int, changeValue: AnyObject, changeEntityName: String){
        var data = NSArray()
        data = selectAllData(entityNameOfCreditAccount)
        data[indexPath].setValue(changeValue, forKey: changeEntityName)
        saveData()
    }
    
    //payName插入一条数据
    class func insertPayNameData(name: String, time: NSDate){
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let row : AnyObject = NSEntityDescription.insertNewObjectForEntityForName(entityNameOfPayName, inManagedObjectContext: allDataSource)
        row.setValue(name, forKey: payNameNameOfName)
        row.setValue(time, forKey: payNameNameOfTime)
        saveData()
    }
    
    //PayName改一条数
    class func updatePayNameData(indexPath: Int, changeValue: AnyObject, changeEntityName: String){
        var data = NSArray()
        data = selectAllData(entityNameOfPayName)
        data[indexPath].setValue(changeValue, forKey: changeEntityName)
        saveData()
    }
    
    //cost插入一条数据
    class func insertCostData(name: String, time: NSDate, type: String, number: Float, period: Int){
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let row : AnyObject = NSEntityDescription.insertNewObjectForEntityForName(entityNameOfCost, inManagedObjectContext: allDataSource)
        row.setValue(name, forKey: costNameOfName)
        row.setValue(time, forKey: costNameOfTime)
        row.setValue(type, forKey: costNameOfType)
        row.setValue(number, forKey: costNameOfNumber)
        row.setValue(period, forKey: costNameOfPeriod)
        saveData()
    }
    
    //cost改一条数
    class func updateCostData(indexPath: Int, changeValue: AnyObject, changeEntityName: String){
        var data = NSArray()
        data = selectAllData(entityNameOfCost)
        data[indexPath].setValue(changeValue, forKey: changeEntityName)
        saveData()
    }
}
