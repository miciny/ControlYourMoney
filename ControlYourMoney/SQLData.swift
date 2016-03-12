//
//  Cash.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 15/12/19.
//  Copyright © 2015年 maocaiyuan. All rights reserved.
//

import Foundation
import CoreData
import UIKit

let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

//所有的数据
func SelectAllData(entityName:String) -> NSArray{
    var textData : NSArray = []
    let fetchData = NSFetchRequest(entityName: entityName)
    do {
        _ = try
            textData =  allDataSource.executeFetchRequest(fetchData)
    }catch _ as NSError{
    }
    return textData
}
//删一条数据
func DeleteData(entityName:String,indexPath:Int){
    var data = NSArray()
    data = SelectAllData(entityName)
    allDataSource.deleteObject(data[indexPath] as! NSManagedObject)
    saveData()
}

//save
func saveData(){
    do {
        _ = try
            allDataSource.save()
    }catch _ as NSError{}
}

//Cash插入一条数据
func InsertCashData(useWhere:String,useNumber:Float,time:NSDate){
    
    let row : AnyObject = NSEntityDescription.insertNewObjectForEntityForName(entityNameOfCash, inManagedObjectContext: allDataSource)
    
    row.setValue(useWhere, forKey: cashNameOfUseWhere)
    row.setValue(useNumber, forKey: cashNameOfUseNumber)
    row.setValue(time, forKey: cashNameOfTime)
    saveData()
}
//Cash改一条数据
func UpdateCashData(indexPath:Int,useWhere:String,useNumber:Float,time:NSDate){
    var data = NSArray()
    data = SelectAllData(entityNameOfCash)
    
    data[indexPath].setValue(useWhere, forKey: cashNameOfUseWhere)
    data[indexPath].setValue(useNumber, forKey: cashNameOfUseNumber)
    data[indexPath].setValue(time, forKey:cashNameOfTime)
    saveData()
}

//Credit插入一条数据
func InsertCrediData(periods:Int,number:Float,time:NSDate,account:String, date : Int){
    
    let row : AnyObject = NSEntityDescription.insertNewObjectForEntityForName(entityNameOfCredit, inManagedObjectContext: allDataSource)
    
    row.setValue(periods, forKey: creditNameOfPeriods)
    row.setValue(number, forKey: creditNameOfNumber)
    row.setValue(date, forKey: creditNameOfDate)
    row.setValue(account, forKey: creditNameOfAccount)
    row.setValue(time, forKey: creditNameOfTime)
    saveData()
}
//Credit改一条数据
func UpdateCreditData(indexPath:Int,periods:Int,number:Float,date : Int ,account:String,time:NSDate){
    var data = NSArray()
    data = SelectAllData(entityNameOfCredit)
    
    data[indexPath].setValue(periods, forKey: creditNameOfPeriods)
    data[indexPath].setValue(number, forKey: creditNameOfNumber)
    data[indexPath].setValue(date, forKey: creditNameOfDate)
    data[indexPath].setValue(account, forKey: creditNameOfAccount)
    data[indexPath].setValue(time, forKey: creditNameOfTime)
    saveData()
}
//Credit改一条数据
func UpdateCreditDataSortedByTime(indexPath:Int,periods:Int,number:Float,date : Int ,account:String,time:NSDate){
    var data = NSArray()
    data = SelectAllData(entityNameOfCredit)
    
    let time1 : NSSortDescriptor = NSSortDescriptor.init(key: creditNameOfTime, ascending: true)
    data = data.sortedArrayUsingDescriptors([time1])
    
    data[indexPath].setValue(periods, forKey: creditNameOfPeriods)
    data[indexPath].setValue(number, forKey: creditNameOfNumber)
    data[indexPath].setValue(date, forKey: creditNameOfDate)
    data[indexPath].setValue(account, forKey: creditNameOfAccount)
    data[indexPath].setValue(time, forKey: creditNameOfTime)
    saveData()
}

//Salary插入一条数据
func InsertSalaryData(time:NSDate,number:Float){
    
    let row : AnyObject = NSEntityDescription.insertNewObjectForEntityForName(entityNameOfSalary, inManagedObjectContext: allDataSource)
    
    row.setValue(time, forKey: salaryNameOftime)
    row.setValue(number, forKey: salaryNameOfNumber)
    saveData()
}
//Salary改一条数据
func UpdateSalaryData(indexPath:Int,time:NSDate,number:Float){
    var data = NSArray()
    data = SelectAllData(entityNameOfSalary)
    
    data[indexPath].setValue(time, forKey: salaryNameOftime)
    data[indexPath].setValue(number, forKey: salaryNameOfNumber)
    saveData()
}

//Total插入一条数据
func InsertTotaleData(total : Float,canUse : Float){
    
    let row : AnyObject = NSEntityDescription.insertNewObjectForEntityForName(entityNameOfTotal, inManagedObjectContext: allDataSource)
    row.setValue(total, forKey: TotalNameOfTotal)
    row.setValue(canUse, forKey: TotalNameOfCanUse)
    saveData()
}
//Total改一条数据
func UpdateTotalData(indexPath:Int, total : Float,canUse : Float){
    var data = NSArray()
    data = SelectAllData(entityNameOfTotal)
    data[indexPath].setValue(total, forKey: TotalNameOfTotal)
    data[indexPath].setValue(canUse, forKey: TotalNameOfCanUse)
    saveData()
}
