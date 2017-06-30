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
    var switchBtn: UISwitch? //如果有开关
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(data: SettingDataModul, reuseIdentifier cellId:String){
        self.settingItem = data
        super.init(style: UITableViewCellStyle.default, reuseIdentifier:cellId)
        rebuildCell()
    }
    
    //设置元素，1设置页个人栏，2普通栏，3带开关的普通栏，4个人信息页的个人栏
    func rebuildCell(){
        if(settingItem.type == 1){
            buildPersonInfo()
        }
        
        if(settingItem.type == 2){
            buildNormal()
        }
        
        if(settingItem.type == 3){
            buildNormalWithSwitch()
        }
        
        if settingItem.type == 4 {
            buildInfoPageFirst()
        }
    }
    
    //设置个人信息栏
    func buildPersonInfo(){
        //个人设置栏-头像
        let myIcon = UIImageView(frame: CGRect(x: 20, y: 20, width: 60, height: 60))
        myIcon.backgroundColor = UIColor.gray
        myIcon.layer.masksToBounds = true //不然设置边角没用
        myIcon.layer.cornerRadius = 5
        if let icon = settingItem.icon{
            myIcon.image = icon
        }
        self.addSubview(myIcon)
        
        //个人设置栏-名字
        if let nameStr = settingItem.name{
            let nameSize = sizeWithText(nameStr, font: settingPageNameFont, maxSize: CGSize(width: Width/2, height: myIcon.frame.height/2))
            let myName = UILabel(frame: CGRect(x: myIcon.frame.maxX+10, y: myIcon.frame.origin.y, width: nameSize.width, height: myIcon.frame.height/2))
            myName.backgroundColor = UIColor.clear
            myName.font = settingPageNameFont
            myName.textAlignment = .left
            myName.text = nameStr
            self.addSubview(myName)
        }
        
        //个人设置栏-昵称
        if let nicknameStr = settingItem.nickname {
            let nicknameSize = sizeWithText("昵称："+nicknameStr, font: settingPageLableFont, maxSize: CGSize(width: Width/2, height: myIcon.frame.height/2))
            let myNickname = UILabel(frame: CGRect(x: myIcon.frame.maxX+10, y: myIcon.frame.origin.y+myIcon.frame.height/2, width: nicknameSize.width, height: myIcon.frame.height/2))
            myNickname.backgroundColor = UIColor.white
            myNickname.font = settingPageLableFont
            myNickname.textAlignment = .left
            myNickname.text = "昵称："+nicknameStr
            self.addSubview(myNickname)
        }
        
        
        //个人设置栏-二维码图片
        if let pic = settingItem.pic{
            let my2DIcon = UIImageView(frame: CGRect(x: Width-60, y: myIcon.frame.height/2+10, width: 20, height: 20))
            my2DIcon.backgroundColor = UIColor.clear
            my2DIcon.image = pic
            my2DIcon.layer.cornerRadius = 1
            self.addSubview(my2DIcon)
        }
    }
    
    //设置普通栏
    func buildNormal(){
        let maxX = setNormalTitle()
        var minX = CGFloat(10)
        if let labelStr = settingItem.lable{
            let lableSize = sizeWithText(labelStr, font: settingPageLableFont, maxSize: CGSize(width: Width-maxX-50, height: self.frame.height))
            let myLabel = UILabel(frame: CGRect(x: Width-lableSize.width-40, y: 0, width: lableSize.width, height: self.frame.height))
            myLabel.backgroundColor = UIColor.clear  //没有背景色，不然重新调整位置后会显示多余的竖线
            myLabel.font = settingPageLableFont
            myLabel.textAlignment = .right
            myLabel.textColor = UIColor.gray
            myLabel.text = labelStr
            self.addSubview(myLabel)
            
            minX = myLabel.frame.minX
        }
        
        if let tdicon = settingItem.pic{
            //个人信息页-二维码
            let myIcon = UIImageView(frame: CGRect(x: Width-minX-50, y: self.frame.height/2-10, width: 20, height: 20))
            myIcon.backgroundColor = UIColor.clear
            myIcon.image = tdicon
            myIcon.layer.cornerRadius = 5
            self.addSubview(myIcon)
        }
    }
    
    //设置普通栏带开关
    func buildNormalWithSwitch(){
        setNormalTitle()
        
        switchBtn = UISwitch(frame: CGRect(x: Width-70, y: 7, width: 51, height: 31))
        switchBtn!.backgroundColor = UIColor.clear
        switchBtn!.tintColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        switchBtn!.onTintColor = UIColor.green
        
        //不能设置frame，只能缩放 iOS7的UISwitch是51x31
        switchBtn!.transform = CGAffineTransform(scaleX: 1, y: 1)
        self.addSubview(switchBtn!)
    }
    
    //个人信息页，个人栏
    func buildInfoPageFirst(){
        setNormalTitle()
        
        //个人信息页-图像
        let myIcon = UIImageView(frame: CGRect(x: Width-100, y: 20, width: 60, height: 60))
        myIcon.backgroundColor = UIColor.gray
        myIcon.layer.masksToBounds = true  //不然设置边角没用
        myIcon.layer.cornerRadius = 5
        myIcon.image = settingItem.pic!
        self.addSubview(myIcon)
    }
    
    //设置前面公用的
    func setNormalTitle() -> CGFloat{
        //普通设置栏-头像
        
        let lableSize = sizeWithText(settingItem.name, font: settingPageNameFont, maxSize: CGSize(width: Width/2, height: 30))
        var titleFrame = CGRect(x: 20, y: settingItem.cellHeigth/2-15, width: lableSize.width, height: 30)
        
        if let icon =  settingItem.icon{
            let myIcon = UIImageView(frame: CGRect(x: 20, y: (settingItem.cellHeigth-25)/2, width: 25, height: 25))
            myIcon.backgroundColor = UIColor.clear
            myIcon.image = icon
            myIcon.layer.cornerRadius = 0
            self.addSubview(myIcon)
            
            titleFrame.origin.x = myIcon.frame.maxX+10
        }
        
        //普通设置栏-title
        let title = UILabel(frame: titleFrame)
        title.backgroundColor = UIColor.clear
        title.font = settingPageNameFont
        title.textAlignment = .left
        title.text = settingItem.name
        self.addSubview(title)
        
        return title.frame.maxX
    }
}
