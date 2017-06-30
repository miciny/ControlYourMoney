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
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        var textData : NSArray = []
        let fetchData = NSFetchRequest<NSFetchRequestResult>(entityName: entityNameOfIncomeName)
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
    
    //IncomeName插入一条数据
    class func insertIncomeNameData(_ time: Date, name: String){
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let row = NSEntityDescription.insertNewObject(forEntityName: entityNameOfIncomeName,
                                                                      into: allDataSource) as! IncomeName
        row.name = name
        row.time = time
        saveData()
    }
    
    //IncomeName改一条数据
    class func updateIncomeNameData(_ indexPath: Int, time: Date, name: String){
        var data = NSArray()
        data = selectAllData()
        
        (data[indexPath] as AnyObject).setValue(time, forKey: incomeNameOfTime)
        (data[indexPath] as AnyObject).setValue(name, forKey: incomeNameOfName)
        saveData()
    }

}
