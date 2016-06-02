//
//  InitData.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/6/2.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import Alamofire

class InitData: NSObject {
    
    //根据现在时间，计算每个信用卡的还款情况
    class func calculateCredit(){
        var creditArray = Credit.selectAllData()
        //排序
        let time = NSSortDescriptor.init(key: creditNameOfTime, ascending: true)
        creditArray = creditArray.sortedArrayUsingDescriptors([time])
        
        guard creditArray.count > 0 else{
            return
        }
        
        let timeNow = getTime()
        for i in 0 ..< creditArray.count {
            let nextPayDay = creditArray.objectAtIndex(i).valueForKey(creditNameOfNextPayDay) as! NSDate  // 下期还款日期
            let leftPeriods = creditArray.objectAtIndex(i).valueForKey(creditNameOfLeftPeriods) as! Int  // 剩余还款期数
            
            //剩余还款大于0的才计算
            if leftPeriods > 0 {
                let months = CalculateCredit.getMonthOffset(timeNow, time2: nextPayDay)  //获取月份差
                let number = creditArray.objectAtIndex(i).valueForKey(creditNameOfNumber) as! Float  //
                if months < leftPeriods && months > 0{
                    
                    let nextPay = CalculateCredit.calculateTime(nextPayDay, months: months)
                    Credit.updateCreditDataSortedByTime(i, changeValue: leftPeriods-months, changeFieldName: creditNameOfLeftPeriods)
                    Credit.updateCreditDataSortedByTime(i, changeValue: nextPay, changeFieldName: creditNameOfNextPayDay)
                    CalculateCredit.changeTotal(Float(months)*number)
                    
                }else if(months >= leftPeriods && months > 0){
                    let nextPay = CalculateCredit.calculateTime(nextPayDay, months: leftPeriods-1) //－1是为了，下期还款是是真实的最后还款日
                    Credit.updateCreditDataSortedByTime(i, changeValue: 0, changeFieldName: creditNameOfLeftPeriods)
                    Credit.updateCreditDataSortedByTime(i, changeValue: nextPay, changeFieldName: creditNameOfNextPayDay)
                    CalculateCredit.changeTotal(Float(leftPeriods)*number)
                }
            }
        }
    }
    
    //获得URL的model
    class func getURLModel() -> URLModel{
        let data = InternetSetting.selectAllData()
        
        var ip = ""
        var port = ""
        var internet = false
        
        if data.count == 0 {
            InternetSetting.insertInternetSettingData("10.69.9.17", port: "8181", internet: false)
            ip = "10.69.9.17"
            port = "8181"
            internet = false
        }else{
            ip = data.lastObject?.valueForKey(internetSettingNameOfIP) as! String
            port = data.lastObject?.valueForKey(internetSettingNameOfPort) as! String
            internet = data.lastObject?.valueForKey(internetSettingNameOfInternet) as! Bool
        }
        
        return URLModel(ip: ip, port: port, internet: internet)
    }
    
    //获得url
    class func getBaseUrl() -> String{
        let model = getURLModel()
        let url = "http://\(String(model.ip)):\(String(model.port))"
        return url
    
    }
    
    //获得manage
    class func getDefaultAlamofireManage() -> Manager{
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 15 //超时时间
        let netManager = Alamofire.Manager(configuration: configuration)
        return netManager
    }
    
    //初始化user数据
    class func initUserData(data: UserInfoModel){
        let dataTemp = User.selectAllData()
        if dataTemp.count == 0 {
            User.insertUserData(data.account, name: data.name, nickname: data.nickname, address: data.address, location: data.location, pw: data.pw, sex: data.sex, time: data.time, motto: data.motto, pic: data.pic, http: data.http)
        }else{
            User.updateUserData(0, account: data.account, name: data.name, nickname: data.nickname, address: data.address, location: data.location, pw: data.pw, sex: data.sex, time: data.time, motto: data.motto, pic: data.pic, http: data.http)
        }
    }
    
    //user数据,从本地数据获得，因为启动应用就从服务器加载，没有的话就设置默认值
    class func getUserDataToModel() -> UserInfoModel{
        let data = User.selectAllData()
        var dataModel: UserInfoModel!
        
        if data.count == 0 {
            dataModel = UserInfoModel(account: "15201114041", nickname: "Xue", name: "毛彩元", address: nil, location: nil, pw: "zhangxue", sex: nil, time: getTime(), motto: nil, pic: nil, http: nil)
        }else{
            let accout = data.lastObject?.valueForKey(userNameOfAccount) as! String
            let nickname = data.lastObject?.valueForKey(userNameOfNickname) as! String
            let name = data.lastObject?.valueForKey(userNameOfName) as! String
            let address = data.lastObject?.valueForKey(userNameOfAddress) as? String
            let location = data.lastObject?.valueForKey(userNameOfLocation) as? String
            let pw = data.lastObject?.valueForKey(userNameOfPW) as! String
            let sex = data.lastObject?.valueForKey(userNameOfSex) as? String
            let time = data.lastObject?.valueForKey(userNameOfTime) as! NSDate
            let motto = data.lastObject?.valueForKey(userNameOfMotto) as? String
            let pic = data.lastObject?.valueForKey(userNameOfPic) as? NSData
            let http = data.lastObject?.valueForKey(userNameOfHttp) as? String
            
            dataModel = UserInfoModel(account: accout, nickname: nickname, name: name, address: address, location: location, pw: pw, sex: sex, time: time, motto: motto, pic: pic, http: http)
        }
        
        return dataModel
    }
}
