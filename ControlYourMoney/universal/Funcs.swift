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
func getErrorCodeToString(_ code: String) -> String{
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
    case "404":
        return "无法连接服务器"
        
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
func dicToJson(_ dic: NSMutableDictionary) -> String {
    let dataArray = dic
    var str = String()
    
    do {
        let dataFinal = try JSONSerialization.data(withJSONObject: dataArray, options:JSONSerialization.WritingOptions(rawValue:0))
        let string = NSString(data: dataFinal, encoding: String.Encoding.utf8.rawValue)
        str = string as! String
        
    }catch{
        
    }
    return str
}

//判断网络
enum networkType{
    case cell
    case wifi
    case nonet
}

func checkNet() -> networkType{
    let reachability = Reachability.reachabilityForInternetConnection()
    
    //判断连接类型
    if reachability!.isReachableViaWiFi() {
        return networkType.wifi
    }else if reachability!.isReachableViaWWAN() {
        return networkType.cell
    }else {
        return networkType.nonet
    }
}

//字符串转成json
func strToJson(_ str: String) -> AnyObject{
    let data = str.data(using: String.Encoding.utf8)
    
    let deserialized = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
    
    //        let data = NSData(contentsOfFile: file)!
    //        json = JSON(data: data)
    
    return deserialized as AnyObject
}

//获取当前时间
func getTime() -> Date{
    let now = Date()
    //        let zoon = NSTimeZone.systemTimeZone()
    //        let interval : NSInteger = zoon.secondsFromGMTForDate(now)
    //        return now.dateByAddingTimeInterval(Double(interval))
    return now
}

//=====================================================================================================
//时间转为字符串
func dateToString(_ date : Date) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    // Date 转 String
    return dateFormatter.string(from: date)
}

func dateToStringNoHH(_ date : Date) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    // Date 转 String
    return dateFormatter.string(from: date)
}

//自定义的dateToString
func dateToStringBySelf(_ date : Date, str:String) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = str
    // Date 转 String
    return dateFormatter.string(from: date)
}


//=====================================================================================================
// String to Date
func stringToDate(_ dateStr : String) -> Date{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    return dateFormatter.date(from: dateStr)!
}

func stringToDateBySelf(_ dateStr : String, formate: String) -> Date{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = formate
    // String to Date
    return dateFormatter.date(from: dateStr)!
}

func stringToDateNoHH(_ dateStr : String) -> Date{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    // String to Date
    return dateFormatter.date(from: dateStr)!
}


//=====================================================================================================
//判断字符串为数字
func stringIsInt(_ str: String) -> Bool{
    let scan = Scanner(string: str)
    var i = Int32()
    return scan.scanInt32(&i) && scan.isAtEnd
}

//判断字符串为浮点型
func stringIsFloat(_ str: String) -> Bool{
    let scan = Scanner(string: str)
    var f = Float()
    return scan.scanFloat(&f) && scan.isAtEnd
}

//返回一个简单的alert
func textAlertView(_ str :String) -> UIAlertView{
    let alert = UIAlertView()
    alert.message = str
    alert.addButton(withTitle: "确定")
    alert.show()
    return alert
}

//根据文字获得大小
func sizeWithText(_ text: NSString, font: UIFont, maxSize: CGSize) -> CGSize{
    let attrs : NSDictionary = [NSFontAttributeName:font]
    return text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin,
                                     attributes: attrs as? [String : AnyObject], context: nil).size
}


// delay(2) { print("2 秒后输出") }
// let task = delay(5) { print("拨打 110") }
// 仔细想一想..
// 还是取消为妙..
// cancel(task)

typealias Task = (_ cancel : Bool) -> Void

func delay(_ time:TimeInterval, task:@escaping ()->()) ->  Task? {
    
    func dispatch_later(_ block:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: block)
    }
    
    var closure: ()->()? = task
    var result: Task?
    
    let delayedClosure: Task = {
        cancel in
        if let internalClosure = closure {
            if (cancel == false) {
                DispatchQueue.main.async(execute: internalClosure);
            }
        }
        closure = nil
        result = nil
    }
    
    result = delayedClosure
    
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }
    
    return result;
}

func cancel(_ task:Task?) {
    task?(true)
}
