//
//  File.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/11.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation


protocol bottomMenuViewDelegate{
    func buttonClicked(tag: Int, eventFlag: Int)
}


protocol mainHeaderChangeLastDelegate{
    func buttonClicked(lastStr: String)
}

protocol accountListViewDelegate {
    func buttonClicked(name: String)
}