//
//  MyTextToast.swift
//  MostWanted
//
//  Created by maocaiyuan on 16/3/5.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import Foundation

//等待效果
class MyWaitToast: UIView{
    
    var loadingLab:UILabel!
    var mask:UIControl!
    var timer:NSTimer!
    
    var title = "Waiting..." //显示的文案
    var viewAlpha : CGFloat = 1
    var timeOut : NSTimeInterval = 30
    var centerPosition = CGPoint(x: UIScreen.mainScreen().bounds.width/2, y: UIScreen.mainScreen().bounds.height/2)
    
    func showWait(view: UIView){
        
        self.alpha = viewAlpha //透明
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10 //边角
        self.layer.borderColor = UIColor.grayColor().CGColor //边框颜色
        self.backgroundColor = UIColor.clearColor()  //背景色
        
        let position : CGPoint = self.center
        self.frame = CGRectMake(position.x-50, position.y-50, 100, 100)
        
        let tmpView = UIView(frame: CGRectMake(0, 0, 100, 100))
        tmpView.backgroundColor = UIColor.blackColor()
        tmpView.alpha = 0.5
        tmpView.layer.masksToBounds = true;
        tmpView.layer.cornerRadius = 10;
        self.addSubview(tmpView)
        
        //转圈的动画
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.hidden = true
        activityIndicator.startAnimating()
        activityIndicator.center = CGPointMake(50, 50)
        self.addSubview(activityIndicator)
        
        //显示的文案
        loadingLab = UILabel(frame: CGRectMake(0, 70, 100, 20));
        loadingLab.backgroundColor = UIColor.clearColor();
        loadingLab.textAlignment = NSTextAlignment.Center
        loadingLab.textColor = UIColor.whiteColor()
        loadingLab.font = UIFont.systemFontOfSize(15)
        loadingLab.text = title
        self.addSubview(loadingLab)
        
        // 添加超时定时器
        timer = NSTimer(timeInterval: timeOut, target: self, selector: #selector(timerDeadLine), userInfo: nil, repeats: false)
        
         //显示toast的View
        if mask==nil {
            mask = UIControl(frame: UIScreen.mainScreen().bounds)
            mask.backgroundColor = UIColor.clearColor()
            mask.addSubview(self)
            UIApplication.sharedApplication().keyWindow?.addSubview(mask)
            self.center = CGPoint(x: centerPosition.x, y: centerPosition.y)
            mask.alpha = 1
        }
        mask.hidden = false
        // 添加定时器
        if timer != nil {
            NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        }
    }
    
    //请求超时时显示
    func timerDeadLine(){
        self.hideView()
        MyWaitToast.makeToast("请求超时")
    }
    
    //隐藏
    func hideView() {
        if NSThread.currentThread().isMainThread{
            self.removeView()
        }
        else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.removeView()
            })
        }
        hidenNetIndicator()
    }
    
    //移除view
    func removeView(){
        if mask != nil {
            mask.hidden = true
            timer.invalidate()
        }
    }
    
    //这个用法可以学习
    class func makeToast(strTitle:String) {
        NSThread.sleepForTimeInterval(0.4)
        let toast = MyToastView()
        if NSThread.currentThread().isMainThread{
            toast.showToast(strTitle)
        }
        else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                toast.showToast(strTitle)
            })
        }
    }
    
    //系统栏的转圈动画
    func showNetIndicator(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func hidenNetIndicator(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}