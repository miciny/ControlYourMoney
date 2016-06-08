//
//  File.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 15/12/21.
//  Copyright © 2015年 maocaiyuan. All rights reserved.
//

import Foundation
import UIKit

//=====================================================================================================
/**
 MARK: - 公共函数
 **/
//=====================================================================================================

//根据服务器给的状态码，返回一个字符串
func getErrorCodeToString(code: String) -> String{
    switch code {
    case "301":
        return "参数为空"
    case "303":
        return "参数为空"
    case "302":
        return "参数错误"
    case "304":
        return "参数错误"
        
    case "400":
        return "连接数据库出错"
    case "401":
        return "连接数据库出错"
        
    case "201":
        return "信息出错"
    case "202":
        return "查询出错"
        
    case "305":
        return "没有上传数据"
    case "306":
        return "上传失败"
    default:
        return "错误"
    }
}

// dic处理数据成json格式
func dicToJson(dic: NSMutableDictionary) -> String {
    let dataArray = dic
    var str = String()
    
    do {
        let dataFinal = try NSJSONSerialization.dataWithJSONObject(dataArray, options:NSJSONWritingOptions(rawValue:0))
        let string = NSString(data: dataFinal, encoding: NSUTF8StringEncoding)
        str = string as! String
        
    }catch{
        
    }
    return str
}

//字符串转成json
func strToJson(str: String) -> AnyObject{
    let data = str.dataUsingEncoding(NSUTF8StringEncoding)
    
    let deserialized = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
    
    //        let data = NSData(contentsOfFile: file)!
    //        json = JSON(data: data)
    
    return deserialized
}

//获取当前时间
func getTime() -> NSDate{
    let now = NSDate()
    //        let zoon = NSTimeZone.systemTimeZone()
    //        let interval : NSInteger = zoon.secondsFromGMTForDate(now)
    //        return now.dateByAddingTimeInterval(Double(interval))
    return now
}

//=====================================================================================================
//时间转为字符串
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


//=====================================================================================================
// String to Date
func stringToDate(dateStr : String) -> NSDate{
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    return dateFormatter.dateFromString(dateStr)!
}

func stringToDateBySelf(dateStr : String, formate: String) -> NSDate{
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = formate
    // String to Date
    return dateFormatter.dateFromString(dateStr)!
}

func stringToDateNoHH(dateStr : String) -> NSDate{
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    // String to Date
    return dateFormatter.dateFromString(dateStr)!
}


//=====================================================================================================
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

//返回一个简单的alert
func textAlertView(str :String) -> UIAlertView{
    let alert = UIAlertView()
    alert.message = str
    alert.addButtonWithTitle("确定")
    alert.show()
    return alert
}

//根据文字获得大小
func sizeWithText(text: NSString, font: UIFont, maxSize: CGSize) -> CGSize{
    let attrs : NSDictionary = [NSFontAttributeName:font]
    return text.boundingRectWithSize(maxSize, options: .UsesLineFragmentOrigin,
                                     attributes: attrs as? [String : AnyObject], context: nil).size
}


// delay(2) { print("2 秒后输出") }
// let task = delay(5) { print("拨打 110") }
// 仔细想一想..
// 还是取消为妙..
// cancel(task)

typealias Task = (cancel : Bool) -> Void

func delay(time:NSTimeInterval, task:()->()) ->  Task? {
    
    func dispatch_later(block:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(time * Double(NSEC_PER_SEC))),
            dispatch_get_main_queue(),
            block)
    }
    
    var closure: dispatch_block_t? = task
    var result: Task?
    
    let delayedClosure: Task = {
        cancel in
        if let internalClosure = closure {
            if (cancel == false) {
                dispatch_async(dispatch_get_main_queue(), internalClosure);
            }
        }
        closure = nil
        result = nil
    }
    
    result = delayedClosure
    
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(cancel: false)
        }
    }
    
    return result;
}

func cancel(task:Task?) {
    task?(cancel: true)
}
