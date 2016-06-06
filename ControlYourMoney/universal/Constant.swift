//
//  constant.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/11.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation
import UIKit

let mainQueue = dispatch_get_main_queue() //主线程
let Width = UIScreen.mainScreen().bounds.width
let Height = UIScreen.mainScreen().bounds.height

let rowHeight: CGFloat = 120
let mainViewTitle = "MyMoney"

let entityNameOfInternetSetting = "InternetSetting"
let entityNameOfCash = "Cash"
let entityNameOfCredit = "Credit"
let entityNameOfIncome = "Income"
let entityNameOfIncomeName = "IncomeName"
let entityNameOfTotal = "Total"
let entityNameOfCreditAccount = "CreditAccount"
let entityNameOfCost = "Cost"
let entityNameOfPayName = "PayName"
let entityNameOfUser = "User" //个人信息表

let cashNameOfUseWhere = "useWhere"
let cashNameOfUseNumber = "useNumber"
let cashNameOfTime = "time"
let cashNameOfType = "type"

let creditNameOfPeriods = "periods"
let creditNameOfNumber = "number"
let creditNameOfAccount = "account"
let creditNameOfDate = "date"
let creditNameOfTime = "time"
let creditNameOfNextPayDay = "nextPayDay"
let creditNameOfLeftPeriods = "leftPeriods"
let creditNameOfType = "type"

let payNameNameOfName = "name"
let payNameNameOfTime = "time"

let creditAccountNameOfTime = "time"
let creditAccountNameOfName = "name"

let totalNameOfCanUse = "canUse"
let totalNameOfTime = "time"

let incomeOfName = "name"
let incomeOfNumber = "number"
let incomeOfTime = "time"

let incomeNameOfName = "name"
let incomeNameOfTime = "time"

let costNameOfName = "name"
let costNameOfNumber = "number"
let costNameOfTime = "time"
let costNameOfType = "type"
let costNameOfPeriod = "period" //0代表每月，1代表一年

let userNameOfAccount = "account"
let userNameOfName = "name"
let userNameOfNickname = "nickname"
let userNameOfPW = "pw"
let userNameOfSex = "sex"
let userNameOfPic = "pic"
let userNameOfChanged = "changed"
let userNameOfAddress = "address"
let userNameOfMotto = "motto"
let userNameOfHttp = "http"
let userNameOfTime = "create_time"
let userNameOfLocation = "location"
let userNameOfPicPath = "picPath"

let internetSettingNameOfIP = "ip"
let internetSettingNameOfPort = "port"
let internetSettingNameOfInternet = "internet"

let addArray = ["信用卡（电子分期）","收入"]

let keyOfIncome = "收入详情"
let keyOfCash = "现金记账"
let keyOfCredit = "信用还款"

let standardFontNo = CGFloat(15)
let standardFont = UIFont.systemFontOfSize(standardFontNo) //标准字体大小
let pageTitleFont = UIFont.boldSystemFontOfSize(standardFontNo+3) //页面title的字体大小

let totalFont = UIFont.systemFontOfSize(standardFontNo+9) //财产字体大小
let lastFont = UIFont.systemFontOfSize(standardFontNo+5) //可用字体大小
let introduceFont = UIFont.systemFontOfSize(standardFontNo+3) //输入框前面文字的字体大小

let detailTitleFont = UIFont.systemFontOfSize(standardFontNo+5) //tableView的cell的title
let detailFont = UIFont.systemFontOfSize(standardFontNo+1) //文字的字体大小
let useNumberFont = UIFont.systemFontOfSize(standardFontNo+35) //文字的字体大小

let accountListTitleFont = UIFont.systemFontOfSize(standardFontNo-3)//字体大小

let explainFont = UIFont.systemFontOfSize(standardFontNo)//字体大小

let analyseTitleFont = UIFont.boldSystemFontOfSize(standardFontNo+2)//字体大小
let analyseDataFont = UIFont.systemFontOfSize(standardFontNo)//字体大小

let settingPageNameFont = UIFont.systemFontOfSize(standardFontNo+2) //设置页字体大小
let settingPageLableFont = UIFont.systemFontOfSize(standardFontNo) //设置页lable字体大小

let periodsFont = UIFont.systemFontOfSize(standardFontNo+2) //周期字体

let myOwnAccount = "招商银行_"
let myOwnAccountPayDay = Int(21)
let myOwnAccountBillDay = Int(3)



