//
//  AdvanceSettingViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/6/2.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class AdvanceSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate{
    private var mainTabelView: UITableView? //整个table
    private var settingData : NSMutableArray? //数据

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitle()
        setData()
        setUpTable()
        // Do any additional setup after loading the view.
    }
    
    func setUpTitle(){
        self.title = "高级设置"
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
    }
    
    //设置数据
    func setData(){
        settingData = NSMutableArray()
        
        let settingOne = SettingDataModul(icon: nil, name: "清空本地数据", lable: nil, pic: nil)
        
        settingData?.addObject([settingOne])
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
    
    //一个section头部的高度
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    //选择了row
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        mainTabelView!.deselectRowAtIndexPath(indexPath, animated: true)  //被选择后，会变灰，这么做还原
        switch indexPath.section{
        case 0:
            switch indexPath.row {
            case 0: //清空本地数据
                let localAlert = UIAlertView(title: "清空本地数据？", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
                localAlert.tag = 0
                localAlert.show()
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
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator  //显示后面的小箭头
        
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
                deleteAllData()
            }
        default:
            break
        }
    }
    
    func deleteAllData(){
        var array = Cash.selectAllData()
        if array.count > 0 {
            for _ in 0 ..< array.count{
                Cash.deleteData(0)
            }
        }
        
        array = PayName.selectAllData()
        if array.count > 0 {
            for _ in 0 ..< array.count{
                PayName.deleteData(0)
            }
        }
        
        array = Credit.selectAllData()
        if array.count > 0 {
            for _ in 0 ..< array.count{
                Credit.deleteData(0)
            }
        }
        
        array = CreditAccount.selectAllData()
        if array.count > 0 {
            for _ in 0 ..< array.count{
                CreditAccount.deleteData(0)
            }
        }
        
        array = Salary.selectAllData()
        if array.count > 0 {
            for _ in 0 ..< array.count{
                Salary.deleteData(0)
            }
        }
        
        array = IncomeName.selectAllData()
        if array.count > 0 {
            for _ in 0 ..< array.count{
                IncomeName.deleteData(0)
            }
        }
        
        array = Total.selectAllData()
        if array.count > 0 {
            for _ in 0 ..< array.count{
                Total.deleteData(0)
            }
        }
        
        array = Cost.selectAllData()
        if array.count > 0 {
            for _ in 0 ..< array.count{
                Cost.deleteData(0)
            }
        }
        
        let toast = MyToastView()
        toast.showToast("删除成功！")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}