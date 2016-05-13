//
//  MainTableCashModul.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/11.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class MainTableCashModul: NSObject {
    let useWhere: String!
    let useNumber: String!
    let useTime: String!
    let useTotalDayStr: String!
    let useTotalStr: String!
    
    init(useWhere: String!, useNumber: String!, useTime: String!, useTotalDayStr: String!, useTotalStr: String!){
        self.useWhere = useWhere
        self.useNumber = useNumber //
        self.useTime = useTime //
        self.useTotalDayStr = useTotalDayStr
        self.useTotalStr = useTotalStr
    }
}
