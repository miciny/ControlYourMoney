//
//  CreditDetailListViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/20.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

//=====================================================================================================
/**
 MARK: 主要用于dataAnalyse页，进入的信用详细页
 **/
//=====================================================================================================

import UIKit

class CreditDetailListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var tableView: UITableView!
    var AllData: NSMutableDictionary! //用于显示的数据，进入页面之前给定

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        setUpTitle()
    }
    
    
    //配置tableView
    func setUpTable(){
        tableView = UITableView()
        tableView.frame = CGRect(x: 0, y: 0, width: Width, height: Height)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.view.addSubview(tableView)
    }
    
    //title,左边按钮和右边按钮
    func setUpTitle(){
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
        self.title = "详细列表"
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return AllData.allKeys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //行用卡全显示，工资显示一个，记账显示一个
        return (AllData.allValues[section] as! NSArray).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if((AllData.allKeys[indexPath.section] as? String) == keyOfCash){
            let data = (AllData.value(forKey: keyOfCash) as AnyObject).object(indexPath.row) as! MainTableCashModul
            let cell = MainTableViewCell(data: data, dataType: dataTpye.cash, reuseIdentifier: "cell")
            return cell
            
        }else if((AllData.allKeys[indexPath.section] as? String) == keyOfCredit){
            let data = (AllData.value(forKey: keyOfCredit) as AnyObject).object(indexPath.row) as! MainTableCreditModul
            
            let cell = MainTableViewCell(data: data, dataType: dataTpye.credit, reuseIdentifier: "cell")
            return cell
            
        }else{ // if((textData.allKeys[indexPath.section] as? String) == keyOfSalary)
            let data = (AllData.value(forKey: keyOfIncome) as AnyObject).object(indexPath.row) as! MainTableSalaryModul
            
            let cell = MainTableViewCell(data: data, dataType: dataTpye.salary, reuseIdentifier: "cell")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if((AllData.allKeys[indexPath.section] as? String) == keyOfCash){
            return 130
            
        }else if((AllData.allKeys[indexPath.section] as? String) == keyOfCredit){
            return 130
            
        }else{ // if((textData.allKeys[indexPath.section] as? String) == keyOfSalary)
            return 90
        }
    }
    
    //cell点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView!.deselectRow(at: indexPath, animated: true)
        
        if((AllData.allKeys[indexPath.section] as? String) == keyOfCash){
            let vc = CashDetailTableViewController()
            vc.showData =  GetAnalyseDataArray.getThisMonthCashDetailShowArray()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if((AllData.allKeys[indexPath.section] as? String) == keyOfIncome){
            let vc = SalaryDetailTableViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = ChangeCreditViewController()
            let data = (AllData.value(forKey: keyOfCredit) as AnyObject).object(indexPath.row) as! MainTableCreditModul
            
            vc.recivedData = data
            vc.changeIndex = data.index
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //section的title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return AllData.allKeys[section] as? String
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
