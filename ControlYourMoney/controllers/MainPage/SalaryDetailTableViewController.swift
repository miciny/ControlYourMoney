//
//  DetailTableViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 15/12/24.
//  Copyright © 2015年 maocaiyuan. All rights reserved.
//

import UIKit
import CoreData

class SalaryDetailTableViewController: UITableViewController {
    
    var AllData = [SalaryDetailTableDataModul]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitle()
        setupData()
    }

    func setUpTitle(){
        self.title = "工资列表"
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
        
    }
    
    func setupData(){
        var textData = SQLLine.selectAllData(entityNameOfSalary)
        let time : NSSortDescriptor = NSSortDescriptor.init(key: salaryNameOfTime, ascending: false)
        textData = textData.sortedArrayUsingDescriptors([time])
        
        for i in 0 ..< textData.count {
            let date = String(dateToInt(textData.objectAtIndex(i).valueForKey(salaryNameOfTime) as! NSDate, dd: "MM")) + "月" + keyOfSalary
            let number = String((textData.objectAtIndex(i)).valueForKey(salaryNameOfNumber) as! Float)
            let time = dateToStringNoHH((textData.objectAtIndex(i)).valueForKey(salaryNameOfTime) as! NSDate)
            let tempModul = SalaryDetailTableDataModul(time: time, number: number, date: date)
            AllData.append(tempModul)
        }
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
        return self.AllData.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let data = self.AllData[indexPath.row]
        let cell = MainTableViewCell(data: data, dataType: dataTpye.salaryDetail, reuseIdentifier: "cell")
        cell.selectionStyle = .None
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
}
