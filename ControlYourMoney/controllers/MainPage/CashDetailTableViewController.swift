//
//  CashDetailViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/3/12.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class CashDetailTableViewController: UITableViewController {
    var textData = NSArray()
    var textDataTitle = NSMutableArray()
    var textDataDic = NSMutableDictionary()
    var textDataTotalDic = NSMutableDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitle()
        setupData()

        // Do any additional setup after loading the view.
    }
    
    func setUpTitle(){
        self.title = "记账列表"
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
    }
    
    func setupData(){
        //获取数据
        self.textData = SQLLine.selectAllData(entityNameOfCash)
        self.textDataTitle = NSMutableArray()
        self.textDataTotalDic = NSMutableDictionary()
        self.textDataDic = NSMutableDictionary()
        
        //排序
        let time = NSSortDescriptor.init(key: salaryNameOfTime, ascending: false)
        self.textData = self.textData.sortedArrayUsingDescriptors([time])
        
        //获取时间序列
        let textDataTmp = NSMutableArray()
        for i in 0 ..< self.textData.valueForKey(cashNameOfTime).count{
            textDataTmp.addObject(dateToStringBySelf(self.textData.objectAtIndex(i).valueForKey(cashNameOfTime) as! NSDate, str: "yyyy-MM"))
        }
        
        //去重,时间在同一个月的
        for i in 0 ..< textDataTmp.count{
            if(self.textDataTitle.containsObject(textDataTmp[i]) == false){
                self.textDataTitle.addObject(textDataTmp[i])
            }
        }
        
        //计算这个月总额
        textDataTmp.removeAllObjects()
        var monthTotal: Float = 0
        
        for i in 0 ..< self.textDataTitle.count{
            monthTotal = 0
            textDataTmp.removeAllObjects()
            for j in 0 ..< self.textData.count{
                if(dateToStringBySelf(self.textData.objectAtIndex(j).valueForKey(cashNameOfTime) as! NSDate, str: "yyyy-MM") == textDataTitle[i] as! String){
                    
                    let useWhere = (self.textData.objectAtIndex(j).valueForKey(cashNameOfUseWhere) as! String)
                    let useNumber = "-" + String(self.textData.objectAtIndex(j).valueForKey(cashNameOfUseNumber) as! Float)
                    let useTime = dateToString(self.textData.objectAtIndex(j).valueForKey(cashNameOfTime) as! NSDate)
                    let TempModul = CashDetailTableDataModul(useWhere: useWhere, useNumber: useNumber, useTime: useTime)
                    textDataTmp.addObject(TempModul)
                    
                    if(self.textData.objectAtIndex(j).valueForKey(cashNameOfUseNumber) as! Float > 0){
                        monthTotal = monthTotal + (self.textData.objectAtIndex(j).valueForKey(cashNameOfUseNumber) as! Float)
                    }
                }
            }
            self.textDataTotalDic.setObject(monthTotal, forKey: textDataTitle[i] as! String)
            self.textDataDic.setObject(textDataTmp.copy(), forKey: textDataTitle[i] as! String)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.textDataDic.allKeys.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.textDataDic.allValues[section] as! NSArray).count

    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let data = (self.textDataDic.allValues[indexPath.section] as! NSArray).objectAtIndex(indexPath.row) as! CashDetailTableDataModul
        let cell = MainTableViewCell(data: data, dataType: dataTpye.cashDetail, reuseIdentifier: "cell")
        cell.selectionStyle = .None
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return (self.self.textDataDic.allKeys[section] as? String)! + "(" + String(0-(self.textDataTotalDic.objectForKey(self.textDataDic.allKeys[section]) as! Float)) + ")"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
