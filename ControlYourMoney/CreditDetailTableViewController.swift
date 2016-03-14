//
//  DetailTableViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 15/12/24.
//  Copyright © 2015年 maocaiyuan. All rights reserved.
//

import UIKit
import CoreData

class CreditDetailTableViewController: UITableViewController {

    
    var textData = NSArray()
    var textDataTitle = NSMutableArray()
    var textDataDic = NSMutableDictionary()
    var textDataTotalDic = NSMutableDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitle()
        setupData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func setUpTitle(){
        self.title = "工资列表"
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
        self.tableView.rowHeight = rowHeight
        let cell = MainTableViewCell.self
        tableView.registerClass(cell, forCellReuseIdentifier: "cell")
        
    }
    
    func setupData(){
        textData = SelectAllData(entityNameOfSalary)
        let time : NSSortDescriptor = NSSortDescriptor.init(key: salaryNameOftime, ascending: false)
        textData = textData.sortedArrayUsingDescriptors([time])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return textData.count
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell : MainTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MainTableViewCell
        cell.contentView.addSubview(cell.dataLable)
        cell.contentView.addSubview(cell.dataLine)
        cell.contentView.addSubview(cell.dataNumber1)
        cell.contentView.addSubview(cell.dataNumber2)
        cell.contentView.addSubview(cell.dataNumber11)
        cell.contentView.addSubview(cell.dataNumber22)
        
        cell.dataLable.text = String(dateToInt(textData.objectAtIndex(indexPath.row).valueForKey(salaryNameOftime) as! NSDate, dd: "MM")) + "月" + keyOfSalary
        
        cell.dataNumber1.text = "金额："
        cell.dataNumber2.text = String((textData.objectAtIndex(indexPath.row)).valueForKey(salaryNameOfNumber) as! Float)
        
        cell.dataNumber11.text = "发放时间："
        cell.dataNumber22.text = dateToStringNoHH((textData.objectAtIndex(indexPath.row)).valueForKey(salaryNameOftime) as! NSDate)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
}
