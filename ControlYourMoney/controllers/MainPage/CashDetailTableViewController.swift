//
//  CashDetailViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/3/12.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class CashDetailTableViewController: UITableViewController {
    var showData: [NSMutableDictionary]?  //传入的数据，根据传入的数据显示cell 和 title
    
    private var textDataDic = NSMutableDictionary() //cell显示的数据
    private var textDataTotalDic = NSMutableDictionary() //每月显示的总额

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitle()
        setupData()

        // Do any additional setup after loading the view.
    }
    
    //设置title 等
    func setUpTitle(){
        self.title = "记账列表"
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
    }
    
    //获取数据
    func setupData(){
        self.textDataTotalDic = NSMutableDictionary()
        self.textDataDic = NSMutableDictionary()
        
        self.textDataDic = showData![0]
        self.textDataTotalDic = showData![1]
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.textDataDic.allKeys.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.textDataDic.allValues[section] as! NSArray).count

    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let data = (self.textDataDic.allValues[indexPath.section] as! NSArray).objectAtIndex(indexPath.row) as! CashDetailTableDataModul
        let cell = MainTableViewCell(data: data, dataType: dataTpye.cashDetail, reuseIdentifier: "cell")
        cell.selectionStyle = .None
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (self.self.textDataDic.allKeys[section] as? String)! + "(" + String(0-(self.textDataTotalDic.objectForKey(self.textDataDic.allKeys[section]) as! Float)) + ")"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
