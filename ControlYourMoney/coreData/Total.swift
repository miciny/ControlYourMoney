//
//  Total.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/27.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Total: NSManagedObject {
    //所有的数据
    class func selectAllData() -> NSArray{
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        var textData : NSArray = []
        let fetchData = NSFetchRequest(entityName: entityNameOfTotal)
        do {
            _ = try
                textData =  allDataSource.executeFetchRequest(fetchData)
        }catch _ as NSError{
        }
        return textData
    }
    
    //save
    class func saveData(){
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        do {
            _ = try
                allDataSource.save()
        }catch _ as NSError{}
    }
    
    //Total插入一条数据
    class func insertTotalData(canUse: Float, time: NSDate){
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let row = NSEntityDescription.insertNewObjectForEntityForName(entityNameOfTotal,
                                                                      inManagedObjectContext: allDataSource) as! Total
        row.canUse = canUse
        row.time = time
        saveData()
    }
    
    //Total改一条数据
    class func updateTotalData(indexPath: Int, canUse: Float, time: NSDate){
        var data = NSArray()
        data = selectAllData()
        
        
        data[indexPath].setValue(canUse, forKey: totalNameOfCanUse)
        data[indexPath].setValue(time, forKey: totalNameOfTime)
        saveData()
    }

}
