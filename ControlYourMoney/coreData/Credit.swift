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
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        var textData : NSArray = []
        let fetchData = NSFetchRequest<NSFetchRequestResult>(entityName: entityNameOfCredit)
        do {
            _ = try
                textData =  allDataSource.fetch(fetchData) as NSArray
        }catch _ as NSError{
        }
        return textData
    }
    
    //删一条数据
    class func deleteData(_ indexPath: Int){
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        var data = NSArray()
        data = selectAllData()
        allDataSource.delete(data[indexPath] as! NSManagedObject)
        saveData()
    }
    
    //save
    class func saveData(){
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        do {
            _ = try
                allDataSource.save()
        }catch _ as NSError{}
    }
    
    //Credit插入一条数据 ，
    class func insertCrediData(_ periods: Int, number: Float, time: Date,
                               account: String, date: Int, nextPayDay: Date, leftPeriods: Int, type: String){
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let row = NSEntityDescription.insertNewObject(forEntityName: entityNameOfCredit,
                                                                      into: allDataSource) as! Credit
        
        row.periods = periods as NSNumber
        row.number = number as NSNumber
        row.time = time
        row.date = date as NSNumber
        row.account = account
        row.nextPayDay = nextPayDay
        row.leftPeriods = leftPeriods as NSNumber
        row.type = type
        saveData()
    }
    
    //Credit改一条数据， SortedByTime都是根据下次还款时间排序
    class func updateCreditDataSortedByTime(_ indexPath: Int, periods: Int, number: Float,
                                            date: Int, account: String, time: Date,
                                            nextPayDay: Date, leftPeriods: Int, type: String){
        var data = NSArray()
        data = selectAllData()
        
        let time1 = NSSortDescriptor(key: creditNameOfNextPayDay, ascending: true)
        data = data.sortedArray(using: [time1])
        
        (data[indexPath] as AnyObject).setValue(periods, forKey: creditNameOfPeriods)
        (data[indexPath] as AnyObject).setValue(number, forKey: creditNameOfNumber)
        (data[indexPath] as AnyObject).setValue(date, forKey: creditNameOfDate)
        (data[indexPath] as AnyObject).setValue(account, forKey: creditNameOfAccount)
        (data[indexPath] as AnyObject).setValue(time, forKey: creditNameOfTime)
        (data[indexPath] as AnyObject).setValue(nextPayDay, forKey: creditNameOfNextPayDay)
        (data[indexPath] as AnyObject).setValue(leftPeriods, forKey: creditNameOfLeftPeriods)
        (data[indexPath] as AnyObject).setValue(type, forKey: creditNameOfType)
        saveData()
    }
    
    class func updateCreditDataSortedByTime(_ indexPath: Int, changeValue: AnyObject, changeFieldName: String){
        var data = NSArray()
        data = selectAllData()
        
        let time = NSSortDescriptor(key: creditNameOfNextPayDay, ascending: true)
        data = data.sortedArray(using: [time])
        
        (data[indexPath] as AnyObject).setValue(changeValue, forKey: changeFieldName)
        saveData()
    }
    
    //Credit删一条数据
    class func deleteCreditDataSortedByTime(_ indexPath: Int){
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        var data = NSArray()
        data = selectAllData()
        
        let time = NSSortDescriptor(key: creditNameOfNextPayDay, ascending: true)
        data = data.sortedArray(using: [time])
        
        allDataSource.delete(data[indexPath] as! NSManagedObject)
        saveData()
    }

}
