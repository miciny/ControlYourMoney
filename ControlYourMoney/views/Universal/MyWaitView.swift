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
class MyWaitView: UIView{
    
    //私有变量，不可改
    internal var mask: UIControl! //把视图加到主窗口
    fileprivate var timer: Timer! //定时器，可以设置几秒后消失
    
    //可以修改，改变属性
    var viewAlpha : CGFloat = 1 //透明度
    var timeOut : TimeInterval = 30 //超时时长
    var centerPosition = CGPoint(x: Width/2, y: Height/2) //中点位置
    
    func showWait(_ title: String){
        
        //控制器
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10 //边角
        self.layer.borderColor = UIColor.clear.cgColor //边框颜色
        self.backgroundColor = UIColor.clear  //背景色
        let position: CGPoint = self.center
        self.frame = CGRect(x: position.x-50, y: position.y-50, width: 100, height: 100)
        
        //view
        let tmpView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        tmpView.backgroundColor = UIColor.black
        tmpView.alpha = viewAlpha   //透明度
        tmpView.layer.masksToBounds = true
        tmpView.layer.cornerRadius = 10
        self.addSubview(tmpView)
        
        //转圈的动画
        let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = true
        activityIndicator.startAnimating()
        activityIndicator.center = CGPoint(x: 50, y: 50)
        self.addSubview(activityIndicator)
        
        //显示的文案
        let loadingLab = UILabel(frame: CGRect(x: 0, y: 70, width: 100, height: 20));
        loadingLab.backgroundColor = UIColor.clear;
        loadingLab.textAlignment = NSTextAlignment.center
        loadingLab.textColor = UIColor.white
        loadingLab.font = UIFont.systemFont(ofSize: 15)
        loadingLab.text = title
        self.addSubview(loadingLab)
        
        // 添加超时定时器
        timer = Timer(timeInterval: timeOut, target: self, selector: #selector(MyWaitView.timerDeadLine), userInfo: nil, repeats: false)
        
        //显示toast的View
        if mask==nil {
            mask = UIControl(frame: UIScreen.main.bounds)
            mask.backgroundColor = UIColor.clear
            mask.addSubview(self)
            UIApplication.shared.keyWindow?.addSubview(mask)
            self.center = CGPoint(x: centerPosition.x, y: centerPosition.y)
            mask.alpha = 1
        }
        mask.isHidden = false
        
        // 添加定时器
        if timer != nil {
            RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        }
    }
    
    //请求超时时显示
    @objc fileprivate func timerDeadLine(){
        self.hideView()
        MyWaitView.makeToast("请求超时")
    }
    
    //隐藏
    func hideView() {
        if Thread.current.isMainThread{
            self.removeView()
        }else {
            DispatchQueue.main.async(execute: { () -> Void in
                self.removeView()
            })
        }
    }
    
    //移除view
    fileprivate func removeView(){
        if mask != nil {
            mask.isHidden = true
            timer.invalidate()
        }
    }
    
    //这个用法可以学习，显示toast
    class func makeToast(_ strTitle:String) {
        Thread.sleep(forTimeInterval: 0.3)
        let toast = MyToastView()
        if Thread.current.isMainThread{
            toast.showToast(strTitle)
        }else {
            DispatchQueue.main.async(execute: { () -> Void in
                toast.showToast(strTitle)
            })
        }
    }
}
