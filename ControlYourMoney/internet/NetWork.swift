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
            let data = DataToModel.getUserDataToModel()
            return ["account": "\(data.account)", "token": "111", "time": "111"]
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
            let data = DataToModel.getUserDataToModel()
            return ["account": "\(data.account)", "token": "111", "time": "111"]
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
    
    //失败的显示
    class func networkFailed(response: NSHTTPURLResponse?){
        if response == nil {
            MyToastView().showToast("无法连接服务器")
            return
        }
        let code = String((response?.statusCode)!)
        let str = getErrorCodeToString(code)
        MyToastView().showToast("\(str)")
    }
    
    //系统栏的转圈动画
    class func showNetIndicator(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    class func hidenNetIndicator(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }

}
