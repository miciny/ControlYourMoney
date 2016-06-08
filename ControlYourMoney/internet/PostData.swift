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
                
                switch response.result{
                case .Success:
                    let code = String((response.response?.statusCode)!)
                    
                    if code == "200"{
                        User.updateuserData(0, changeValue: false, changeFieldName: userNameOfChanged)
                        print("上传用户信息成功！")
                    }else{
                        let str = getErrorCodeToString(code)
                        MyToastView().showToast("\(str)")
                    }
                    
                case .Failure:
                    let code = String((response.response?.statusCode)!)
                    let str = getErrorCodeToString(code)
                    MyToastView().showToast("\(str)")
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
                    switch response.result{
                    case .Success:
                        let code = String((response.response?.statusCode)!)
                        
                        if code == "200"{
                            print("上传用户头像成功！")
                        }else{
                            let str = getErrorCodeToString(code)
                            MyToastView().showToast("\(str)")
                        }
                        
                    case .Failure:
                        let code = String((response.response?.statusCode)!)
                        let str = getErrorCodeToString(code)
                        MyToastView().showToast("\(str)")
                    }
                }
                
            case .Failure(let encodingError):
                print("Failure")
                print(encodingError)
            }
        }
    }
}
