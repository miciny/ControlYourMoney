//
//  ArrayToJsonStr.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/6/3.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class ArrayToJsonStr: NSObject {
    //用户信息的
    class func getUserDataArrayToJsonStr() -> String{
        let allDic = NSMutableDictionary()
        allDic.setValue(DataToArray.setUserDataToArray(), forKey: entityNameOfUser)
        let jsonStr = dicToJson(allDic)
        return jsonStr
    }
    
    //money的
    class func getMoneyDataArrayToJsonStr() -> String{
        let allDic = NSMutableDictionary()
        allDic.setValue(DataToArray.setCashDataToArray(), forKey: entityNameOfCash)
        allDic.setValue(DataToArray.setCostDataToArray(), forKey: entityNameOfCost)
        allDic.setValue(DataToArray.setCreditAccountDataToArray(), forKey: entityNameOfCreditAccount)
        allDic.setValue(DataToArray.setCreditDataToArray(), forKey: entityNameOfCredit)
        allDic.setValue(DataToArray.setIncomeDataToArray(), forKey: entityNameOfIncome)
        allDic.setValue(DataToArray.setIncomeNameDataToArray(), forKey: entityNameOfIncomeName)
        allDic.setValue(DataToArray.setPayNameDataToArray(), forKey: entityNameOfPayName)
        allDic.setValue(DataToArray.setTotalDataToArray(), forKey: entityNameOfTotal)
        
        let jsonStr = dicToJson(allDic)
        return jsonStr
    }
    
}
