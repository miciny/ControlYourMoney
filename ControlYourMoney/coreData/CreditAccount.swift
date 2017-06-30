//
//  CreditAccount.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/27.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class CreditAccount: NSManagedObject {
    //所有的数据
    class func selectAllData() -> NSArray{
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        var textData : NSArray = []
        let fetchData = NSFetchRequest<NSFetchRequestResult>(entityName: entityNameOfCreditAccount)
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
    
    //CreditAccount插入一条数据
    class func insertAccountData(_ name: String, time: Date){
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let row = NSEntityDescription.insertNewObject(forEntityName: entityNameOfCreditAccount,
                                                                      into: allDataSource) as! CreditAccount
        row.name = name
        row.time = time
        saveData()
    }
    
    //CreditAccount改一条数
    class func updateAccountData(_ indexPath: Int, changeValue: AnyObject, changeEntityName: String){
        var data = NSArray()
        data = selectAllData()
        (data[indexPath] as AnyObject).setValue(changeValue, forKey: changeEntityName)
        saveData()
    }

}
