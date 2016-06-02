//
//  URLModel.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/6/2.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//
//=====================================================================================================
/**
 MARK: - 用于存储IP地址信息
 **/
//=====================================================================================================

import UIKit

class URLModel: NSObject {
    var ip: String!  //
    var port: String!  //
    var internet: Bool! // 是否开启了从网络下载
    
    init(ip: String!, port: String!, internet: Bool!){
        self.ip = ip
        self.port = port
        self.internet = internet
    }
}
