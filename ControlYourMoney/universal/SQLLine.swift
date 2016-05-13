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
    class func insertCashData(useWhere: String, useNumber: Float, time: NSDate){
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let row : AnyObject = NSEntityDescription.insertNewObjectForEntityForName(entityNameOfCash, inManagedObjectContext: allDataSource)
        
        row.setValue(useWhere, forKey: cashNameOfUseWhere)
        row.setValue(useNumber, forKey: cashNameOfUseNumber)
        row.setValue(time, forKey: cashNameOfTime)
        saveData()
    }
    //Cash改一条数据
    class func updateCashData(indexPath: Int, useWhere: String, useNumber: Float, time: NSDate){
        var data = NSArray()
        data = selectAllData(entityNameOfCash)
        
        data[indexPath].setValue(useWhere, forKey: cashNameOfUseWhere)
        data[indexPath].setValue(useNumber, forKey: cashNameOfUseNumber)
        data[indexPath].setValue(time, forKey:cashNameOfTime)
        saveData()
    }
    
    //Credit插入一条数据
    class func insertCrediData(periods: Int, number: Float, time: NSDate, account: String, date : Int){
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let row : AnyObject = NSEntityDescription.insertNewObjectForEntityForName(entityNameOfCredit, inManagedObjectContext: allDataSource)
        
        row.setValue(periods, forKey: creditNameOfPeriods)
        row.setValue(number, forKey: creditNameOfNumber)
        row.setValue(date, forKey: creditNameOfDate)
        row.setValue(account, forKey: creditNameOfAccount)
        row.setValue(time, forKey: creditNameOfTime)
        saveData()
    }
    //Credit改一条数据
    class func updateCreditData(indexPath: Int, periods: Int, number: Float, date: Int, account: String, time: NSDate){
        var data = NSArray()
        data = selectAllData(entityNameOfCredit)
        
        data[indexPath].setValue(periods, forKey: creditNameOfPeriods)
        data[indexPath].setValue(number, forKey: creditNameOfNumber)
        data[indexPath].setValue(date, forKey: creditNameOfDate)
        data[indexPath].setValue(account, forKey: creditNameOfAccount)
        data[indexPath].setValue(time, forKey: creditNameOfTime)
        saveData()
    }
    //Credit改一条数据
    class func updateCreditDataSortedByTime(indexPath: Int, periods: Int, number: Float, date: Int, account: String, time: NSDate){
        var data = NSArray()
        data = selectAllData(entityNameOfCredit)
        
        let time1 : NSSortDescriptor = NSSortDescriptor.init(key: creditNameOfTime, ascending: true)
        data = data.sortedArrayUsingDescriptors([time1])
        
        data[indexPath].setValue(periods, forKey: creditNameOfPeriods)
        data[indexPath].setValue(number, forKey: creditNameOfNumber)
        data[indexPath].setValue(date, forKey: creditNameOfDate)
        data[indexPath].setValue(account, forKey: creditNameOfAccount)
        data[indexPath].setValue(time, forKey: creditNameOfTime)
        saveData()
    }
    
    class func updateCreditData(indexPath: Int, changeValue: AnyObject, changeEntityName: String){
        var data = NSArray()
        data = selectAllData(entityNameOfCredit)
        data[indexPath].setValue(changeValue, forKey: changeEntityName)
        saveData()
    }
    
    //Credit删一条数据
    class func deleteCreditData(indexPath: Int){
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        var data = NSArray()
        data = selectAllData(entityNameOfCredit)
        
        let time1 : NSSortDescriptor = NSSortDescriptor.init(key: creditNameOfTime, ascending: true)
        data = data.sortedArrayUsingDescriptors([time1])
        
        allDataSource.deleteObject(data[indexPath] as! NSManagedObject)
        saveData()
    }
    
    //Salary插入一条数据
    class func insertSalaryData(time: NSDate, number: Float){
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let row : AnyObject = NSEntityDescription.insertNewObjectForEntityForName(entityNameOfSalary, inManagedObjectContext: allDataSource)
        
        row.setValue(time, forKey: salaryNameOfTime)
        row.setValue(number, forKey: salaryNameOfNumber)
        saveData()
    }
    //Salary改一条数据
    class func updateSalaryData(indexPath: Int, time: NSDate, number: Float){
        var data = NSArray()
        data = selectAllData(entityNameOfSalary)
        
        data[indexPath].setValue(time, forKey: salaryNameOfTime)
        data[indexPath].setValue(number, forKey: salaryNameOfNumber)
        saveData()
    }
    
    //Total插入一条数据
    class func insertTotalData(canUse: Float, time: NSDate){
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let row : AnyObject = NSEntityDescription.insertNewObjectForEntityForName(entityNameOfTotal, inManagedObjectContext: allDataSource)
        row.setValue(canUse, forKey: TotalNameOfCanUse)
        row.setValue(time, forKey: TotalNameOfTime)
        saveData()
    }
    //Total改一条数据
    class func updateTotalData(indexPath: Int, canUse: Float, time: NSDate){
        var data = NSArray()
        data = selectAllData(entityNameOfTotal)
        data[indexPath].setValue(canUse, forKey: TotalNameOfCanUse)
        data[indexPath].setValue(time, forKey: TotalNameOfTime)
        saveData()
    }
    
    //account插入一条数据
    class func insertAccountData(name: String, time: NSDate){
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let row : AnyObject = NSEntityDescription.insertNewObjectForEntityForName(entityNameOfCreditAccount, inManagedObjectContext: allDataSource)
        row.setValue(name, forKey: accountNameOfName)
        row.setValue(time, forKey: accountNameOfTime)
        saveData()
    }
    
    //account改一条数
    class func updateAccountData(indexPath: Int, changeValue: AnyObject, changeEntityName: String){
        var data = NSArray()
        data = selectAllData(entityNameOfCreditAccount)
        data[indexPath].setValue(changeValue, forKey: changeEntityName)
        saveData()
    }
}
