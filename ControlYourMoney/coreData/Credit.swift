//
//  Credit.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/27.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Credit: NSManagedObject {
    //所有的数据
    class func selectAllData() -> NSArray{
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        var textData : NSArray = []
        let fetchData = NSFetchRequest(entityName: entityNameOfCredit)
        do {
            _ = try
                textData =  allDataSource.executeFetchRequest(fetchData)
        }catch _ as NSError{
        }
        return textData
    }
    
    //删一条数据
    class func deleteData(indexPath: Int){
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        var data = NSArray()
        data = selectAllData()
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
    
    //Credit插入一条数据
    class func insertCrediData(periods: Int, number: Float, time: NSDate, account: String, date: Int, nextPayDay: NSDate, leftPeriods: Int, type: String){
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let row = NSEntityDescription.insertNewObjectForEntityForName(entityNameOfCredit,
                                                                      inManagedObjectContext: allDataSource) as! Credit
        
        row.periods = periods
        row.number = number
        row.time = time
        row.date = date
        row.account = account
        row.nextPayDay = nextPayDay
        row.leftPeriods = leftPeriods
        row.type = type
        saveData()
    }
    
    //Credit改一条数据
    class func updateCreditDataSortedByTime(indexPath: Int, periods: Int, number: Float, date: Int, account: String, time: NSDate, nextPayDay: NSDate, leftPeriods: Int, type: String){
        var data = NSArray()
        data = selectAllData()
        
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
        data = selectAllData()
        
        let time = NSSortDescriptor.init(key: creditNameOfNextPayDay, ascending: true)
        data = data.sortedArrayUsingDescriptors([time])
        
        data[indexPath].setValue(changeValue, forKey: changeEntityName)
        saveData()
    }
    
    //Credit删一条数据
    class func deleteCreditDataSortedByTime(indexPath: Int){
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        var data = NSArray()
        data = selectAllData()
        
        let time = NSSortDescriptor.init(key: creditNameOfNextPayDay, ascending: true)
        data = data.sortedArrayUsingDescriptors([time])
        
        allDataSource.deleteObject(data[indexPath] as! NSManagedObject)
        saveData()
    }

}
