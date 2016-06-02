//
//  InternetSetting.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/6/2.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class InternetSetting: NSManagedObject {
    //所有的数据
    class func selectAllData() -> NSArray{
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        var textData : NSArray = []
        let fetchData = NSFetchRequest(entityName: entityNameOfInternetSetting)
        
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
    
    //插入一条数据
    class func insertInternetSettingData(ip: String!, port: String!, internet: Bool!){
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let row = NSEntityDescription.insertNewObjectForEntityForName(entityNameOfInternetSetting,
                                                                      inManagedObjectContext: allDataSource) as! InternetSetting
        row.ip = ip
        row.port = port
        row.internet = internet
        
        saveData()
    }
    
    //改一条数据
    class func updateuserData(indexPath: Int, changeValue: AnyObject, changeFieldName: String){
        var data = NSArray()
        data = selectAllData()
        
        data[indexPath].setValue(changeValue, forKey: changeFieldName)
        saveData()
    }

}
