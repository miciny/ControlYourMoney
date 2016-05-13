//
//  AccountListModul.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/12.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class AccountListModul: NSObject {
    var name : String!
    var type: Int! //0代表title 2 代表底下晴空按钮
    
    init(name: String!, type: Int!) {
        self.name = name
        self.type = type
    }
}
