//
//  PostData.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/6/4.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import Alamofire

class PostData: NSObject {
    //post用户信息数据到db
    class func postUserInfoToDB(str: String, manager: Manager){
        
        let paras = [
            "data": strToJson(str)
        ]
        manager.request(.POST, NetWork.userUrl, parameters: paras, encoding: .JSON)
            .responseJSON { response in
                let toast = MyToastView()
                
                switch response.result{
                    
                case .Success:
                    let code = String((response.response?.statusCode)!)
                    let a = code.substringToIndex(code.startIndex.advancedBy(1))
                    
                    if a == "2"{
                        print("上传用户信息成功！")
                    }else{
                        let str = getErrorCodeToString(a)
                        toast.showToast("\(str)")
                    }
                    
                case .Failure:
                    if response.response == nil{
                        toast.showToast("无法连接服务器！")
                    }else{
                        toast.showToast("上传数据失败！")
                    }
                }
        }
    }
}
