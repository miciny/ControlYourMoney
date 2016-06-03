//
//  InitData.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/6/2.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class InitData: NSObject {
    
    //根据现在时间，计算每个信用卡的还款情况
    class func calculateCredit(){
        var creditArray = Credit.selectAllData()
        //排序
        let time = NSSortDescriptor.init(key: creditNameOfTime, ascending: true)
        creditArray = creditArray.sortedArrayUsingDescriptors([time])
        
        guard creditArray.count > 0 else{
            return
        }
        
        let timeNow = getTime()
        for i in 0 ..< creditArray.count {
            let nextPayDay = creditArray.objectAtIndex(i).valueForKey(creditNameOfNextPayDay) as! NSDate  // 下期还款日期
            let leftPeriods = creditArray.objectAtIndex(i).valueForKey(creditNameOfLeftPeriods) as! Int  // 剩余还款期数
            
            //剩余还款大于0的才计算
            if leftPeriods > 0 {
                let months = CalculateCredit.getMonthOffset(timeNow, time2: nextPayDay)  //获取月份差
                let number = creditArray.objectAtIndex(i).valueForKey(creditNameOfNumber) as! Float  //
                if months < leftPeriods && months > 0{
                    
                    let nextPay = CalculateCredit.calculateTime(nextPayDay, months: months)
                    Credit.updateCreditDataSortedByTime(i, changeValue: leftPeriods-months, changeFieldName: creditNameOfLeftPeriods)
                    Credit.updateCreditDataSortedByTime(i, changeValue: nextPay, changeFieldName: creditNameOfNextPayDay)
                    CalculateCredit.changeTotal(Float(months)*number)
                    
                }else if(months >= leftPeriods && months > 0){
                    let nextPay = CalculateCredit.calculateTime(nextPayDay, months: leftPeriods-1) //－1是为了，下期还款是是真实的最后还款日
                    Credit.updateCreditDataSortedByTime(i, changeValue: 0, changeFieldName: creditNameOfLeftPeriods)
                    Credit.updateCreditDataSortedByTime(i, changeValue: nextPay, changeFieldName: creditNameOfNextPayDay)
                    CalculateCredit.changeTotal(Float(leftPeriods)*number)
                }
            }
        }
    }
    
    //判断本地是否存在了用户信息
    class func userExsit() -> Bool{
        let data = User.selectAllData()
        if data.count == 0 {
            return false
        }else{
            return true
        }
    }
}
