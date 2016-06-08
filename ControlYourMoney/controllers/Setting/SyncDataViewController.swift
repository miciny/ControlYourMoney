//
//  SyncDataViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/27.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//


//=====================================================================================================
/**
 MARK: - 同步数据使
 **/
//=====================================================================================================

import UIKit
import SwiftyJSON
import Alamofire

class SyncDataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate{
    private var mainTabelView: UITableView? //整个table
    private var settingData : NSMutableArray? //数据
    
    let downLoad = UIButton() //下载按钮
    let textView = UITextView() //显示上传数据的textview
    let copyBtn = UIButton() //复制按钮
    let upWiatView = MyWaitView() //toast
    let downWiatView = MyWaitView()
    
    var switchBtn: UISwitch? //网络下载数据开关
    var switchIsOn: Bool!
    var netManager: Manager?
    
    var json: JSON = JSON.null //保存下载的数据

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitle()
        initNetManager()
        setData()
        setUpTable()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        InternetSetting.updateuserData(0, changeValue: (self.switchBtn?.on)!, changeFieldName: internetSettingNameOfInternet)
    }
    
    func setUpTitle(){
        self.title = "同步数据"
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
        
        let addItemFast = UIBarButtonItem(title: "说明", style: .Plain, target: self, action:
            #selector(SyncDataViewController.goExplainPage))
        self.navigationItem.rightBarButtonItem = addItemFast
    }
    
    func goExplainPage(){
        let vc = SyncDataExplainViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //设置数据
    func setData(){
        settingData = NSMutableArray()
        let data = DataToModel.getURLModel()
        let ip = data.ip
        let port = data.port
        self.switchIsOn = data.internet
        
        let settingOne = SettingDataModul(icon: nil, name: "网络同步")
        let settingTwo1 = SettingDataModul(icon: nil, name: "IP地址", lable: ip, pic: nil)
        let settingTwo2 = SettingDataModul(icon: nil, name: "端口", lable: port, pic: nil)
        
        settingData?.addObject([settingOne])
        settingData?.addObject([settingTwo1, settingTwo2])
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
        
        mainTabelView?.tableFooterView = setFooterView() // 设置footerView,设置代理之后再设置foot，不然会出问题
        
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
    
    //一个section头部的高度
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    //选择了row
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        mainTabelView!.deselectRowAtIndexPath(indexPath, animated: true)  //被选择后，会变灰，这么做还原
        switch indexPath.section{
        //ip 端口
        case 1:
            switch indexPath.row {
            case 0: //ip
                let ipAlert = UIAlertView(title: "修改IP地址", message: "请输入IP", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
                ipAlert.tag = 0
                ipAlert.alertViewStyle = .PlainTextInput
                
                let section : NSArray =  self.settingData![1] as! NSArray
                let data = section[0] as! SettingDataModul
                ipAlert.textFieldAtIndex(0)!.text = data.lable
                
                ipAlert.show()
                
            case 1: //端口
                let portAlert = UIAlertView(title: "修改端口", message: "请输入端口号", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
                portAlert.tag = 1
                portAlert.alertViewStyle = .PlainTextInput
                
                let section : NSArray =  self.settingData![1] as! NSArray
                let data = section[1] as! SettingDataModul
                portAlert.textFieldAtIndex(0)!.text = data.lable
                
                portAlert.show()
            default:
                break
            }
            
        default:
            break
        }
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
        let data = section[indexPath.row] as! SettingDataModul
        let cell =  SettingTableViewCell(data: data , reuseIdentifier:cellId)
        
        if indexPath.section > 0 {
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator  //显示后面的小箭头
        }
        
        if indexPath.section == 0 {
            cell.selectionStyle = .None
            self.switchBtn = cell.switchBtn
            self.switchBtn?.setOn(self.switchIsOn, animated: true)
        }
        
        return cell
    }
    
    //=====================================================================================================
    /**
     MARK: - alert delegate
     **/
    //=====================================================================================================
    
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch alertView.tag{
        case 0:
            if buttonIndex == 1 {
                let section : NSArray =  self.settingData![1] as! NSArray
                let data = section[0] as! SettingDataModul
                
                let text = alertView.textFieldAtIndex(0)!.text
                
                data.lable = text
                
                let indexPath = NSIndexPath(forRow: 0, inSection: 1)
                mainTabelView?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                
                InternetSetting.updateuserData(0, changeValue: text!, changeFieldName: internetSettingNameOfIP)
            }
        case 1:
            if buttonIndex == 1 {
                
                let section : NSArray =  self.settingData![1] as! NSArray
                let data = section[1] as! SettingDataModul
                
                let text = alertView.textFieldAtIndex(0)!.text
                
                data.lable = text
                
                let indexPath = NSIndexPath(forRow: 1, inSection: 1)
                mainTabelView?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                
                InternetSetting.updateuserData(0, changeValue: text!, changeFieldName: internetSettingNameOfPort)
            }
        case 2:
            if buttonIndex == 1 {
                downloadDataFromJsonFile()
            }
        default:
            break
        }
    }
    
    //footerView
    func setFooterView() -> UIView{
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clearColor()
        
        let upLoad = UIButton()
        upLoad.frame = CGRect(x: 20, y: 20, width: Width-40, height: 50)
        upLoad.backgroundColor = UIColor(red: 0/255, green: 205/255, blue: 0/255, alpha: 1.0)
        upLoad.setTitle("上传数据", forState: .Normal)
        upLoad.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        upLoad.layer.cornerRadius = 5
        upLoad.addTarget(self, action: #selector(controlUpData), forControlEvents: .TouchUpInside)
        footerView.addSubview(upLoad)
        
        downLoad.frame = CGRect(x: 20, y: upLoad.frame.maxY+20, width: Width-40, height: 50)
        downLoad.backgroundColor = UIColor.whiteColor()
        downLoad.setTitle("下载数据", forState: .Normal)
        downLoad.setTitleColor(UIColor.blackColor(), forState: .Normal)
        downLoad.addTarget(self, action: #selector(downLoadData), forControlEvents: .TouchUpInside)
        downLoad.layer.cornerRadius = 5
        footerView.addSubview(downLoad)
        
        copyBtn.frame = CGRect(x: 20, y: downLoad.frame.maxY+10, width: 40, height: 20)
        copyBtn.setTitle("复制", forState: .Normal)
        copyBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
        copyBtn.backgroundColor = UIColor.lightGrayColor()
        copyBtn.addTarget(self, action: #selector(copyText), forControlEvents: .TouchUpInside)
        copyBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        copyBtn.enabled = false
        copyBtn.hidden = true //一开始不显示复制按钮
        footerView.addSubview(copyBtn)
        
        textView.frame = CGRect(x: 20, y: copyBtn.frame.maxY+10, width: Width-40, height: 200)
        textView.backgroundColor = UIColor.clearColor()
        textView.font = standardFont
        textView.textColor = UIColor.blackColor()
        textView.editable = false
        footerView.addSubview(textView)
        
        footerView.frame = CGRect(x: 0, y: 0, width: Width, height: textView.frame.maxY+10)
        
        //这种判断有点问题，先这样吧
        let cash = Cash.selectAllData()
        if cash.count > 0 {
            downLoad.enabled = false
            downLoad.backgroundColor = UIColor.lightGrayColor()
        }
        
        return footerView
    }
    
    //复制文本
    func copyText(){
        guard let str = textView.text where str != "" else{
            MyToastView().showToast("无数据")
            return
        }
        
        UIPasteboard.generalPasteboard().string = str
        MyToastView().showToast("复制成功")
    }
    
    //=====================================================================================================
    /**
     MARK: - 下载数据
     **/
    //=====================================================================================================
    
    //初始化网络请求的manager
    func initNetManager(){
        netManager = NetWork.getDefaultAlamofireManager()
    }
    
    //下载数据，就是导入数据到数据库
    func downLoadData(){
        if (self.switchBtn?.on == true) {
            downWiatView.showWait("下载中...")
            NetWork.showNetIndicator()
            
            self.downloadDataFromDB()
        }else{
            let localAlert = UIAlertView(title: "从本地导入？", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
            localAlert.tag = 2
            localAlert.show()
        }
    }
    
    //从网络下载数据 必须使用https
//    在Info.plist中添加NSAppTransportSecurity类型Dictionary。
//    在NSAppTransportSecurity下添加NSAllowsArbitraryLoads类型Boolean,值设为YES
    
    func downloadDataFromDB(){
        netManager!.request(.GET, NetWork.moneyUrl, parameters: NetWork.moneyGetParas)
            .responseJSON { response in
                NetWork.hidenNetIndicator()
                switch response.result{
                case .Success:
                    
                    let code = String((response.response?.statusCode)!)
                    let a = code.substringToIndex(code.startIndex.advancedBy(1))
                    
                    if a == "2"{
                        self.json = JSON(response.result.value!)
                        self.insertData()
                    }else{
                        self.downWiatView.hideView()
                        let str = getErrorCodeToString(a)
                        MyToastView().showToast("\(str)")
                    }
                    
                case .Failure:
                    self.downWiatView.hideView()
                    
                    if response.response == nil{
                        MyToastView().showToast("无法连接服务器！")
                    }else{
                        MyToastView().showToast("下载数据失败！")
                    }
                    
                    print(response.response)
                }
        }
    }
    
    //下载数据
    func downloadDataFromJsonFile() -> Bool{
        if let file = NSBundle.mainBundle().pathForResource("json", ofType: "json") {
            let data = NSData(contentsOfFile: file)!
            self.json = JSON(data: data)
            
            insertData()
            
            return true
        }else{
            self.downWiatView.hideView()
            MyToastView().showToast("导入数据失败！")
            return false
        }
    }
    
    
    //
    func insertData(){
        
        InsertData.insertAllMoneyData(self.json)
        
        self.downWiatView.hideView()
        
        let toast = MyToastView()
        toast.showToast("导入数据成功！")
        
        //下载按钮不可用
        self.downLoad.enabled = false
        self.downLoad.backgroundColor = UIColor.lightGrayColor()
        
    }

    //=====================================================================================================
    /**
     MARK: - 上传数据
     **/
    //=====================================================================================================
    
    //本地时只是显示，网络时才连接网络
    func controlUpData(){
        
        if self.switchBtn?.on == true{
            upWiatView.showWait("上传中...")
            NetWork.showNetIndicator()
            
            let jsonStr = self.upLoadData()
            self.upLoadDataToDB(jsonStr) //上传数据到服务器
        }else{
            self.upLoadData()
        }
    }
    
    //显示上传的数据
    func upLoadData() -> String{
        let jsonStr = ArrayToJsonStr.getMoneyDataArrayToJsonStr()
        
        textView.text = ""
        textView.text = jsonStr
        textView.backgroundColor = UIColor.whiteColor()
        
        copyBtn.backgroundColor = UIColor.whiteColor()
        copyBtn.enabled = true
        copyBtn.hidden = false
        
        return jsonStr
    }
    
    //上传数据到服务器
    func upLoadDataToDB(str: String){
        let data = DataToModel.getUserDataToModel()
        
        let paras = [
            "data": strToJson(str),
            "account": data.account
        ]
        
        netManager!.request(.POST, NetWork.moneyUrl, parameters: paras, encoding: .JSON)
            .responseJSON { response in
                
                NetWork.hidenNetIndicator()
                self.upWiatView.hideView()
                
                switch response.result{
                case .Success:
                    let code = String((response.response?.statusCode)!)
                    let a = code.substringToIndex(code.startIndex.advancedBy(1))
                    
                    if a == "2"{
                        MyToastView().showToast("上传数据成功！")
                    }else{
                        let str = getErrorCodeToString(a)
                        MyToastView().showToast("\(str)")
                    }
                    
                case .Failure:
                    if response.response == nil{
                        MyToastView().showToast("无法连接服务器！")
                    }else{
                        MyToastView().showToast("上传数据失败！")
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
