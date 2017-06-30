//
//  JsonToModel.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/6/3.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import SwiftyJSON

class JsonToModel: NSObject {
    
    //json数据改为UserInfoModel
    class func getUserJsonDataToModel(_ json: JSON) -> UserInfoModel{
        let accout = json[userNameOfAccount].stringValue
        let nickname = json[userNameOfNickname].stringValue
        let name = json[userNameOfName].stringValue
        let address = json[userNameOfAddress].stringValue
        let location = json[userNameOfLocation].stringValue
        let pw = json[userNameOfPW].stringValue
        let sex = json[userNameOfSex].stringValue
        let timeData = stringToDateBySelf(json[userNameOfTime].stringValue, formate: "yyyy-MM-dd HH:mm:ss.ssss")
        let motto = json[userNameOfMotto].stringValue
        let picPath = json[userNameOfPic].stringValue
        let http = json[userNameOfHttp].stringValue
        
        let dataModel = UserInfoModel(account: accout, nickname: nickname, name: name, address: address, location: location, pw: pw, sex: sex, time: timeData, motto: motto, pic: nil, http: http, picPath: picPath)
        return dataModel
    }
    
}
