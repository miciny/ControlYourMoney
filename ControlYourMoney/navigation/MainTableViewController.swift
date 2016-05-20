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
    
    var AllData: NSMutableDictionary!
    let keyOfCash = "记账"
    let keyOfCredit = "信用"
    let keyOfIncome = "收入"
    var headerView: MainTableHeaderView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTitle()
    }
    
    override func viewWillAppear(animated: Bool) {
        CalculateCredit.calculateCredit()
        self.setUpData()
        setUpHeaderView()
        self.tableView.reloadData()
    }
    
    //获取数据
    func setUpData(){
        AllData = NSMutableDictionary()
        let creditModul =  GetDataArray.getCreditShowArray()
        let salaryModul =  GetDataArray.getSalaryShowArray()
        let cashModul =  GetDataArray.getCashShowArray()
        
        if creditModul != nil {
            AllData.setObject(creditModul!, forKey: keyOfCredit)
        }
        if salaryModul != nil {
            AllData.setObject(salaryModul!, forKey: keyOfIncome)
        }
        if cashModul != nil {
            AllData.setObject(cashModul!, forKey: keyOfCash)
        }
    }
    
    //title,左边按钮和右边按钮
    func setUpTitle(){
        AllData = NSMutableDictionary()
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

    
    // MARK: - Table view data source
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return AllData.allKeys.count
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //行用卡全显示，工资显示一个，记账显示一个
        return (AllData.allValues[section] as! NSArray).count
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if((AllData.allKeys[indexPath.section] as? String) == keyOfCash){
            let data = AllData.valueForKey(keyOfCash)?.objectAtIndex(indexPath.row) as! MainTableCashModul
            let cell = MainTableViewCell(data: data, dataType: dataTpye.cash, reuseIdentifier: "cell")
            return cell
            
        }else if((AllData.allKeys[indexPath.section] as? String) == keyOfCredit){
            let data = AllData.valueForKey(keyOfCredit)?.objectAtIndex(indexPath.row) as! MainTableCreditModul
            
            let cell = MainTableViewCell(data: data, dataType: dataTpye.credit, reuseIdentifier: "cell")
            return cell
            
        }else{ // if((textData.allKeys[indexPath.section] as? String) == keyOfSalary)
            let data = AllData.valueForKey(keyOfIncome)?.objectAtIndex(indexPath.row) as! MainTableSalaryModul
            
            let cell = MainTableViewCell(data: data, dataType: dataTpye.salary, reuseIdentifier: "cell")
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if((AllData.allKeys[indexPath.section] as? String) == keyOfCash){
            return 130
            
        }else if((AllData.allKeys[indexPath.section] as? String) == keyOfCredit){
            return 130
            
        }else{ // if((textData.allKeys[indexPath.section] as? String) == keyOfSalary)
            return 90
        }
    }
    
    
    //cell点击事件
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)
        
        if((AllData.allKeys[indexPath.section] as? String) == keyOfCash){
            let vc = CashDetailTableViewController()
            vc.showData =  GetDataArray.getCashDetailShowArray()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if((AllData.allKeys[indexPath.section] as? String) == keyOfIncome){
            let vc = SalaryDetailTableViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = ChangeCreditViewController()
            vc.hidesBottomBarWhenPushed = true
            let data = AllData.valueForKey(keyOfCredit)?.objectAtIndex(indexPath.row) as! MainTableCreditModul
            
            vc.recivedData = data
            vc.changeIndex = indexPath.row
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //section的title
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return AllData.allKeys[section] as? String
    }
}

//选择的协议
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
