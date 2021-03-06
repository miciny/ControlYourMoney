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
    fileprivate var mainTabelView: UITableView? //整个table
    fileprivate var settingData : NSMutableArray? //数据
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        InternetSetting.updateuserData(0, changeValue: (self.switchBtn?.isOn)!, changeFieldName: internetSettingNameOfInternet)
    }
    
    func setUpTitle(){
        self.title = "同步数据"
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
        
        let addItemFast = UIBarButtonItem(title: "说明", style: .plain, target: self, action:
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
        
        settingData?.add([settingOne])
        settingData?.add([settingTwo1, settingTwo2])
    }
    
    //设置tableView
    func setUpTable(){
        mainTabelView = UITableView(frame: self.view.frame, style: .grouped)  //为group模式
        mainTabelView?.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        
        mainTabelView?.showsVerticalScrollIndicator = false
        mainTabelView?.showsHorizontalScrollIndicator = false
        mainTabelView?.separatorStyle = UITableViewCellSeparatorStyle.singleLine //是否显示线条
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingData!.count
    }
    
    //每个section的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (settingData![section] as AnyObject).count
    }
    
    //计算每个cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section: [AnyObject]  =  self.settingData![indexPath.section] as! [AnyObject] //获取section里的对象
        let data = section[indexPath.row]
        let item =  data as! SettingDataModul
        let height  = item.cellHeigth
        
        return height!
    }
    
    //一个section头部的高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    //选择了row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainTabelView!.deselectRow(at: indexPath, animated: true)  //被选择后，会变灰，这么做还原
        switch indexPath.section{
        //ip 端口
        case 1:
            switch indexPath.row {
            case 0: //ip
                let ipAlert = UIAlertView(title: "修改IP地址", message: "请输入IP", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
                ipAlert.tag = 0
                ipAlert.alertViewStyle = .plainTextInput
                
                let section : NSArray =  self.settingData![1] as! NSArray
                let data = section[0] as! SettingDataModul
                ipAlert.textField(at: 0)!.text = data.lable
                
                ipAlert.show()
                
            case 1: //端口
                let portAlert = UIAlertView(title: "修改端口", message: "请输入端口号", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
                portAlert.tag = 1
                portAlert.alertViewStyle = .plainTextInput
                
                let section : NSArray =  self.settingData![1] as! NSArray
                let data = section[1] as! SettingDataModul
                portAlert.textField(at: 0)!.text = data.lable
                
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "SettingCell"
        let section : NSArray =  self.settingData![indexPath.section] as! NSArray
        let data = section[indexPath.row] as! SettingDataModul
        let cell =  SettingTableViewCell(data: data , reuseIdentifier:cellId)
        
        if indexPath.section > 0 {
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator  //显示后面的小箭头
        }
        
        if indexPath.section == 0 {
            cell.selectionStyle = .none
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
    
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        switch alertView.tag{
        case 0:
            if buttonIndex == 1 {
                let section : NSArray =  self.settingData![1] as! NSArray
                let data = section[0] as! SettingDataModul
                
                let text = alertView.textField(at: 0)!.text
                
                data.lable = text
                
                let indexPath = IndexPath(row: 0, section: 1)
                mainTabelView?.reloadRows(at: [indexPath], with: .none)
                
                InternetSetting.updateuserData(0, changeValue: text!, changeFieldName: internetSettingNameOfIP)
            }
        case 1:
            if buttonIndex == 1 {
                
                let section : NSArray =  self.settingData![1] as! NSArray
                let data = section[1] as! SettingDataModul
                
                let text = alertView.textField(at: 0)!.text
                
                data.lable = text
                
                let indexPath = IndexPath(row: 1, section: 1)
                mainTabelView?.reloadRows(at: [indexPath], with: .none)
                
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
        footerView.backgroundColor = UIColor.clear
        
        let upLoad = UIButton()
        upLoad.frame = CGRect(x: 20, y: 20, width: Width-40, height: 50)
        upLoad.setTitle("上传数据", for: UIControlState())
        upLoad.setTitleColor(UIColor.white, for: UIControlState())
        upLoad.layer.cornerRadius = 5
        upLoad.addTarget(self, action: #selector(controlUpData), for: .touchUpInside)
        upLoad.isEnabled = false
        upLoad.backgroundColor = UIColor.lightGray
        footerView.addSubview(upLoad)
        
        downLoad.frame = CGRect(x: 20, y: upLoad.frame.maxY+20, width: Width-40, height: 50)
        downLoad.backgroundColor = UIColor.white
        downLoad.setTitle("下载数据", for: UIControlState())
        downLoad.setTitleColor(UIColor.black, for: UIControlState())
        downLoad.addTarget(self, action: #selector(downLoadData), for: .touchUpInside)
        downLoad.layer.cornerRadius = 5
        footerView.addSubview(downLoad)
        
        copyBtn.frame = CGRect(x: 20, y: downLoad.frame.maxY+10, width: 40, height: 20)
        copyBtn.setTitle("复制", for: UIControlState())
        copyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        copyBtn.backgroundColor = UIColor.lightGray
        copyBtn.addTarget(self, action: #selector(copyText), for: .touchUpInside)
        copyBtn.setTitleColor(UIColor.black, for: UIControlState())
        copyBtn.isEnabled = false
        copyBtn.isHidden = true //一开始不显示复制按钮
        footerView.addSubview(copyBtn)
        
        textView.frame = CGRect(x: 20, y: copyBtn.frame.maxY+10, width: Width-40, height: 200)
        textView.backgroundColor = UIColor.clear
        textView.font = standardFont
        textView.textColor = UIColor.black
        textView.isEditable = false
        footerView.addSubview(textView)
        
        footerView.frame = CGRect(x: 0, y: 0, width: Width, height: textView.frame.maxY+10)
        
        //这种判断有点问题，先这样吧
        let cash = Cash.selectAllData()
        if cash.count > 0 {
            downLoad.isEnabled = false
            downLoad.backgroundColor = UIColor.lightGray
            
            upLoad.backgroundColor = UIColor(red: 0/255, green: 205/255, blue: 0/255, alpha: 1.0)
            upLoad.isEnabled = true
        }
        
        return footerView
    }
    
    //复制文本
    func copyText(){
        guard let str = textView.text, str != "" else{
            MyToastView().showToast("无数据")
            return
        }
        
        UIPasteboard.general.string = str
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
        if (self.switchBtn?.isOn == true) {
            
            if checkNet() != networkType.wifi{
                textAlertView("请连接Wi-Fi进行同步")
                return
            }
            
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
                    
                    if code == "200"{
                        self.json = JSON(response.result.value!)
                        self.insertData()
                    }else{
                        self.downWiatView.hideView()
                        let str = getErrorCodeToString(code)
                        MyToastView().showToast("\(str)")
                    }
                    
                case .Failure:
                    self.downWiatView.hideView()
                    NetWork.networkFailed(response.response)
                    
                    print(response.response)
                }
        }
    }
    
    //下载数据
    func downloadDataFromJsonFile() -> Bool{
        if let file = Bundle.main.path(forResource: "json", ofType: "json") {
            let data = try! Data(contentsOf: URL(fileURLWithPath: file))
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
        self.downLoad.isEnabled = false
        self.downLoad.backgroundColor = UIColor.lightGray
        
    }

    //=====================================================================================================
    /**
     MARK: - 上传数据
     **/
    //=====================================================================================================
    
    //本地时只是显示，网络时才连接网络
    func controlUpData(){
        
        if self.switchBtn?.isOn == true{
            
            if checkNet() != networkType.wifi{
                textAlertView("请连接Wi-Fi进行同步")
                return
            }
            
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
        textView.backgroundColor = UIColor.white
        
        copyBtn.backgroundColor = UIColor.white
        copyBtn.isEnabled = true
        copyBtn.isHidden = false
        
        return jsonStr
    }
    
    //上传数据到服务器
    func upLoadDataToDB(_ str: String){
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
                    if code == "200"{
                        MyToastView().showToast("上传数据成功！")
                    }else{
                        let str = getErrorCodeToString(code)
                        MyToastView().showToast("\(str)")
                    }
                    
                case .Failure:
                    NetWork.networkFailed(response.response)
                    
                    print(response.response)
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
