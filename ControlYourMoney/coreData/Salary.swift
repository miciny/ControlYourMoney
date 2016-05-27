//
//  Salary.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/27.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Salary: NSManagedObject {
    //所有的数据
    class func selectAllData() -> NSArray{
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        var textData : NSArray = []
        let fetchData = NSFetchRequest(entityName: entityNameOfIncome)
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
    
    //Income插入一条数据
    class func insertIncomeData(time: NSDate, number: Float, name: String){
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let row = NSEntityDescription.insertNewObjectForEntityForName(entityNameOfIncome,
                                                                      inManagedObjectContext: allDataSource) as! Salary
        
        row.name = name
        row.number = number
        row.time = time
        saveData()
    }
    
    //Income改一条数据
    class func updateIncomeData(indexPath: Int, time: NSDate, number: Float, name: String){
        var data = NSArray()
        data = selectAllData()
        
        data[indexPath].setValue(time, forKey: incomeOfTime)
        data[indexPath].setValue(number, forKey: incomeOfNumber)
        data[indexPath].setValue(name, forKey: incomeOfName)
        saveData()
    }

}
