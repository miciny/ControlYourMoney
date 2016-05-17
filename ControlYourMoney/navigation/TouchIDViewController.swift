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
    
    let passwdString = "zhangxue"

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
                        let home = TabbarViewController()
                        self.presentViewController(home, animated: false, completion: nil)
                        self.removeFromParentViewController()
                    }else{
                        if(error?.code == -3){
                            self.showPasswordAlert()
                        }
                    }
                })
            })
        }else{
            switch error!.code
            {
            case LAError.TouchIDNotEnrolled.rawValue:
                UIAlertView(title: "提示", message: "您还没有保存过Touch ID", delegate: nil, cancelButtonTitle: "好的").show()
            case LAError.PasscodeNotSet.rawValue:
                UIAlertView(title: "提示", message: "您还没有设置密码", delegate: nil, cancelButtonTitle: "好的").show()
            default:
                UIAlertView(title: "提示", message: "TouchID不可用", delegate: nil, cancelButtonTitle: "好的").show()
            }
            // Optionally the error description can be displayed on the console.
            print(error?.localizedDescription)
        }
    }

    //密码验证 可以弄个输入框，输入密码 或者跳到输入密码界面
    func showPasswordAlert() {
        let passwordAlert : UIAlertView = UIAlertView(title: "TouchID", message: "请输入密码", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        passwordAlert.alertViewStyle = UIAlertViewStyle.SecureTextInput
        passwordAlert.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if buttonIndex == 1{
            if !alertView.textFieldAtIndex(0)!.text!.isEmpty {
                if alertView.textFieldAtIndex(0)!.text == passwdString {
                    let home = TabbarViewController()
                    self.presentViewController(home, animated: false, completion: nil)
                    self.removeFromParentViewController()
                }else{
                    showPasswordAlert()
                }
            }else{
                showPasswordAlert()
            }
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
