//
//  CreditDetailTableDataModul.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/11.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class SalaryDetailTableDataModul: NSObject {
    let time: String!
    let number: String!
    let date: String!
    let type: String!
    
    init(time: String!, number: String!, date: String!, type: String!){
        self.time = time
        self.number = number //
        self.date = date //
        self.type = type
    }
}
