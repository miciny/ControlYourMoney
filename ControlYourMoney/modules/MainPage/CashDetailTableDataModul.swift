//
//  CashDetailTableDataModul.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/11.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class CashDetailTableDataModul: NSObject {
    let useWhere: String!
    let useNumber: String!
    let useTime: String!
    let type: String!
    
    init(useWhere: String!, useNumber: String!, useTime: String!, type: String!){
        self.useWhere = useWhere
        self.useNumber = useNumber //
        self.useTime = useTime //
        self.type = type
    }
}
