//
//  PayName.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/27.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class PayName: NSManagedObject {
    //所有的数据
    class func selectAllData() -> NSArray{
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        var textData : NSArray = []
        let fetchData = NSFetchRequest(entityName: entityNameOfPayName)
//        let predicate = NSPredicate(format: "id= ‘1‘ ", "")
//        fetchData.predicate = predicate
        
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
    
    //payName插入一条数据
    class func insertPayNameData(name: String, time: NSDate){
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let row = NSEntityDescription.insertNewObjectForEntityForName(entityNameOfPayName,
                                                                    inManagedObjectContext: allDataSource) as! PayName
        row.name = name
        row.time = time
        saveData()
    }
}
