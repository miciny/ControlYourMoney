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
    let upWiatView = MyWaitToast() //toast
    let downWiatView = MyWaitToast()
    
    var syncBaseURL = "http://10.69.9.17:8181/api/sync"
    var switchBtn: UISwitch? //网络下载数据开关
    var netManager: Manager?
    
    var json: JSON = JSON.null //保存下载的数据

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitle()
        initNetManager()
        setData()
        setUpTable()
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
        
        let settingOne = SettingDataModul(icon: nil, name: "网络下载数据")
        let settingTwo1 = SettingDataModul(icon: nil, name: "IP地址", lable: "10.69.9.17", pic: nil)
        let settingTwo2 = SettingDataModul(icon: nil, name: "端口", lable: "8181", pic: nil)
        
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
            }
        case 1:
            if buttonIndex == 1 {
                
                let section : NSArray =  self.settingData![1] as! NSArray
                let data = section[1] as! SettingDataModul
                
                let text = alertView.textFieldAtIndex(0)!.text
                
                data.lable = text
                
                let indexPath = NSIndexPath(forRow: 1, inSection: 1)
                mainTabelView?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
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
        let toast = MyToastView()
        guard let str = textView.text where str != "" else{
            toast.showToast("无数据")
            return
        }
        
        UIPasteboard.generalPasteboard().string = str
        toast.showToast("复制成功")
    }
    
    //获得url
    func getURL(){
        let section : NSArray =  self.settingData![1] as! NSArray
        let ipData = section[0] as! SettingDataModul
        let portData = section[1] as! SettingDataModul
        syncBaseURL = "http://\(ipData.lable! as String):\(portData.lable! as String)/api/sync"
        
        print(syncBaseURL)
    }
    
    //=====================================================================================================
    /**
     MARK: - 下载数据
     **/
    //=====================================================================================================
    
    func initNetManager(){
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 15 //超时时间
        netManager = Alamofire.Manager(configuration: configuration)
    }
    
    //下载数据，就是导入数据到数据库
    func downLoadData(){
        if (self.switchBtn?.on == true) {
            getURL()
            downWiatView.title = "下载中..."
            downWiatView.showWait(self.view)
            downWiatView.showNetIndicator()
            
            self.downloadDataFromDB()
        }else{
            let localAlert = UIAlertView(title: "从本地导入？", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
            localAlert.tag = 2
            localAlert.show()
        }
    }
    
    //下载数据 必须使用https
    
//    在Info.plist中添加NSAppTransportSecurity类型Dictionary。
//    在NSAppTransportSecurity下添加NSAllowsArbitraryLoads类型Boolean,值设为YES
    
    func downloadDataFromDB(){
        let paras = ["name": "111", "token": "111", "time": "111"]
        
        netManager!.request(.GET, syncBaseURL, parameters: paras)
            .responseJSON { response in
                let toast = MyToastView()
                
                switch response.result{
                    
                case .Success:
                    self.json = JSON(response.result.value!)
                    self.insertData()
                    
                case .Failure:
                    self.downWiatView.hideView()
                    
                    if response.response == nil{
                        toast.showToast("无法连接服务器！")
                    }else{
                        toast.showToast("下载数据失败！")
                    }
                    
                    print(response.response)
                }
        }
    }
    
    //下载数据
    func downloadDataFromJsonFile() -> Bool{
        if let file = NSBundle.mainBundle().pathForResource("json", ofType: "json") {
            let data = NSData(contentsOfFile: file)!
            json = JSON(data: data)
            
            insertData()
            
            return true
        }else{
            self.downWiatView.hideView()
            let toast = MyToastView()
            toast.showToast("导入数据失败！")
            return false
        }
    }
    
    
    //
    func insertData(){
        
        let cashDic = json[entityNameOfCash]
        InsertData.insertCashData(cashDic)
        
        let incomeDic = json[entityNameOfIncome]
        InsertData.insertIncomeData(incomeDic)
        
        let incomeNameDic = json[entityNameOfIncomeName]
        InsertData.insertIncomeNameData(incomeNameDic)
        
        let costDic = json[entityNameOfCost]
        InsertData.insertCostData(costDic)
        
        let totalDic = json[entityNameOfTotal]
        InsertData.insertTotalData(totalDic)
        
        let payNameDic = json[entityNameOfPayName]
        InsertData.insertPayNameData(payNameDic)
        
        let creditAccountDic = json[entityNameOfCreditAccount]
        InsertData.insertCreditAccountData(creditAccountDic)
        
        let creditDic = json[entityNameOfCredit]
        InsertData.insertCreditData(creditDic)
        
        self.downWiatView.hideView()
        
        let toast = MyToastView()
        toast.showToast("导入数据成功！")
        
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
            getURL()
            upWiatView.title = "上传中..."
            upWiatView.showWait(self.view)
            upWiatView.showNetIndicator()
            
            let jsonStr = self.upLoadData()
            self.upLoadDataToDB(jsonStr) //上传数据到服务器
        }else{
            self.upLoadData()
        }
        
    }
    
    //上传数据
    func upLoadData() -> String{
        
        let allDic = NSMutableDictionary()
        allDic.setValue(DataToArray.setCashDataToArray(), forKey: entityNameOfCash)
        allDic.setValue(DataToArray.setCostDataToArray(), forKey: entityNameOfCost)
        allDic.setValue(DataToArray.setCreditAccountDataToArray(), forKey: entityNameOfCreditAccount)
        allDic.setValue(DataToArray.setCreditDataToArray(), forKey: entityNameOfCredit)
        allDic.setValue(DataToArray.setIncomeDataToArray(), forKey: entityNameOfIncome)
        allDic.setValue(DataToArray.setIncomeNameDataToArray(), forKey: entityNameOfIncomeName)
        allDic.setValue(DataToArray.setPayNameDataToArray(), forKey: entityNameOfPayName)
        allDic.setValue(DataToArray.setTotalDataToArray(), forKey: entityNameOfTotal)
    
        let jsonStr = dicToJson(allDic)
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
        
        let paras = [
            "data": strToJson(str)
        ]
        
        netManager!.request(.POST, syncBaseURL, parameters: paras, encoding: .JSON)
            .responseJSON { response in
                let toast = MyToastView()
                
                switch response.result{
                    
                case .Success:
                    let code = String((response.response?.statusCode)!)
                    let a = code.substringToIndex(code.startIndex.advancedBy(1))
                    self.upWiatView.hideView()
                    
                    if a == "2"{
                        toast.showToast("上传数据成功！")
                    }else{
                        toast.showToast("数据有误，不影响！")
                    }
                    
                case .Failure:
                    self.upWiatView.hideView()
                    if response.response == nil{
                        toast.showToast("无法连接服务器！")
                    }else{
                        toast.showToast("上传数据失败！")
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
