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
    var userIcon = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigator()
        setUpEles()
        setUpTouch()
        setData()
    }
    
    func hideNavigator(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func setUpEles(){
        self.view.backgroundColor = UIColor.whiteColor()
        
        userIcon.frame = CGRect(x: Width/2-50, y: 100, width: 100, height: 100)
        userIcon.image = ChangeValue.dataToImage(nil)
        userIcon.layer.masksToBounds = true
        userIcon.layer.cornerRadius = 5
        self.view.addSubview(userIcon)
        
        let imgView = UIImageView(image: UIImage(named: "Finger"))
        imgView.frame = CGRect(x: userIcon.frame.minX, y: userIcon.frame.maxY+50, width: 100, height: 100)
        self.view.addSubview(imgView)
        
        let tipLabel = UILabel()
        tipLabel.text = "点击进行指纹解锁"
        tipLabel.font = standardFont
        tipLabel.sizeToFit()
        tipLabel.textColor = UIColor(red: 0, green: 191/255, blue: 255/255, alpha: 1)
        tipLabel.center = CGPointMake(Width * 0.5, CGRectGetMaxY(imgView.frame) + 30)
        self.view.addSubview(tipLabel)
        
        let changeAccountBtnSize = sizeWithText("切换用户", font: pageTitleFont, maxSize: CGSize(width: Width, height: Height))
        let changeAccountBtn = UIButton(frame: CGRect(x: Width/2-changeAccountBtnSize.width/2, y: Height-64, width: changeAccountBtnSize.width, height: 44))
        changeAccountBtn.setTitleColor(UIColor(red: 0, green: 191/255, blue: 255/255, alpha: 1), forState: .Normal)
        changeAccountBtn.setTitle("切换用户", forState: .Normal)
        changeAccountBtn.titleLabel?.font = pageTitleFont
        changeAccountBtn.backgroundColor = UIColor.clearColor()
        changeAccountBtn.addTarget(self, action: #selector(self.changeAccount), forControlEvents: .TouchUpInside)
        self.view.addSubview(changeAccountBtn)
    
    }
    
    func changeAccount(){
        //先删除数据，再进入登录页
        DeleteCoreData.deleteUserData()
        DeleteCoreData.deleteAllMoneyData()
        
        //进入登录页
        let vcc = LoginViewController()
        self.navigationController?.pushViewController(vcc, animated: true)
        //导航
        let viewArray = NSMutableArray()
        viewArray.addObjectsFromArray((self.navigationController?.viewControllers)!)
        viewArray.removeObjectAtIndex(0)
        //重新设置导航器，执行动画
        self.navigationController?.setViewControllers(viewArray as NSArray as! [UIViewController], animated: true)
        
    }
    
    func setData(){
        
        let data = DataToModel.getUserDataToModel()
        passwdString = data.pw
        
        //加载图片
        if let imageData = SaveDataToCacheDir.loadIconFromCacheDir(data.account){
            userIcon.image = ChangeValue.dataToImage(imageData)
        }else{
            userIcon.image = ChangeValue.dataToImage(nil)
        }
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
                        self.dismiss()
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
                        self.dismiss()
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

    
    //消失
    func dismiss(){
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
