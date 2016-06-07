//
//  GetDataToModel.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/6/3.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class DataToModel: NSObject {
    
    //user数据,从本地数据获得，因为启动应用就从服务器加载，没有的话就设置默认值
    class func getUserDataToModel() -> UserInfoModel{
        let data = User.selectAllData()
        var dataModel: UserInfoModel!
        
        if data.count == 0 {
            dataModel = UserInfoModel(account: "", nickname: "", name: nil, address: nil, location: nil, pw: "", sex: nil, time: getTime(), motto: nil, pic: nil, http: nil, picPath: nil)
        }else{
            let accout = data.lastObject?.valueForKey(userNameOfAccount) as! String
            let nickname = data.lastObject?.valueForKey(userNameOfNickname) as? String
            let name = data.lastObject?.valueForKey(userNameOfName) as? String
            let address = data.lastObject?.valueForKey(userNameOfAddress) as? String
            let location = data.lastObject?.valueForKey(userNameOfLocation) as? String
            let pw = data.lastObject?.valueForKey(userNameOfPW) as! String
            let sex = data.lastObject?.valueForKey(userNameOfSex) as? String
            let time = data.lastObject?.valueForKey(userNameOfTime) as! NSDate
            let motto = data.lastObject?.valueForKey(userNameOfMotto) as? String
            let pic = data.lastObject?.valueForKey(userNameOfPic) as? NSData
            let http = data.lastObject?.valueForKey(userNameOfHttp) as? String
            let picPath = data.lastObject?.valueForKey(userNameOfPicPath) as? String
            
            dataModel = UserInfoModel(account: accout, nickname: nickname, name: name, address: address, location: location, pw: pw, sex: sex, time: time, motto: motto, pic: pic, http: http, picPath: picPath)
        }
        return dataModel
    }
    
    //获得URL的model
    class func getURLModel() -> URLModel{
        let data = InternetSetting.selectAllData()
        
        var ip = "10.69.9.17"
        var port = "8181"
        var internet = false
        
        if data.count == 0 {
            InternetSetting.insertInternetSettingData(ip, port: port, internet: internet)
        }else{
            ip = data.lastObject?.valueForKey(internetSettingNameOfIP) as! String
            port = data.lastObject?.valueForKey(internetSettingNameOfPort) as! String
            internet = data.lastObject?.valueForKey(internetSettingNameOfInternet) as! Bool
        }
        
        return URLModel(ip: ip, port: port, internet: internet)
    }
}
