//
//  User.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/6/2.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class User: NSManagedObject {
    //所有的数据
    class func selectAllData() -> NSArray{
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        var textData : NSArray = []
        let fetchData = NSFetchRequest(entityName: entityNameOfUser)
        
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
    class func saveData() -> Bool{
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        do {
            _ = try
                allDataSource.save()
            return true
        }catch _ as NSError{
            return false
        }
    }
    
    //插入一条数据
    class func insertUserData(account: String!, name: String?, nickname: String!, address: String?, location: String?, pw: String!, sex: String?, time: NSDate!, motto: String?, pic: NSData?, http: String?){
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let row = NSEntityDescription.insertNewObjectForEntityForName(entityNameOfUser,
                                                                      inManagedObjectContext: allDataSource) as! User
        row.account = account
        row.nickname = nickname
        row.address = address
        row.location = location
        row.pw = pw
        row.sex = sex
        row.name = name
        row.motto = motto
        row.pic = pic
        row.http = http
        row.create_time = time
        
        saveData()
    }
    
    //改一条数据
    class func updateUserData(indexPath: Int, account: String!, name: String?, nickname: String!, address: String?, location: String?, pw: String!, sex: String?, time: NSDate!, motto: String?, pic: NSData?, http: String?){
        var data = NSArray()
        data = selectAllData()
        
        let row =  data[indexPath] as! User
        row.account = account
        row.create_time = time
        row.nickname = nickname
        row.address = address
        row.location = location
        row.pw = pw
        row.sex = sex
        row.name = name
        row.motto = motto
        row.pic = pic
        row.http = http
        
        saveData()
    }
    
    //改一条数据
    class func updateuserData(indexPath: Int, changeValue: AnyObject, changeFieldName: String) -> Bool{
        var data = NSArray()
        data = selectAllData()
        
        data[indexPath].setValue(changeValue, forKey: changeFieldName)
        return saveData()
    }

}
