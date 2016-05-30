//
//  File.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/11.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation

//action的代理
protocol bottomMenuViewDelegate{
    func buttonClicked(tag: Int, eventFlag: Int)
}

//主页点击改变余额的代理
protocol mainHeaderChangeLastDelegate{
    func buttonClicked(lastStr: String)
}

//账号选择的代理
protocol accountListViewDelegate {
    func buttonClicked(name: String)
}

//支出类型的选择的代理
protocol costNameListViewDelegate {
    func costNameClicked(name: String)
}

//下拉刷新的代理
protocol isRefreshingDelegate{
    func reFreshing()
}