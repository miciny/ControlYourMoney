//
//  NetWork.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/6/3.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NetWork: NSObject {
    
    //user的URl
    class var loginUrl: String{
        get{
            return NetWork.getBaseUrl() + "/api/login"
        }
    }
    
    //user的URl
    class var userUrl: String{
        get{
            return NetWork.getBaseUrl() + "/api/user"
        }
    }
    
    //user icon的URl
    class var userIconUrl: String{
        get{
            return NetWork.getBaseUrl() + "/api/user/icon"
        }
    }
    
    //user的get请求的参数
    class var userGetParas: [String: String]{
        get{
            return ["account": "15201114041", "token": "111", "time": "111"]
        }
    }
    
    //money的URl
    class var moneyUrl: String{
        get{
            return NetWork.getBaseUrl() + "/api/sync"
        }
    }
    
    //user的get请求的参数
    class var moneyGetParas: [String: String]{
        get{
            return ["name": "111", "token": "111", "time": "111"]
        }
    }
    
    //获得url
    class func getBaseUrl() -> String{
        let model = DataToModel.getURLModel()
        let url = "http://\(String(model.ip)):\(String(model.port))"
        return url
        
    }
    
    //获得manage
    class func getDefaultAlamofireManager() -> Manager{
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 7 //超时时间
        let netManager = Alamofire.Manager(configuration: configuration)
        return netManager
    }

}
