//
//  constant.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/11.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation
import UIKit


let Width = UIScreen.mainScreen().bounds.width
let Height = UIScreen.mainScreen().bounds.height

let rowHeight: CGFloat = 120
let mainViewTitle = "MyMoney"

let entityNameOfCash = "Cash"
let entityNameOfCredit = "Credit"
let entityNameOfSalary = "Salary"
let entityNameOfTotal = "Total"
let entityNameOfCreditAccount = "CreditAccount"

let keyOfCash = "记账"
let keyOfCredit = "信用卡（电子信用账号）"
let keyOfSalary = "工资"
let keyOfTotal = "总计"

let cashNameOfUseWhere = "useWhere"
let cashNameOfUseNumber = "useNumber"
let cashNameOfTime = "time"

let creditNameOfPeriods = "periods"
let creditNameOfNumber = "number"
let creditNameOfAccount = "account"
let creditNameOfDate = "date"
let creditNameOfTime = "time"

let salaryNameOfTime = "time"
let salaryNameOfNumber = "number"

let accountNameOfTime = "time"
let accountNameOfName = "name"

let TotalNameOfCanUse = "canUse"
let TotalNameOfTime = "time"
let addArray = ["信用帐号","信用卡（电子分期）","工资"]

let standardFontNo = CGFloat(15)
let standardFont = UIFont.systemFontOfSize(standardFontNo) //标准字体大小
let pageTitleFont = UIFont.boldSystemFontOfSize(standardFontNo+3) //页面title的字体大小

let totalFont = UIFont.systemFontOfSize(standardFontNo+9) //财产字体大小
let lastFont = UIFont.systemFontOfSize(standardFontNo+5) //可用字体大小
let introduceFont = UIFont.systemFontOfSize(standardFontNo+3) //输入框前面文字的字体大小

let detailTitleFont = UIFont.systemFontOfSize(standardFontNo+5) //tableView的cell的title
let detailFont = UIFont.systemFontOfSize(standardFontNo+1) //输入框前面文字的字体大小

let accountListTitleFont = UIFont.systemFontOfSize(standardFontNo-3)//字体大小

let myOwnAccount = "招商银行_"
let myOwnAccountPayDay = Int(21)
let myOwnAccountBillDay = Int(3)



