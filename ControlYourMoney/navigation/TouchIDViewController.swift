//
//  TouchIDViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/17.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import LocalAuthentication

class TouchIDViewController: UIViewController, UIAlertViewDelegate{
    
    var passwdString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEles()
        setUpTouch()
    }

    func setUpEles(){
        
        let imgView = UIImageView(image: UIImage(named: "Finger"))
        imgView.frame.size = CGSize(width: Width*0.3, height: Width*0.3)
        imgView.center = CGPointMake(Width * 0.5, Height * 0.4)
        self.view.addSubview(imgView)
        
        let tipLabel = UILabel()
        tipLabel.text = "点击进行指纹解锁"
        tipLabel.sizeToFit()
        tipLabel.center = CGPointMake(Width * 0.5, CGRectGetMaxY(imgView.frame) + 30)
        self.view.addSubview(tipLabel)
        
        let data = DataToModel.getUserDataToModel()
        passwdString = data.pw
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        setUpTouch()
    }
    
    func setUpTouch(){
        // 第一步判断是否支持Touch ID 或者 本机是否已经录入指纹
        let context = LAContext()
        var error : NSError?
        
        if (context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error)) {
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "请验证已有指纹", reply: { (success: Bool, error: NSError?) -> Void in
                
                // 进入主页面
                dispatch_async(dispatch_get_main_queue(), {
                    if success {
                        self.dismissViewControllerAnimated(false, completion: nil)
                    }else{
                        if(error?.code == -3){
                            self.showPasswordAlert()
                        }
                    }
                })
            })
        }else{
            switch error!.code{
            case LAError.TouchIDNotEnrolled.rawValue:
                UIAlertView(title: "提示", message: "您还没有保存过Touch ID", delegate: self, cancelButtonTitle: "好的").show()
            case LAError.PasscodeNotSet.rawValue:
                UIAlertView(title: "提示", message: "您还没有设置密码", delegate: self, cancelButtonTitle: "好的").show()
            default:
                UIAlertView(title: "提示", message: "TouchID不可用", delegate: self, cancelButtonTitle: "好的").show()
            }
            // Optionally the error description can be displayed on the console.
            print(error?.localizedDescription)
        }
    }

    //密码验证 可以弄个输入框，输入密码 或者跳到输入密码界面
    func showPasswordAlert() {
        let passwordAlert = UIAlertView(title: "TouchID", message: "请输入密码", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        passwordAlert.alertViewStyle = UIAlertViewStyle.SecureTextInput
        passwordAlert.tag = 5
        passwordAlert.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if alertView.tag == 5 {
            if buttonIndex == 1{
                if !alertView.textFieldAtIndex(0)!.text!.isEmpty {
                    if alertView.textFieldAtIndex(0)!.text == passwdString {
                        self.dismissViewControllerAnimated(false, completion: nil)
                    }else{
                        showPasswordAlert()
                    }
                }else{
                    showPasswordAlert()
                }
            }
        }else{
            self.showPasswordAlert()
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
