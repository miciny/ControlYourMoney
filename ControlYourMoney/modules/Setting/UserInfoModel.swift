//
//  UserInfoModel.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/6/2.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class UserInfoModel: NSObject {
    var account: String!
    var name: String?
    var nickname: String?
    var address: String?
    var location: String?
    var pw: String!
    var sex: String?
    var time: NSDate!
    var motto: String?
    var pic: NSData?
    var http: String?
    var picPath: String?
    
    init(account: String!, nickname: String?, name: String?, address: String?, location: String?, pw: String!, sex: String?, time: NSDate!, motto: String?, pic: NSData?, http: String?, picPath: String?){
        self.account = account
        self.name = name
        self.nickname = nickname
        self.address = address
        self.location = location
        self.sex = sex
        self.pw = pw
        self.time = time
        self.motto = motto
        self.pic = pic
        self.picPath = picPath
        self.http = http
    }
}
