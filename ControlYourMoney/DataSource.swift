//
//  File.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 15/12/21.
//  Copyright © 2015年 maocaiyuan. All rights reserved.
//

import Foundation
import UIKit

let rowHeight : CGFloat = 120

let mainViewTitle = "Control Your Money"

let entityNameOfCash = "Cash"
let entityNameOfCredit = "Credit"
let entityNameOfSalary = "Salary"
let entityNameOfTotal = "Total"

let keyOfCash = "记账"
let keyOfCredit = "信用卡（电子信用账号）"
let keyOfSalary = "工资"
let keyOfTotal = "总计"

let cashNameOfUseWhere = "useWhere"
let cashNameOfUseNumber = "useNumber"
let cashNameOfTime = "time"

let creditNameOfPeriods = "periods"
let creditNameOfNumber = "number"
let creditNameOfAccount = "account"
let creditNameOfDate = "date"
let creditNameOfTime = "time"


let salaryNameOftime = "time"
let salaryNameOfNumber = "number"

let TotalNameOfCanUse = "canUse"
let TotalNameOfTime = "time"
let addArray = ["现金记账","信用卡（电子分期）","工资"]


func getTime() -> NSDate{
    let now : NSDate = NSDate()
    //        let zoon = NSTimeZone.systemTimeZone()
    //        let interval : NSInteger = zoon.secondsFromGMTForDate(now)
    //        return now.dateByAddingTimeInterval(Double(interval))
    return now
}

func getCanUseToFloat() -> Float{
    if(SelectAllData(entityNameOfTotal).count == 0){
        return 0
    }else{
        return SelectAllData(entityNameOfTotal).valueForKey(TotalNameOfCanUse).lastObject as! Float
    }
}

func getCreditDayToIntArray() -> NSArray{
    return (SelectAllData(entityNameOfCredit) as NSArray).valueForKey(creditNameOfDate) as! NSArray
}
func getCreditNumberToFloatArray() -> NSArray{
    return (SelectAllData(entityNameOfCredit) as NSArray).valueForKey(creditNameOfNumber) as! NSArray
}
func getCreditPeriodsToIntArray() -> NSArray{
    return (SelectAllData(entityNameOfCredit) as NSArray).valueForKey(creditNameOfPeriods) as! NSArray
}
func getCreditAccountToStringArray() -> NSArray{
    return (SelectAllData(entityNameOfCredit) as NSArray).valueForKey(creditNameOfAccount) as! NSArray
}
func getCreditTimeToNsdateArray() -> NSArray{
    return (SelectAllData(entityNameOfCredit) as NSArray).valueForKey(creditNameOfTime) as! NSArray
}



func dateToString(date : NSDate) -> String{
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    // Date 转 String
    return dateFormatter.stringFromDate(date)
}

func dateToStringNoHH(date : NSDate) -> String{
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    // Date 转 String
    return dateFormatter.stringFromDate(date)
}

//自定义的dateToString
func dateToStringBySelf(date : NSDate, str:String) -> String{
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = str
    // Date 转 String
    return dateFormatter.stringFromDate(date)
}

func stringToDate(dateStr : String) -> NSDate{
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    // String to Date
    return dateFormatter.dateFromString(dateStr)!
}

func stringToDateNoHH(dateStr : String) -> NSDate{
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    // String to Date
    return dateFormatter.dateFromString(dateStr)!
}

//提取时间的年 月  日，转为int
func dateToInt(date : NSDate,dd : String) -> Int{
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = dd
    return Int(dateFormatter.stringFromDate(date))!
}


//判断字符串为数字
func stringIsInt(str: String) -> Bool{
    let scan = NSScanner(string: str)
    var i = Int32()
    return scan.scanInt(&i) && scan.atEnd
}

//判断字符串为浮点型
func stringIsFloat(str: String) -> Bool{
    let scan = NSScanner(string: str)
    var f = Float()
    return scan.scanFloat(&f) && scan.atEnd
}

//根据时间判断信用还款
func calculateCredit(){
    let creditAccountNumber = (SelectAllData(entityNameOfCredit) as NSArray).count
    let calculateTime = getTime()
    for(var i = 0 ; i < creditAccountNumber; i++){
        let day : Int = getCreditDayToIntArray()[i] as! Int
        let number : Float = getCreditNumberToFloatArray()[i] as! Float
        let periods : Int = getCreditPeriodsToIntArray()[i] as! Int
        let accout : String = getCreditAccountToStringArray()[i] as! String
        let date : NSDate = getCreditTimeToNsdateArray()[i] as! NSDate
        
        if(dateToInt(date, dd: "yyyy") == dateToInt(calculateTime, dd: "yyyy")){
            let months = dateToInt(calculateTime, dd: "MM") - dateToInt(date, dd: "MM")
            if(months == 0 && day <= dateToInt(calculateTime, dd: "dd")){
                if(periods == 1){
                    DeleteData(entityNameOfCredit, indexPath: i)
                    InsertTotaleData(getCanUseToFloat() - number, time:  calculateTime)
                }else{
                    if(dateToInt(calculateTime, dd: "MM") == 12){
                        let timeTmp = stringToDateNoHH(String(dateToInt(date, dd: "yyyy") + 1) + "-1-" + String(day))
                        UpdateCreditData(i, periods: periods - 1, number: number, date: day, account: accout, time: timeTmp)
                        InsertTotaleData( getCanUseToFloat() - number, time:  calculateTime)
                    }else{
                        let timeTmp = stringToDateNoHH(String(dateToInt(date, dd: "yyyy")) + "-" + String(dateToInt(date, dd: "MM") + 1) + "-" + String(day))
                        UpdateCreditData(i, periods: periods - 1, number: number, date: day, account: accout, time: timeTmp)
                        InsertTotaleData(getCanUseToFloat() - number, time:  calculateTime)
                    }
                }
            }else if(months > 0 && day <= dateToInt(calculateTime, dd: "dd")){
                if((months+1) >= periods){
                    DeleteData(entityNameOfCredit, indexPath: i)
                    InsertTotaleData( getCanUseToFloat() - number * Float(periods), time:  calculateTime)
                }else{
                    if(dateToInt(calculateTime, dd: "MM") == 12){
                        let timeTmp = stringToDateNoHH(String(dateToInt(date, dd: "yyyy") + 1) + "-1-" + String(day))
                        UpdateCreditData(i, periods: periods - months - 1, number: number, date: day, account: accout, time: timeTmp)
                        InsertTotaleData(getCanUseToFloat() - number * Float(months+1), time:  calculateTime)
                    }else{
                        let timeTmp = stringToDateNoHH(String(dateToInt(date, dd: "yyyy")) + "-" + String(dateToInt(calculateTime, dd: "MM") + 1) + "-" + String(day))
                        UpdateCreditData(i, periods: periods - months - 1, number: number, date: day, account: accout, time: timeTmp)
                        InsertTotaleData(getCanUseToFloat() - number * Float(months+1), time:  calculateTime)
                    }
                }
            }else if(months > 0 && day > dateToInt(calculateTime, dd: "dd")){
                if(months >= periods){
                    DeleteData(entityNameOfCredit, indexPath: i)
                    InsertTotaleData( getCanUseToFloat() - number * Float(periods), time:  calculateTime)
                }else{
                    let timeTmp = stringToDateNoHH(String(dateToInt(calculateTime, dd: "yyyy"))  + "-" + String(dateToInt(calculateTime, dd: "MM")) + "-" + String(day))
                    UpdateCreditData(i, periods: periods - months, number: number, date: day, account: accout, time: timeTmp)
                    InsertTotaleData(getCanUseToFloat() - number * Float(months), time:  calculateTime)
                }
            }
            
        }else if(dateToInt(date, dd: "yyyy") < dateToInt(calculateTime, dd: "yyyy")){
            let months = dateToInt(calculateTime, dd: "MM") + 12 - dateToInt(date, dd: "MM")
            if(day <= dateToInt(calculateTime, dd: "dd")){
                if((months+1) >= periods){
                    DeleteData(entityNameOfCredit, indexPath: i)
                    InsertTotaleData(getCanUseToFloat() - number * Float(periods), time:  calculateTime)
                }else{
                    if((dateToInt(calculateTime, dd: "MM")) == 12){
                        let timeTmp = stringToDateNoHH(String(dateToInt(calculateTime, dd: "yyyy") + 1) + "-1-" + String(day))
                        UpdateCreditData(i, periods: periods - months - 1, number: number, date: day, account: accout, time: timeTmp)
                        InsertTotaleData(getCanUseToFloat() - number * Float(months+1), time:  calculateTime)
                    }else{
                        let timeTmp = stringToDateNoHH(String(dateToInt(calculateTime, dd: "yyyy"))  + "-" + String(dateToInt(calculateTime, dd: "MM")) + "-" + String(dateToInt(calculateTime, dd: "MM") + 1) + "-" + String(day))
                        UpdateCreditData(i, periods: periods - months - 1, number: number, date: day, account: accout, time: timeTmp)
                        InsertTotaleData( getCanUseToFloat() - number * Float(months+1), time:  calculateTime)
                    }
                }
            }else if(day > dateToInt(calculateTime, dd: "dd")){
                if(months >= periods){
                    DeleteData(entityNameOfCredit, indexPath: i)
                    InsertTotaleData(getCanUseToFloat() - number * Float(periods), time:  calculateTime)
                }else{
                    let timeTmp = stringToDateNoHH(String(dateToInt(calculateTime, dd: "yyyy"))  + "-" + String(dateToInt(calculateTime, dd: "MM")) + "-" + String(day))
                    UpdateCreditData(i, periods: periods - months, number: number, date: day, account: accout, time: timeTmp)
                    InsertTotaleData(getCanUseToFloat() - number * Float(months), time:  calculateTime)
                }
            }

        }
    }
}

//设置系统栏颜色
func setStatusBarColor(color: Bool){
    if(color == true){
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated:true)//系统栏白色文字 info中 View controller-based status bar appearance设置为no才能用
    }else{
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default //系统栏黑色文字
    }
}
