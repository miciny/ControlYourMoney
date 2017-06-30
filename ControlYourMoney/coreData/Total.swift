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
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        var textData : NSArray = []
        let fetchData = NSFetchRequest<NSFetchRequestResult>(entityName: entityNameOfTotal)
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
    
    //Total插入一条数据
    class func insertTotalData(_ canUse: Float, time: Date){
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let row = NSEntityDescription.insertNewObject(forEntityName: entityNameOfTotal,
                                                                      into: allDataSource) as! Total
        row.canUse = canUse as NSNumber
        row.time = time
        saveData()
    }
    
    //Total改一条数据
    class func updateTotalData(_ indexPath: Int, canUse: Float, time: Date){
        var data = NSArray()
        data = selectAllData()
        
        
        (data[indexPath] as AnyObject).setValue(canUse, forKey: totalNameOfCanUse)
        (data[indexPath] as AnyObject).setValue(time, forKey: totalNameOfTime)
        saveData()
    }

}
