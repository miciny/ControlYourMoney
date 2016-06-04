//
//  TableViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 15/12/18.
//  Copyright © 2015年 maocaiyuan. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController, mainHeaderChangeLastDelegate{
    
    var AllData: NSMutableArray!  //页面显示的data
    var headerView: MainTableHeaderView? //头图
    var isCounting = false  //正在计算
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTitle()
        self.setUpData()
    }
    
    override func viewWillAppear(animated: Bool) {
        if isCounting {
            return
        }
        
        let MainPageQueue: dispatch_queue_t = dispatch_queue_create("MainPageQueue", DISPATCH_QUEUE_SERIAL)
        dispatch_async(MainPageQueue) {
            self.isCounting = true
            self.setUpData()
            self.setUpHeaderView()
            
            dispatch_async(mainQueue, {
                self.isCounting = false
                self.tableView.reloadData()
            })
        }
    }
    
    //获取数据
    func setUpData(){
        AllData = NSMutableArray()
        
        let creditModul =  GetDataArray.getCreditShowArray()
        let salaryModul =  GetDataArray.getSalaryShowArray()
        let cashModul =  GetDataArray.getCashShowArray()
        
        
        if cashModul != nil {
            AllData.addObject([keyOfCash: cashModul!])
        }
        if creditModul != nil {
            AllData.addObject([keyOfCredit: creditModul!])
        }
        if salaryModul != nil {
            AllData.addObject([keyOfIncome: salaryModul!])
        }
    }
    
    //title,左边按钮和右边按钮
    func setUpTitle(){
        AllData = NSMutableArray()
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
        
        self.title = "首页"
        self.navigationItem.title = mainViewTitle
        
        let addItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(MainTableViewController.Add))
        self.navigationItem.rightBarButtonItem = addItem
        
        let addItemFast = UIBarButtonItem(title: "记账", style: .Plain, target: self, action:
            #selector(MainTableViewController.AddFast))
        self.navigationItem.leftBarButtonItem = addItemFast
        
        let backItem = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
    }
    
    //弹出添加的actionView
    func Add(){
        let bottomMenu = MyBottomMenuView()
        bottomMenu.showBottomMenu("选择添加类型", cancel: "取消", object: addArray,eventFlag: 0 , target: self)
    }
    
    //右上角快速记账的按钮
    func AddFast(){
        let vc = AddCashViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //table顶部，用于显示总金额 可用和应还
    func setUpHeaderView(){
        if headerView == nil {
            headerView = MainTableHeaderView(viewHeight: 120, target: self)
            self.tableView.tableHeaderView = headerView
            self.tableView.tableFooterView = UIView(frame: CGRectZero)
        }else{
            headerView?.setUpData()
        }
        
    }
    
    //进入改剩余用额的页面
    func buttonClicked(lastStr: String) {
        let vc = ChangeLastViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.lastStr = lastStr
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //=====================================================================================================
    /**
     MARK: - Table view data source
    **/
    //=====================================================================================================

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return AllData.count
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard AllData.count > 0 else{
            return 0
        }
        
        //行用卡全显示，工资显示一个，记账显示一个
        let dic = AllData[section] as! NSDictionary
        let key = dic.allKeys[0] as! String
        let values = dic.valueForKey(key) as! NSArray
        return values.count
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard AllData.count > 0 else{
            let cell = UITableViewCell(frame: CGRectZero)
            return cell
        }
        
        let dic = AllData[indexPath.section] as! NSDictionary
        let key = dic.allKeys[0] as! String
        let values = dic.valueForKey(key) as! NSArray
        
        if(key == keyOfCash){
            let data = values.objectAtIndex(indexPath.row) as! MainTableCashModul
            let cell = MainTableViewCell(data: data, dataType: dataTpye.cash, reuseIdentifier: "cell")
            return cell
            
        }else if(key == keyOfCredit){
            let data = values.objectAtIndex(indexPath.row) as! MainTableCreditModul
            
            let cell = MainTableViewCell(data: data, dataType: dataTpye.credit, reuseIdentifier: "cell")
            return cell
            
        }else{ // if(key == keyOfSalary)
            let data = values.objectAtIndex(indexPath.row) as! MainTableSalaryModul
            
            let cell = MainTableViewCell(data: data, dataType: dataTpye.salary, reuseIdentifier: "cell")
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        guard AllData.count > 0 else{
            return 0
        }
        
        let dic = AllData[indexPath.section] as! NSDictionary
        let key = dic.allKeys[0] as! String
        if(key == keyOfCash){
            return 130
            
        }else if(key == keyOfCredit){
            return 130
            
        }else{ // if(key == keyOfSalary)
            return 90
        }
    }
    
    
    //cell点击事件
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)
        let dic = AllData[indexPath.section] as! NSDictionary
        let key = dic.allKeys[0] as! String
        
        if(key == keyOfCash){
            let vc = CashDetailTableViewController()
            vc.showData =  GetDataArray.getCashDetailShowArray()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if(key == keyOfIncome){
            let vc = SalaryDetailTableViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let values = dic.valueForKey(key) as! NSArray
            let vc = ChangeCreditViewController()
            vc.hidesBottomBarWhenPushed = true
            let data = values.objectAtIndex(indexPath.row) as! MainTableCreditModul
            
            vc.recivedData = data
            vc.changeIndex = data.index
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //section的title
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard AllData.count > 0 else{
            return nil
        }
        
        let dic = AllData[section] as! NSDictionary
        let key = dic.allKeys[0] as! String
        return key
    }
}

//actionView选择的协议
extension MainTableViewController: bottomMenuViewDelegate{
    func buttonClicked(tag: Int, eventFlag: Int) {
        switch eventFlag{
        case 0:
            switch tag{
            case 0:
                let vc = AddCreditViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = AddIncomeViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        default:
            break
        }
    }
}
