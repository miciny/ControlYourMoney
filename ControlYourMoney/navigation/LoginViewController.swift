//
//  LoginViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/6/6.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController , UITextFieldDelegate{
    var account = UITextField()
    var pw = UITextField()
    var manager: Manager!

    override func viewDidLoad() {
        super.viewDidLoad()
        manager = NetWork.getDefaultAlamofireManager()
        setUpEles()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        hideNavigator()
    }
    
    func hideNavigator(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //设置元素
    func setUpEles(){
        self.view.backgroundColor = UIColor.whiteColor()
        
        let settingBtnSize = sizeWithText("设置网络", font: standardFont, maxSize: CGSize(width: Width, height: Height))
        let settingBtn = UIButton(frame: CGRect(x: Width-20-settingBtnSize.width, y: 54, width: settingBtnSize.width, height: settingBtnSize.height))
        settingBtn.setTitle("设置网络", forState: .Normal)
        settingBtn.setTitleColor(UIColor(red: 0/255, green: 191/255, blue: 255/255, alpha: 1), forState: .Normal)
        settingBtn.titleLabel?.font = standardFont
        settingBtn.addTarget(self, action: #selector(self.settingNet), forControlEvents: .TouchUpInside)
        self.view.addSubview(settingBtn)
        
        let nameLabelSize = sizeWithText("账号", font: standardFont, maxSize: CGSize(width: Width, height: Height))
        let nameLabel = UILabel(frame: CGRect(x: 10, y: 100, width: nameLabelSize.width, height: 44))
        nameLabel.font = standardFont
        nameLabel.text = "账号"
        self.view.addSubview(nameLabel)
        
        account.frame = CGRect(x: nameLabel.frame.maxX + 30, y: nameLabel.frame.minY, width: Width-nameLabel.frame.maxX - 30, height: 44)
        account.placeholder = "请输入账号"
        account.font = standardFont
        account.delegate = self
        account.clearButtonMode = .WhileEditing
        self.view.addSubview(account)
        
        let line1 = UIView(frame: CGRect(x: 10, y: nameLabel.frame.maxY, width: Width-10, height: 1))
        line1.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        self.view.addSubview(line1)
        
        let pwLabelSize = sizeWithText("密码", font: standardFont, maxSize: CGSize(width: Width, height: Height))
        let pwLabel = UILabel(frame: CGRect(x: 10, y: nameLabel.frame.maxY+1, width: pwLabelSize.width, height: 44))
        pwLabel.font = standardFont
        pwLabel.text = "密码"
        self.view.addSubview(pwLabel)
        
        pw.frame = CGRect(x: account.frame.minX, y: pwLabel.frame.minY, width: Width-pwLabel.frame.maxX - 30, height: 44)
        pw.placeholder = "请输入登录密码"
        pw.font = standardFont
        pw.delegate = self
        pw.clearButtonMode = .WhileEditing
        pw.secureTextEntry = true
        self.view.addSubview(pw)
        
        let line2 = UIView(frame: CGRect(x: 10, y: pwLabel.frame.maxY, width: Width-10, height: 1))
        line2.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        self.view.addSubview(line2)
        
        let loginBtn = UIButton(frame: CGRect(x: 10, y: line2.frame.maxY+10, width: Width-20, height: 44))
        loginBtn.setTitle("登陆", forState: .Normal)
        loginBtn.layer.masksToBounds = true
        loginBtn.layer.cornerRadius = 5
        loginBtn.backgroundColor = UIColor(red: 0/255, green: 191/255, blue: 255/255, alpha: 1)
        loginBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginBtn.addTarget(self, action: #selector(self.login), forControlEvents: .TouchUpInside)
        self.view.addSubview(loginBtn)
        
        let registBtn = UIButton(frame: CGRect(x: 10, y: Height-64, width: Width-20, height: 44))
        registBtn.setTitle("注册", forState: .Normal)
        registBtn.layer.masksToBounds = true
        registBtn.layer.borderWidth = 0.8
        registBtn.layer.borderColor = UIColor.grayColor().CGColor
        registBtn.layer.cornerRadius = 5
        registBtn.backgroundColor = UIColor.whiteColor()
        registBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.view.addSubview(registBtn)
    }
    
    //设置网络
    func settingNet(){
        let vc = SettingNetViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //login
    func login(){
        account.resignFirstResponder()
        pw.resignFirstResponder()
        
        guard let accountStr = account.text where accountStr != "" else{
            textAlertView("请输入账号！")
            return
        }
        
        guard let pwStr = pw.text where pwStr != "" else{
            textAlertView("请输入密码！")
            return
        }
        
        let para = [
            "account": "\(accountStr)",
            "pw": "\(pwStr)"
        ]
        
        let toast = MyToastView()
        let waitView = MyWaitToast()
        waitView.title = "登录中"
        waitView.showWait(self.view)
        manager.request(.GET, NetWork.loginUrl, parameters: para)
            .responseJSON { response in
                
                switch response.result{
                case .Success:
                    waitView.hideView()
                    let code = String((response.response?.statusCode)!)
                    if code == "200"{
                        toast.showToast("登录成功")
                        User.insertUserData(accountStr, name: nil, nickname: nil, address: nil, location: nil, pw: pwStr, sex: nil, time: getTime(), motto: nil, pic: nil, http: nil, picPath: nil)
                        self.dismissViewControllerAnimated(false, completion: nil)
                        
                    }else if code == "201"{
                        toast.showToast("用户名或密码错误")
                    }else {
                        let a = code.substringToIndex(code.startIndex.advancedBy(1))
                        let str = getErrorCodeToString(a)
                        toast.showToast("\(str)")
                    }
                    
                case .Failure:
                    waitView.hideView()
                    
                    if response.response == nil{
                        toast.showToast("无法连接服务器！")
                    }else{
                        toast.showToast("同步数据失败！")
                    }
                    
                    print(response.response)
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
