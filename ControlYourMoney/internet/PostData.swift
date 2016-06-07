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
                        User.updateuserData(0, changeValue: false, changeFieldName: userNameOfChanged)
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
    
    //post user icon
    //
    class func postUserIconToDB(imagePath: String, manager: Manager){
        let data = DataToModel.getUserDataToModel()
        let iconURL = NSURL(fileURLWithPath: imagePath)
        let url = NetWork.userIconUrl
        
        //上传图片
        manager.upload(.POST, url, multipartFormData: { (multipartFormData) in
            multipartFormData.appendBodyPart(fileURL: iconURL, name: "\(data.account)")
        }) { encodingResult in
            switch encodingResult {
            case .Success(let upload, _, _ ):
                upload.responseJSON {
                    response in
                    //成功
                    let toast = MyToastView()
                    
                    switch response.result{
                    case .Success:
                        let code = String((response.response?.statusCode)!)
                        let a = code.substringToIndex(code.startIndex.advancedBy(1))
                        
                        if a == "2"{
                            print("上传用户头像成功！")
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
                
            case .Failure(let encodingError):
                print("Failure")
                print(encodingError)
            }
        }
    }
}
