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
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        var textData : NSArray = []
        let fetchData = NSFetchRequest<NSFetchRequestResult>(entityName: entityNameOfPayName)
//        let predicate = NSPredicate(format: "id= ‘1‘ ", "")
//        fetchData.predicate = predicate
        
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
    
    //payName插入一条数据
    class func insertPayNameData(_ name: String, time: Date){
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let row = NSEntityDescription.insertNewObject(forEntityName: entityNameOfPayName,
                                                                    into: allDataSource) as! PayName
        row.name = name
        row.time = time
        saveData()
    }
}
