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
class MyTextToast: UIView {
    
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
        let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
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
        timer = NSTimer(timeInterval: timeOut, target: self, selector: "timerDeadLine", userInfo: nil, repeats: false)
        
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
        MyTextToast.showNetIndicator()
    }
    
    //请求超时时显示
    func timerDeadLine(){
        self.hideView()
        MyTextToast.makeToast("请求超时")
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
        MyTextToast.hidenNetIndicator()
    }
    
    func removeView(){
        if mask != nil {
            mask.hidden = true
            timer.invalidate()
        }
    }
    
    //这个用法可以学习
    class func makeToast(strTitle:String) {
        NSThread.sleepForTimeInterval(0.4)
        let toast = showToast()
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
    class func showNetIndicator(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    class func hidenNetIndicator(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}

// 显示toast提示
class showToast:NSObject {
    
    var frameMarginSize: CGFloat! = 20 //与周围的边距
    var frameSize:CGSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width-40, 60) //大小
    var view:UIView!
    var textFont:CGFloat = 15 //字体
    var position : CGPoint = CGPoint(x: UIScreen.mainScreen().bounds.width/2, y: UIScreen.mainScreen().bounds.height-100)  //位置
    var duration : NSTimeInterval = 3
    var alpha : CGFloat = 0.7
    
    //设置字体大小
    func sizeWithString(string:NSString, font:UIFont)->CGSize {
        let dic:NSDictionary = NSDictionary(object: font, forKey: NSFontAttributeName)
        let options = NSStringDrawingOptions.TruncatesLastVisibleLine
        let rect:CGRect = string.boundingRectWithSize(frameSize, options:options, attributes: dic as? [String : AnyObject], context: nil)
        return rect.size
    }
    
    func showToast(text: String){
        
        let size:CGSize = self.sizeWithString(text, font: UIFont.systemFontOfSize(textFont))
        
        //显示的lable
        let label:UILabel = UILabel (frame: CGRectMake(0, 0, size.width, size.height))
        label.text = text
        label.font = UIFont.systemFontOfSize(textFont)
        label.numberOfLines = 0;
        label.textColor = UIColor.whiteColor()
        
        let window:UIWindow = UIApplication.sharedApplication().keyWindow!
        let v:UIButton = UIButton(frame:CGRectMake(0, 0, size.width + frameMarginSize, size.height + frameMarginSize))
        label.center = CGPointMake(v.frame.size.width / 2, v.frame.size.height / 2);
        v.addSubview(label)
        
        v.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha)
        v.layer.cornerRadius = 5
        var point:CGPoint = CGPointMake(position.x, position.y);
        point = CGPointMake(point.x , point.y + 10);
        v.center = point
        view = v
        
        v.addTarget(self, action: "hideToast", forControlEvents: UIControlEvents.TouchDown)
        window.addSubview(v) //用window加，保证最前
        //自动消失
        let timer:NSTimer = NSTimer(timeInterval: duration, target: self, selector: "hideToast", userInfo: nil, repeats: false)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
    }
    
    func hideToast(){
        UIView.animateWithDuration(0.2, animations: {
            () -> ()in
            self.view.alpha = 0
            }, completion: {
                (Boolean) -> ()in
                self.view.removeFromSuperview()
        })
    }
}