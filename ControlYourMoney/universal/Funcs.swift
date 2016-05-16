//
//  File.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 15/12/21.
//  Copyright © 2015年 maocaiyuan. All rights reserved.
//

import Foundation
import UIKit

//获取当前时间
func getTime() -> NSDate{
    let now = NSDate()
    //        let zoon = NSTimeZone.systemTimeZone()
    //        let interval : NSInteger = zoon.secondsFromGMTForDate(now)
    //        return now.dateByAddingTimeInterval(Double(interval))
    return now
}

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

//设置系统栏颜色
func setStatusBarColor(color: Bool){
    if(color == true){
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated:true)
        //系统栏白色文字 info中 View controller-based status bar appearance设置为no才能用
    }else{
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default //系统栏黑色文字
    }
}

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
