//
//  Cost.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/27.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class Cost: NSManagedObject {
    //所有的数据
    class func selectAllData() -> NSArray{
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        var textData : NSArray = []
        let fetchData = NSFetchRequest<NSFetchRequestResult>(entityName: entityNameOfCost)
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
    
    //cost插入一条数据, type应该为支出类型，现在没有记录
    class func insertCostData(_ name: String, time: Date, type: String, number: Float, period: Int){
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let row = NSEntityDescription.insertNewObject(forEntityName: entityNameOfCost,
                                                                      into: allDataSource) as! Cost
        row.name = name
        row.time = time
        row.type = type
        row.number = number as NSNumber
        row.period = period as NSNumber
        saveData()
    }

}
