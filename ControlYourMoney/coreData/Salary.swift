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
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        var textData : NSArray = []
        let fetchData = NSFetchRequest<NSFetchRequestResult>(entityName: entityNameOfIncome)
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
    
    //Income插入一条数据
    class func insertIncomeData(_ time: Date, number: Float, name: String){
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let row = NSEntityDescription.insertNewObject(forEntityName: entityNameOfIncome,
                                                                      into: allDataSource) as! Salary
        
        row.name = name
        row.number = number as NSNumber
        row.time = time
        saveData()
    }
    
    //Income改一条数据
    class func updateIncomeData(_ indexPath: Int, time: Date, number: Float, name: String){
        var data = NSArray()
        data = selectAllData()
        
        (data[indexPath] as AnyObject).setValue(time, forKey: incomeOfTime)
        (data[indexPath] as AnyObject).setValue(number, forKey: incomeOfNumber)
        (data[indexPath] as AnyObject).setValue(name, forKey: incomeOfName)
        saveData()
    }

}
