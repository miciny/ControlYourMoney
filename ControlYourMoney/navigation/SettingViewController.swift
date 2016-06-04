//
//  SettingViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/26.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate{
    private var mainTabelView: UITableView? //整个table
    private var settingData : NSMutableArray? //数据

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitle()
        setData()
        setUpTable()
    }
    
    func setUpTitle(){
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
        self.title = "设置"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        setData()
        mainTabelView?.reloadData()
    }
    
    //设置数据
    func setData(){
        settingData = NSMutableArray()
        
        let userInfoModel = DataToModel.getUserDataToModel()
        let userIcon = ChangeValue.dataToImage(userInfoModel.pic)
        let tdIcon = UIImage(named: "TDIcon")
        
        let settingOne = SettingDataModul(icon: userIcon, name: userInfoModel.name, nickname: userInfoModel.nickname, pic: tdIcon)
        let settingTwo1 = SettingDataModul(icon: nil, name: "修改密码", lable: nil, pic: nil)
        let settingTwo2 = SettingDataModul(icon: nil, name: "同步数据", lable: nil, pic: nil)
        let settingThree = SettingDataModul(icon: nil, name: "数据说明", lable: nil, pic: nil)
        let settingFour = SettingDataModul(icon: nil, name: "高级设置", lable: nil, pic: nil)
        
        settingData?.addObject([settingOne])
        settingData?.addObject([settingTwo1, settingTwo2])
        settingData?.addObject([settingThree])
        settingData?.addObject([settingFour])
    }
    
    //设置tableView
    func setUpTable(){
        mainTabelView = UITableView(frame: self.view.frame, style: .Grouped)  //为group模式
        mainTabelView?.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        
        mainTabelView?.showsVerticalScrollIndicator = false
        mainTabelView?.showsHorizontalScrollIndicator = false
        mainTabelView?.separatorStyle = UITableViewCellSeparatorStyle.SingleLine //是否显示线条
        mainTabelView?.sectionFooterHeight = 5  //每个section的间距
        
        mainTabelView?.delegate = self
        mainTabelView?.dataSource = self
        
        self.view.addSubview(mainTabelView!)
    }
    
    //=====================================================================================================
    /**
     MARK: - Table view delegate
     **/
    //=====================================================================================================
    
    //section个数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return settingData!.count
    }
    
    //每个section的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingData![section].count
    }
    
    //计算每个cell高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section: [AnyObject]  =  self.settingData![indexPath.section] as! [AnyObject] //获取section里的对象
        let data = section[indexPath.row]
        let item =  data as! SettingDataModul
        let height  = item.cellHeigth
        
        return height
    }
    
    //=====================================================================================================
    /**
     MARK: - Table view data source
     **/
    //=====================================================================================================
    
    
    //每个cell内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "SettingCell"
        let section : NSArray =  self.settingData![indexPath.section] as! NSArray
        let data = section[indexPath.row]
        let cell =  SettingTableViewCell(data:data as! SettingDataModul, reuseIdentifier:cellId)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator  //显示后面的小箭头
        
        return cell
    }
    
    //选择了row
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        mainTabelView!.deselectRowAtIndexPath(indexPath, animated: true)  //被选择后，会变灰，这么做还原
        
        switch indexPath.section{
        //进入个人信息页
        case 0:
            switch indexPath.row {
            //个人信息页
            case 0:
                let vc = UserInfoViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
            
        //第二个设置栏
        case 1:
            switch indexPath.row {
            case 0: //设置密码
                showPasswordAlert()
                
            case 1: //同步数据
                let vc = SyncDataViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
            
        case 2:
            switch indexPath.row {
            case 0: //说明
                let vc = ExplainViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        case 3:
            switch indexPath.row {
            case 0: //高级设置
                let vc = AdvanceSettingViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        default:
            break
        }
    }

    //一个section头部的高度
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func showPasswordAlert() {
        let passwordAlert = UIAlertView(title: "密码验证", message: "请输入原始密码", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        passwordAlert.alertViewStyle = UIAlertViewStyle.SecureTextInput
        passwordAlert.tag = 5
        passwordAlert.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){

        if alertView.tag == 5 {
            if buttonIndex == 1{
                if !alertView.textFieldAtIndex(0)!.text!.isEmpty {
                    let str = alertView.textFieldAtIndex(0)!.text
                    assertPW(str!)
                }else{
                    showPasswordAlert()
                }
            }
        }
    }
    
    //验证密码
    func assertPW(str: String){
        
        let waitView = MyWaitToast()
        waitView.title = "验证中..."
        waitView.showWait(self.view)
        
        delay(0.5) {
            let toast = MyToastView()
            
            let data = DataToModel.getUserDataToModel()
            let passwdString = data.pw
            
            if str == passwdString {
                //成功
                self.goChangePWPage()
            }else{
                toast.showToast("验证失败！")
            }
            waitView.hideView()
        }
    }
    
    //进入改密码页
    func goChangePWPage(){
        let vc = ChangePWViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
