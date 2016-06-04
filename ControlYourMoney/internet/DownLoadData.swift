//
//  DownLoadData.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/6/4.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class DownLoadData: NSObject {    
    //从db获取user数据
    class func getUserInfoFromDB(manager: Manager){
        manager.request(.GET, NetWork.userUrl , parameters: NetWork.userGetParas)
            .responseJSON { response in
                let toast = MyToastView()
                
                switch response.result{
                    
                case .Success:
                    let code = String((response.response?.statusCode)!)
                    let a = code.substringToIndex(code.startIndex.advancedBy(1))
                    
                    if a == "2"{
                        let data = JSON(response.result.value!)
                        let json = data["data"][0]
                        
                        let dataModel = JsonToModel.getUserJsonDataToModel(json)
                        InsertData.initUserData(dataModel)
                        print("下载用户信息成功！")
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
