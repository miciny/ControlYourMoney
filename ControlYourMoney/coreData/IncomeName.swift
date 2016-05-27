//
//  IncomeName.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/27.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class IncomeName: NSManagedObject {
    //所有的数据
    class func selectAllData() -> NSArray{
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        var textData : NSArray = []
        let fetchData = NSFetchRequest(entityName: entityNameOfIncomeName)
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
    
    //IncomeName插入一条数据
    class func insertIncomeNameData(time: NSDate, name: String){
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let row = NSEntityDescription.insertNewObjectForEntityForName(entityNameOfIncomeName,
                                                                      inManagedObjectContext: allDataSource) as! IncomeName
        row.name = name
        row.time = time
        saveData()
    }
    
    //IncomeName改一条数据
    class func updateIncomeNameData(indexPath: Int, time: NSDate, name: String){
        var data = NSArray()
        data = selectAllData()
        
        data[indexPath].setValue(time, forKey: incomeNameOfTime)
        data[indexPath].setValue(name, forKey: incomeNameOfName)
        saveData()
    }

}
