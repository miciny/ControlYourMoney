//
//  MyToastView.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/11.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class MyToastView: UIView {
    private var frameMarginSize: CGFloat! = 20 //与周围的边距
    private var frameSize: CGSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width-40, 60) //大小
    private var view: UIView!
    private var position : CGPoint = CGPoint(x: UIScreen.mainScreen().bounds.width/2, y: UIScreen.mainScreen().bounds.height-100)  //位置
    private var myAlpha: CGFloat = 0.7
    
    var duration : NSTimeInterval = 3
    
    func showToast(text: String){
        
        let size:CGSize = sizeWithText(text, font: standardFont, maxSize: CGSizeMake(UIScreen.mainScreen().bounds.size.width-40, 60))
        
        //显示的lable
        let label:UILabel = UILabel (frame: CGRectMake(0, 0, size.width, size.height))
        label.text = text
        label.font = standardFont
        label.numberOfLines = 0;
        label.textColor = UIColor.whiteColor()
        
        let window:UIWindow = UIApplication.sharedApplication().keyWindow!
        let v:UIButton = UIButton(frame:CGRectMake(0, 0, size.width + frameMarginSize, size.height + frameMarginSize))
        label.center = CGPointMake(v.frame.size.width / 2, v.frame.size.height / 2);
        v.addSubview(label)
        
        v.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: myAlpha)
        v.layer.cornerRadius = 5
        var point:CGPoint = CGPointMake(position.x, position.y);
        point = CGPointMake(point.x , point.y + 10);
        v.center = point
        view = v
        
        v.addTarget(self, action: #selector(MyToastView.hideToast), forControlEvents: UIControlEvents.TouchDown)
        window.addSubview(v) //用window加，保证最前
        //自动消失
        let timer:NSTimer = NSTimer(timeInterval: duration, target: self, selector: #selector(MyToastView.hideToast), userInfo: nil, repeats: false)
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