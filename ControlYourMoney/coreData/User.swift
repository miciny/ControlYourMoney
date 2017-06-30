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
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        var textData : NSArray = []
        let fetchData = NSFetchRequest<NSFetchRequestResult>(entityName: entityNameOfUser)
        
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
    class func saveData() -> Bool{
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        do {
            _ = try
                allDataSource.save()
            return true
        }catch _ as NSError{
            return false
        }
    }
    
    //插入一条数据
    class func insertUserData(_ account: String!, name: String?, nickname: String!, address: String?, location: String?, pw: String!, sex: String?, time: Date!, motto: String?, pic: Data?, http: String?, picPath: String?){
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let row = NSEntityDescription.insertNewObject(forEntityName: entityNameOfUser,
                                                                      into: allDataSource) as! User
        row.account = account
        row.nickname = nickname
        row.address = address
        row.location = location
        row.pw = pw
        row.sex = sex
        row.name = name
        row.motto = motto
        row.pic = pic as! NSData
        row.http = http
        row.create_time = time as! NSDate
        row.picPath = picPath
        row.changed = true // 插入数据，自动变为变过
        
        saveData()
    }
    
    //改一条数据
    class func updateUserData(_ indexPath: Int, account: String!, name: String?, nickname: String!, address: String?, location: String?, pw: String!, sex: String?, time: Date!, motto: String?, pic: Data?, http: String?, picPath: String?, changed: Bool!){
        var data = NSArray()
        data = selectAllData()
        
        let row =  data[indexPath] as! User
        row.account = account
        row.create_time = time as! NSDate
        row.nickname = nickname
        row.address = address
        row.location = location
        row.pw = pw
        row.sex = sex
        row.name = name
        row.motto = motto
        row.pic = pic as! NSData
        row.http = http
        row.picPath = picPath
        row.changed = changed as! NSNumber
        
        saveData()
    }
    
    //改一条数据
    class func updateuserData(_ indexPath: Int, changeValue: AnyObject, changeFieldName: String) -> Bool{
        var data = NSArray()
        data = selectAllData()
        
        (data[indexPath] as AnyObject).setValue(changeValue, forKey: changeFieldName)
        return saveData()
    }

}
