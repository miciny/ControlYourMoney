//
//  InsertData.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/31.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

//=====================================================================================================
/**
 MARK: - 插入数据到本地数据库
 **/
//=====================================================================================================

import UIKit
import SwiftyJSON

class InsertData: NSObject {
    
    //插入所有money数据
    class func insertAllMoneyData(json: JSON){
        let cashDic = json[entityNameOfCash]
        InsertData.insertCashData(cashDic)
        
        let incomeDic = json[entityNameOfIncome]
        InsertData.insertIncomeData(incomeDic)
        
        let incomeNameDic = json[entityNameOfIncomeName]
        InsertData.insertIncomeNameData(incomeNameDic)
        
        let costDic = json[entityNameOfCost]
        InsertData.insertCostData(costDic)
        
        let totalDic = json[entityNameOfTotal]
        InsertData.insertTotalData(totalDic)
        
        let payNameDic = json[entityNameOfPayName]
        InsertData.insertPayNameData(payNameDic)
        
        let creditAccountDic = json[entityNameOfCreditAccount]
        InsertData.insertCreditAccountData(creditAccountDic)
        
        let creditDic = json[entityNameOfCredit]
        InsertData.insertCreditData(creditDic)
    }
    
    //初始化user数据
    class func initUserData(data: UserInfoModel){
        let dataTemp = User.selectAllData()
        if dataTemp.count == 0 {
            User.insertUserData(data.account, name: data.name, nickname: data.nickname, address: data.address, location: data.location, pw: data.pw, sex: data.sex, time: data.time, motto: data.motto, pic: data.pic, http: data.http)
        }else{
            User.updateUserData(0, account: data.account, name: data.name, nickname: data.nickname, address: data.address, location: data.location, pw: data.pw, sex: data.sex, time: data.time, motto: data.motto, pic: data.pic, http: data.http)
        }
    }
    
    
    //现金
    class func insertCashData(cashDic: JSON){
        if cashDic != nil{
            for i in 0 ..< cashDic.count {
                let row = cashDic[i]
                
                let time = row[cashNameOfTime].stringValue
                let type = row[cashNameOfType].stringValue
                let useWhere = row[cashNameOfUseWhere].stringValue
                let useNumber = row[cashNameOfUseNumber].stringValue
                
                Cash.insertCashData(useWhere, useNumber: Float(useNumber)!, type: type,
                                    time: stringToDateBySelf(time, formate: "yyyy-MM-dd HH:mm:ss.ssss"))
            }
        }
    }
    
    //收入
    class func insertIncomeData(incomeDic: JSON){
        if incomeDic != nil{
            for i in 0 ..< incomeDic.count {
                let row = incomeDic[i]
                
                let time = row[incomeOfTime].stringValue
                let name = row[incomeOfName].stringValue
                let number = row[incomeOfNumber].stringValue
                
                Salary.insertIncomeData(stringToDateBySelf(time, formate: "yyyy-MM-dd HH:mm:ss.ssss"),
                                        number: Float(number)!, name: name)
            }
        }
    }
    
    //收入来源
    class func insertIncomeNameData(incomeNameDic: JSON){
        if incomeNameDic != nil{
            for i in 0 ..< incomeNameDic.count {
                let row = incomeNameDic[i]
                
                let time = row[incomeNameOfTime].stringValue
                let name = row[incomeNameOfName].stringValue
                
                IncomeName.insertIncomeNameData(stringToDateBySelf(time, formate: "yyyy-MM-dd HH:mm:ss.ssss"), name: name)
            }
        }
    }
    
    //预计花费
    class func insertCostData(costDic: JSON){
        if costDic != nil{
            for i in 0 ..< costDic.count {
                let row = costDic[i]
                
                let time = row[costNameOfTime].stringValue
                let name = row[costNameOfName].stringValue
                let type = row[costNameOfType].stringValue
                let number = row[costNameOfNumber].stringValue
                let period = row[costNameOfPeriod].stringValue
                
                Cost.insertCostData(name, time: stringToDateBySelf(time, formate: "yyyy-MM-dd HH:mm:ss.ssss"),
                                    type: type, number: Float(number)!, period: Int(period)!)
            }
        }
    }
    
    //总计
    class func insertTotalData(totalDic: JSON){
        if totalDic != nil{
            for i in 0 ..< totalDic.count {
                let row = totalDic[i]
                
                let time = row[totalNameOfTime].stringValue
                let canUse = row[totalNameOfCanUse].stringValue
                
                Total.insertTotalData(Float(canUse)!, time: stringToDateBySelf(time, formate: "yyyy-MM-dd HH:mm:ss.ssss"))
            }
        }
    }
    
    //支出类型
    class func insertPayNameData(payNameDic: JSON){
        if payNameDic != nil{
            for i in 0 ..< payNameDic.count {
                let row = payNameDic[i]
                
                let time = row[payNameNameOfTime].stringValue
                let name = row[payNameNameOfName].stringValue
                
                PayName.insertPayNameData(name, time: stringToDateBySelf(time, formate: "yyyy-MM-dd HH:mm:ss.ssss"))
            }
        }
    }
    
    //信用账号
    class func insertCreditAccountData(creditAccountDic: JSON){
        if creditAccountDic != nil{
            for i in 0 ..< creditAccountDic.count {
                let row = creditAccountDic[i]
                
                let time = row[creditAccountNameOfTime].stringValue
                let name = row[creditAccountNameOfName].stringValue
                
                CreditAccount.insertAccountData(name, time: stringToDateBySelf(time, formate: "yyyy-MM-dd HH:mm:ss.ssss"))
            }
        }
    }
    
    //信用
    class func insertCreditData(creditDic: JSON){
        if creditDic != nil{
            for i in 0 ..< creditDic.count {
                let row = creditDic[i]
                
                let time = row[creditNameOfTime].stringValue
                let account = row[creditNameOfAccount].stringValue
                let date = row[creditNameOfDate].stringValue
                let type = row[creditNameOfType].stringValue
                let number = row[creditNameOfNumber].stringValue
                let periods = row[creditNameOfPeriods].stringValue
                let nextpayDay = row[creditNameOfNextPayDay].stringValue
                let leftPeriods = row[creditNameOfLeftPeriods].stringValue
                
                Credit.insertCrediData(Int(periods)!,
                                       number: Float(number)!,
                                       time: stringToDateBySelf(time, formate: "yyyy-MM-dd HH:mm:ss.ssss"),
                                       account: account,
                                       date: Int(date)!,
                                       nextPayDay: stringToDateBySelf(nextpayDay, formate: "yyyy-MM-dd HH:mm:ss.ssss"),
                                       leftPeriods: Int(leftPeriods)!,
                                       type: type
                )
            }
        }
    }
}
