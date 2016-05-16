//
//  MyMenuView.swift
//  MostWanted
//
//  Created by maocaiyuan on 16/3/5.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

// 显示底部菜单
class MyBottomMenuView: UIView{
    
    var delegate : bottomMenuViewDelegate?
    
    var eventFlag = Int() //一个界面多次调用时，进行的判断，可以传入按钮的tag等
    
    var objectHeight : CGFloat = 60 //每个菜单的高度高度
    var titleHeight : CGFloat = 60
    var cancelHeight : CGFloat = 60
    
    var titleFont : CGFloat = 20
    var titleColor = UIColor.grayColor()
    
    var cancelFont : CGFloat = 20
    var cancelColor = UIColor.blackColor()
    
    var objectFont : CGFloat = 20
    var objectColor = UIColor.blackColor()
    
    var mainView : UIControl!
    let buttonView = UIView()
    
    let Height = UIScreen.mainScreen().bounds.height
    let Width = UIScreen.mainScreen().bounds.width
    
    var centerPosition = CGPoint()
    
    final let gap : CGFloat = 7  // 取消与上面按钮的间隔
    
    func showBottomMenu(title: String, cancel: String, object: NSArray,eventFlag: Int , target: bottomMenuViewDelegate){
        centerPosition = CGPoint(x: Width/2, y: Height/2)
        var totalHeight : CGFloat = 0 //总高度
        let osHeight = CGFloat(object.count) * objectHeight
        
        self.frame = CGRectMake(0, 0, Width, Height)
        self.backgroundColor = UIColor.clearColor()  //背景色
        self.opaque = true
        self.alpha = 1
        self.eventFlag = eventFlag
        self.delegate = target
        
        if(title == "" && cancel == ""){
            titleHeight = 0
            cancelHeight = 0
            totalHeight = osHeight + gap
        }else if(title == "" && cancel != ""){
            titleHeight = 0
            totalHeight = osHeight + gap + cancelHeight
        }else if(title != "" && cancel == ""){
            cancelHeight = 0
            totalHeight = osHeight + titleHeight + gap
        }else{
            totalHeight = osHeight + titleHeight + gap + cancelHeight //总高度
        }
        
        buttonView.frame = CGRect(x: 0, y: Height-totalHeight , width: Width, height: totalHeight)
        buttonView.backgroundColor = UIColor.whiteColor()
        buttonView.alpha = 1
        
        if(title != ""){
            let titleLb = UILabel(frame: CGRect(x: 0, y: 0, width: Width, height: titleHeight))
            titleLb.backgroundColor = UIColor.whiteColor()
            titleLb.text = title
            titleLb.textAlignment = .Center
            titleLb.font = UIFont.systemFontOfSize(titleFont)
            titleLb.textColor = titleColor
            buttonView.addSubview(titleLb)
        }
        
        if(cancel != ""){
            let cancelLine = UIView(frame: CGRect(x: 0, y: totalHeight-cancelHeight-gap, width: Width, height: gap))
            cancelLine.backgroundColor = UIColor.grayColor()
            cancelLine.alpha = 0.6
            buttonView.addSubview(cancelLine)
            
            let cancelBtn = UIButton(frame: CGRect(x: 0, y: totalHeight-cancelHeight, width: Width, height: cancelHeight))
            cancelBtn.backgroundColor = UIColor.whiteColor()
            cancelBtn.setTitle(cancel, forState: .Normal)
            cancelBtn.titleLabel?.font = UIFont.systemFontOfSize(cancelFont)
            cancelBtn.setTitleColor(cancelColor, forState: .Normal)
            cancelBtn.addTarget(self, action: #selector(MyBottomMenuView.hideView), forControlEvents: .TouchUpInside)
            buttonView.addSubview(cancelBtn)
        }
        
        if(object.count > 0){
            let lineW : CGFloat = 0.5
            for i in 0 ..< object.count{
                
                let cancelLine = UIView(frame: CGRect(x: 0, y: titleHeight + CGFloat(i) * objectHeight, width: Width, height: lineW))
                cancelLine.backgroundColor = UIColor.blackColor()
                cancelLine.alpha = 0.6
                buttonView.addSubview(cancelLine)
                
                let objectBtn = UIButton(frame: CGRect(x: 0, y: titleHeight + CGFloat(i) * objectHeight + lineW, width: Width, height: objectHeight-lineW))
                objectBtn.backgroundColor = UIColor.whiteColor()
                objectBtn.setTitle(object[i] as? String, forState: .Normal)
                objectBtn.titleLabel?.font = UIFont.systemFontOfSize(objectFont)
                objectBtn.setTitleColor(objectColor, forState: .Normal)
                objectBtn.addTarget(self, action: #selector(MyBottomMenuView.buttonClicked(_:)), forControlEvents: .TouchUpInside)
                objectBtn.tag = i //标示
                buttonView.addSubview(objectBtn)
            }
        }
        //在整个页面的空余地方添加一个button，点击移除view
        let removeBtn = UIButton(frame: CGRect(x: 0, y: 0, width: Width, height: Height))
        removeBtn.backgroundColor = UIColor.blackColor()
        removeBtn.alpha = 0.5
        removeBtn.addTarget(self, action: #selector(MyBottomMenuView.hideView), forControlEvents: .TouchUpInside)
        self.addSubview(removeBtn)
        
        //为什么用uicontroller加，我也不知道
        if mainView == nil {
            mainView = UIControl(frame: UIScreen.mainScreen().bounds)
            mainView.backgroundColor = UIColor.clearColor()
            mainView.addSubview(self)
            self.center = CGPoint(x: centerPosition.x, y: centerPosition.y)
            mainView.alpha = 1
            
            
            UIApplication.sharedApplication().keyWindow?.addSubview(self.mainView)
            
            //动画
            let animation = CATransition()
            animation.type = kCATransitionPush
            animation.subtype = kCATransitionFromTop
            animation.duration = 0.2
            
            self.addSubview(buttonView)
            self.buttonView.layer.addAnimation(animation, forKey: "")
        }
    }
    
    func hideView(){
        UIView.animateWithDuration(0.2, animations: {
            () -> ()in
            self.mainView.alpha = 0
            }, completion: {
                (Boolean) -> ()in
                self.mainView.removeFromSuperview()
        })
        
    }
    
    func buttonClicked(sender : UIButton){
        hideView()
        let oBtn = sender as UIButton
        self.delegate?.buttonClicked(oBtn.tag, eventFlag: self.eventFlag)
    }
    
}