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
    let number: String!
    let accout: String!
    let all: String!
    let time: String!  //下期还款时间
    let date: String!
    
    init(periods: String!, number: String!, accout: String!, all: String!, time: String!, date: String!){
        self.periods = periods
        self.number = number //
        self.all = all //
        self.accout = accout
        self.time = time
        self.date = date
    }
    
}
