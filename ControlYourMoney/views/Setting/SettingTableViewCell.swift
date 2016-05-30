//
//  SettingTableViewCell.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/26.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    var settingItem: SettingDataModul! //设置的数据模型，type为1 表示 个人信息栏  2表示普通栏
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(data: SettingDataModul, reuseIdentifier cellId:String){
        self.settingItem = data
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier:cellId)
        rebuildCell()
    }
    
    //设置元素
    func rebuildCell(){
        if(settingItem.type == 1){
            buildPersonInfo()
        }
        
        if(settingItem.type == 2){
            buildNormal()
        }
    }
    
    //设置个人信息栏
    func buildPersonInfo(){
        //个人设置栏-头像
        let myIcon = UIImageView(frame: CGRect(x: 20, y: 20, width: 60, height: 60))
        myIcon.backgroundColor = UIColor.grayColor()
        myIcon.layer.masksToBounds = true //不然设置边角没用
        myIcon.layer.cornerRadius = 5
        if let icon = settingItem.icon{
            myIcon.image = UIImage(named: icon)
        }
        self.addSubview(myIcon)
        
        //个人设置栏-名字
        let nameSize = sizeWithText(settingItem.name, font: settingPageNameFont, maxSize: CGSize(width: Width/2, height: myIcon.frame.height/2))
        let myName = UILabel(frame: CGRect(x: myIcon.frame.maxX+10, y: myIcon.frame.origin.y, width: nameSize.width, height: myIcon.frame.height/2))
        myName.backgroundColor = UIColor.whiteColor()
        myName.font = settingPageNameFont
        myName.textAlignment = .Left
        myName.text = settingItem.name
        self.addSubview(myName)
        
        //个人设置栏-昵称
        let nicknameSize = sizeWithText("昵称："+settingItem.nickname!, font: settingPageLableFont, maxSize: CGSize(width: Width/2, height: myIcon.frame.height/2))
        let myNickname = UILabel(frame: CGRect(x: myIcon.frame.maxX+10, y: myIcon.frame.origin.y+myIcon.frame.height/2, width: nicknameSize.width, height: myIcon.frame.height/2))
        myNickname.backgroundColor = UIColor.whiteColor()
        myNickname.font = settingPageLableFont
        myNickname.textAlignment = .Left
        myNickname.text = "昵称："+settingItem.nickname!
        self.addSubview(myNickname)
        
        //个人设置栏-二维码图片
        if let pic = settingItem.pic{
            let my2DIcon = UIImageView(frame: CGRect(x: Width-60, y: myIcon.frame.height/2+10, width: 20, height: 20))
            my2DIcon.backgroundColor = UIColor.clearColor()
            my2DIcon.image = UIImage(named: pic)
            my2DIcon.layer.cornerRadius = 1
            self.addSubview(my2DIcon)
        }
    }
    
    //设置普通栏
    func buildNormal(){
        //普通设置栏-头像
        let myIcon = UIImageView(frame: CGRect(x: 20, y: 7, width: 30, height: 30))
        myIcon.backgroundColor = UIColor.clearColor()
        if let icon =  settingItem.icon{
            myIcon.image = UIImage(named: icon)
        }
        myIcon.layer.cornerRadius = 0
        self.addSubview(myIcon)
        
        //普通设置栏-title
        let lableSize = sizeWithText(settingItem.name, font: settingPageNameFont, maxSize: CGSize(width: Width/2, height: myIcon.frame.height))
        let title = UILabel(frame: CGRect(x: myIcon.frame.maxX+10, y: myIcon.frame.origin.y, width: lableSize.width, height: myIcon.frame.height))
        title.backgroundColor = UIColor.whiteColor()
        title.font = settingPageNameFont
        title.textAlignment = .Left
        title.text = settingItem.name
        self.addSubview(title)
    }
}
