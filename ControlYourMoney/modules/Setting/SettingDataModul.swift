//
//  SettingDataModul.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/26.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class SettingDataModul: NSObject {
    var icon: String?  //前面的图片
    var name: String!  //图片后面的文案
    var nickname: String? //可能有的昵称
    var lable: String? //右边的文字
    var pic: String? //右边的图片
    var type: Int! //1个人信息栏，进入个人信息页， 2普通栏，3带开关的普通栏，4个人信息页的个人栏
    var cellHeigth: CGFloat! //高度
    
    init(icon: String?, name: String!, nickname: String?, lable: String?, pic: String?, type: Int!, cellHeigth: CGFloat!){
        self.icon = icon
        self.name = name
        self.nickname = nickname
        self.lable = lable
        self.pic = pic
        self.type = type
        self.cellHeigth = cellHeigth
    }
    
    //个人设置栏
    convenience init(icon: String?, name: String!, nickname: String!, pic: String?){
        let icon = icon
        let name = name
        let pic = pic
        let nickname = nickname
        
        self.init(icon: icon, name: name, nickname: nickname, lable: nil, pic: pic, type: 1, cellHeigth: 100)
    }
    
    //普通设置栏
    convenience init(icon: String?, name: String!, lable: String?, pic: String?){
        let icon = icon
        let name = name
        let lable = lable
        let pic = pic
        
        self.init(icon: icon, name: name, nickname: nil, lable: lable, pic: pic, type: 2, cellHeigth: 44)
    }
    
    //普通设置栏 带按钮的
    convenience init(icon: String?, name: String!){
        let icon = icon
        let name = name
        
        self.init(icon: icon, name: name, nickname: nil, lable: nil, pic: nil, type: 3, cellHeigth: 44)
    }
    
    //个人信息页的个人栏
    convenience init(name: String!, pic: String!){
        let pic = pic
        let name = name
        
        self.init(icon: nil, name: name, nickname: nil, lable: nil, pic: pic, type: 4, cellHeigth: 100)
    }
}
