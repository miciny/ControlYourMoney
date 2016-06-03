//
//  DeleteCoreData.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/6/3.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class DeleteCoreData: NSObject {
    //删除所有money
    class func deleteAllMoneyData(){
        var array = Cash.selectAllData()
        if array.count > 0 {
            for _ in 0 ..< array.count{
                Cash.deleteData(0)
            }
        }
        
        array = PayName.selectAllData()
        if array.count > 0 {
            for _ in 0 ..< array.count{
                PayName.deleteData(0)
            }
        }
        
        array = Credit.selectAllData()
        if array.count > 0 {
            for _ in 0 ..< array.count{
                Credit.deleteData(0)
            }
        }
        
        array = CreditAccount.selectAllData()
        if array.count > 0 {
            for _ in 0 ..< array.count{
                CreditAccount.deleteData(0)
            }
        }
        
        array = Salary.selectAllData()
        if array.count > 0 {
            for _ in 0 ..< array.count{
                Salary.deleteData(0)
            }
        }
        
        array = IncomeName.selectAllData()
        if array.count > 0 {
            for _ in 0 ..< array.count{
                IncomeName.deleteData(0)
            }
        }
        
        array = Total.selectAllData()
        if array.count > 0 {
            for _ in 0 ..< array.count{
                Total.deleteData(0)
            }
        }
        
        array = Cost.selectAllData()
        if array.count > 0 {
            for _ in 0 ..< array.count{
                Cost.deleteData(0)
            }
        }
    }
}
