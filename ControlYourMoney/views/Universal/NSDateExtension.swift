//
//  NSDateExtension.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/16.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation

extension NSDate{
    /// 返回当前日期 年份
    var currentYear:Int{
        get{
            return getFormatDate("yyyy")
        }
    }
    /// 返回当前日期 月份
    var currentMonth:Int{
        get{
            return getFormatDate("MM")
        }
    }
    /// 返回当前日期 天
    var currentDay:Int{
        get{
            return getFormatDate("dd")
        }
    }
    
    /**
     获取yyyy  MM  dd  HH mm ss
     - parameter format: 比如 GetFormatDate(yyyy) 返回当前日期年份
     - returns: 返回值
     */
    func getFormatDate(format:String)->Int{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        let dateString:String = dateFormatter.stringFromDate(self)
        var dates:[String] = dateString.componentsSeparatedByString("")
        let Value  = dates[0]
        if(Value==""){
            return 0
        }
        return Int(Value)!
    }
}