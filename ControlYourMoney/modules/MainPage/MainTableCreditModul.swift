//
//  MainTableCreditModul.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/11.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class MainTableCreditModul: NSObject {
    let periods: String!  //剩余还款期数
    let allPeriods: String! //总还款期数
    let number: String!  //每期还款
    let title: String!
    let all: String!  //还款总额
    let time: String!  //下期还款时间
    let date: String!
    let index: Int! //按时间排序之后的index
    
    let account : String!
    let type: String!
    
    init(periods: String!, number: String!, title: String!, all: String!, time: String!, date: String!, account: String!, type: String!, allPeriods: String!, index: Int!){
        self.periods = periods
        self.number = number //
        self.all = all //
        self.title = title
        self.time = time
        self.date = date
        self.account = account
        self.type = type
        self.allPeriods = allPeriods
        self.index = index
    }
    
}
