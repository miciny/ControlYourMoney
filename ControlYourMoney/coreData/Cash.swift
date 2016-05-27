//
//  Cash.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/27.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class Cash: NSManagedObject {

    //所有的数据
    class func selectAllData() -> NSArray{
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        var textData : NSArray = []
        let fetchData = NSFetchRequest(entityName: entityNameOfCash)
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
    
    //Cash插入一条数据
    class func insertCashData(useWhere: String, useNumber: Float, type: String, time: NSDate){
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let row = NSEntityDescription.insertNewObjectForEntityForName(entityNameOfCash,
                                                                      inManagedObjectContext: allDataSource) as! Cash
        row.time = time
        row.type = type
        row.useNumber = useNumber
        row.useWhere = useWhere
        saveData()
    }
}
