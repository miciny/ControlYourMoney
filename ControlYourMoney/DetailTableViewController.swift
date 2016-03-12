//
//  DetailTableViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 15/12/24.
//  Copyright © 2015年 maocaiyuan. All rights reserved.
//

import UIKit
import CoreData

class DetailTableViewController: UITableViewController {
    
    var tableviewType = 0
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
        switch tableviewType{
        case 0:
            self.title = "工资列表"
        case 1:
            self.title = "记账列表"
        default:
            break
        }
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
        self.tableView.rowHeight = rowHeight
        let cell = MainTableViewCell.self
        tableView.registerClass(cell, forCellReuseIdentifier: "cell")
        
    }
    
    func setupData(){
        switch tableviewType{
        case 0:
            textData = SelectAllData(entityNameOfSalary)
            let time : NSSortDescriptor = NSSortDescriptor.init(key: salaryNameOftime, ascending: false)
            textData = textData.sortedArrayUsingDescriptors([time])
        case 1:
            textData = SelectAllData(entityNameOfCash)
            let time : NSSortDescriptor = NSSortDescriptor.init(key: salaryNameOftime, ascending: false)
            textData = textData.sortedArrayUsingDescriptors([time])
            let textDataTmp = NSMutableArray()
            for(var i = 0; i < textData.valueForKey(cashNameOfTime).count; i++){
                textDataTmp.addObject(dateToStringBySelf(textData.objectAtIndex(i).valueForKey(cashNameOfTime) as! NSDate, str: "yyyy-MM"))
            }
            for(var i = 0; i < textDataTmp.count; i++){
                if(textDataTitle.containsObject(textDataTmp[i]) == false){
                    textDataTitle.addObject(textDataTmp[i])
                }
            }
            textDataTmp.removeAllObjects()
            
            var monthTotal : Float = 0
            for(var i = 0; i < textDataTitle.count; i++){
                monthTotal = 0
                textDataTmp.removeAllObjects()
                for(var j = 0; j < textData.count; j++){
                    if(dateToStringBySelf(textData.objectAtIndex(j).valueForKey(cashNameOfTime) as! NSDate, str: "yyyy-MM") == textDataTitle[i] as! String){
                        textDataTmp.addObject(textData.objectAtIndex(j))
                        if(textData.objectAtIndex(j).valueForKey(cashNameOfUseNumber) as! Float > 0){
                            monthTotal = monthTotal + (textData.objectAtIndex(j).valueForKey(cashNameOfUseNumber) as! Float)
                        }
                    }
                }
                textDataTotalDic.setObject(monthTotal, forKey: textDataTitle[i] as! String)
                textDataDic.setObject(textDataTmp.copy(), forKey: textDataTitle[i] as! String)
            }

        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        switch tableviewType{
        case 0:
            return 1
        case 1:
            return textDataDic.allKeys.count
        default:
            return 1
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch tableviewType{
        case 0:
            return textData.count
        case 1:
            return (textDataDic.allValues[section] as! NSArray).count
        default:
            return textData.count
        }
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell : MainTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MainTableViewCell
        
        // Configure the cell...
        
        switch tableviewType{
        case 0:
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
            

        case 1:
            cell.contentView.addSubview(cell.dataLable)
            cell.contentView.addSubview(cell.dataLine)
            cell.contentView.addSubview(cell.dataNumber1)
            cell.contentView.addSubview(cell.dataNumber2)
            cell.contentView.addSubview(cell.dataNumber11)
            cell.contentView.addSubview(cell.dataNumber22)
            
            cell.dataLable.text = ((textDataDic.allValues[indexPath.section] as! NSArray).objectAtIndex(indexPath.row).valueForKey(cashNameOfUseWhere) as! String)
            
            cell.dataNumber1.text = "金额："
            if((textDataDic.allValues[indexPath.section] as! NSArray).objectAtIndex(indexPath.row).valueForKey(cashNameOfUseNumber) as! Float > 0){
                cell.dataNumber2.text = "-" + String((textDataDic.allValues[indexPath.section] as! NSArray).objectAtIndex(indexPath.row).valueForKey(cashNameOfUseNumber) as! Float)
            }else{
                cell.dataNumber2.text = "+" + String(0-((textDataDic.allValues[indexPath.section] as! NSArray).objectAtIndex(indexPath.row).valueForKey(cashNameOfUseNumber) as! Float))
            }
            
            
            cell.dataNumber11.text = "时间："
            cell.dataNumber22.text = dateToString((textDataDic.allValues[indexPath.section] as! NSArray).objectAtIndex(indexPath.row).valueForKey(cashNameOfTime) as! NSDate)
        default:
            break
        }
                return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch tableviewType{
        case 0:
            return nil
        case 1:
            return (textDataDic.allKeys[section] as? String)! + "(" + String(0-(textDataTotalDic.objectForKey(textDataDic.allKeys[section]) as! Float)) + ")"
        default:
            return nil
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
