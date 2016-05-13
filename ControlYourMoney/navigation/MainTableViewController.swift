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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.setupData()
        self.setUpTitle()
        self.calculateCredit()
        self.tableView.reloadData()
    }
    
    //获取数据
    func setupData(){
        let textData = NSMutableDictionary()
        
        //数据库读取数据
        let cashArray = SQLLine.selectAllData(entityNameOfCash)
        var creditArray = SQLLine.selectAllData(entityNameOfCredit)
        let salaryArray = SQLLine.selectAllData(entityNameOfSalary)
        
        //给textdata字典添加数据，用于table显示
        if(cashArray.count != 0){
            textData.setObject(cashArray, forKey: keyOfCash)
        }
        
        if(creditArray.count != 0){
            let time = NSSortDescriptor.init(key: creditNameOfTime, ascending: true)
            creditArray = creditArray.sortedArrayUsingDescriptors([time])
            textData.setObject(creditArray, forKey: keyOfCredit)
        }
        
        if(salaryArray.count != 0){
            textData.setObject(salaryArray, forKey: keyOfSalary)
        }
        
        initData(textData)
    }
    
    //计算数据
    func initData(data: NSMutableDictionary){
        self.AllData = NSMutableDictionary()
        let tempData = data
        
        //信用卡数据模型
        if tempData.valueForKey(keyOfCredit) != nil{
            var creditModul = [MainTableCreditModul]()
            let creditArray = tempData.valueForKey(keyOfCredit) as! NSArray
            let creditArrayCount = creditArray.count
            for i in 0 ..< creditArrayCount {
                let periods = String(creditArray.objectAtIndex(i).valueForKey(creditNameOfPeriods) as! NSInteger)
                let number = String(creditArray.objectAtIndex(i).valueForKey(creditNameOfNumber) as! Float)
                let time = dateToStringNoHH(creditArray.objectAtIndex(i).valueForKey(creditNameOfTime) as! NSDate)
                let all = "-" + String(Float(creditArray.objectAtIndex(i).valueForKey(creditNameOfPeriods) as! NSInteger) *
                    (creditArray.objectAtIndex(i).valueForKey(creditNameOfNumber) as! Float))
                let accout = creditArray.objectAtIndex(i).valueForKey(creditNameOfAccount)  as? String
                let date = String(creditArray.objectAtIndex(i).valueForKey(creditNameOfDate) as! Int)
                
                let tempCreditModul = MainTableCreditModul(periods: periods, number: number, accout: accout, all: all, time: time, date: date)
                creditModul.append(tempCreditModul)
            }
            AllData.setObject(creditModul, forKey: keyOfCredit)
        }
        
        
        //工资数据模型
        if tempData.valueForKey(keyOfSalary) != nil {
            var salaryModul = [MainTableSalaryModul]()
            let salaryArray = tempData.valueForKey(keyOfSalary) as! NSArray
            
            let date = String(dateToInt(salaryArray.lastObject!.valueForKey(salaryNameOfTime) as! NSDate, dd: "MM")) + "月" + keyOfSalary
            let number = String(salaryArray.lastObject!.valueForKey(salaryNameOfNumber) as! Float)
            let time = dateToStringNoHH(salaryArray.lastObject!.valueForKey(salaryNameOfTime) as! NSDate)
            let tempSalaryModul = MainTableSalaryModul(number: number, date: date, time: time)
            salaryModul.append(tempSalaryModul)
            AllData.setObject(salaryModul, forKey: keyOfSalary)
        }
        
        
        //现金数据模型
        if tempData.valueForKey(keyOfCash) != nil {
            var cashModul = [MainTableCashModul]()
            let cashArray = tempData.valueForKey(keyOfCash) as! NSArray
            
            let useWhere = cashArray.lastObject!.valueForKey(cashNameOfUseWhere) as? String
            let useNumber = String(cashArray.lastObject!.valueForKey(cashNameOfUseNumber) as! Float)
            let useTime = dateToString(cashArray.lastObject!.valueForKey(cashNameOfTime) as! NSDate)
            
            let useNo = cashArray.count
            var useTotal = Float()
            var useTotalDay = Float()
            
            for i in 0  ..< useNo{
                if(dateToInt(cashArray.lastObject!.valueForKey(cashNameOfTime) as! NSDate, dd: "MM") == dateToInt(cashArray.objectAtIndex(i).valueForKey(cashNameOfTime) as! NSDate, dd: "MM")){
                    useTotal = useTotal + (cashArray.objectAtIndex(i).valueForKey(cashNameOfUseNumber) as! Float)
                }
                
                if(dateToStringBySelf(cashArray.lastObject!.valueForKey(cashNameOfTime) as! NSDate, str: "yyyy-MM-dd") == dateToStringBySelf(cashArray.objectAtIndex(i).valueForKey(cashNameOfTime) as! NSDate, str: "yyyy-MM-dd")){
                    useTotalDay = useTotalDay + (cashArray.objectAtIndex(i).valueForKey(cashNameOfUseNumber) as! Float)
                }
            }
            let useTotalDayStr = String(useTotalDay)
            let useTotalStr = String(useTotal)
            let tempCashModul = MainTableCashModul(useWhere: useWhere, useNumber: useNumber, useTime: useTime, useTotalDayStr: useTotalDayStr, useTotalStr: useTotalStr)
            cashModul.append(tempCashModul)
            AllData.setObject(cashModul, forKey: keyOfCash)
        }
        
    }
    
    //title,左边按钮和右边按钮
    func setUpTitle(){
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
        
        setUpHeaderView()
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
        
        self.tableView.tableHeaderView = MainTableHeaderView(viewHeight: 120, target: self)
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
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
            let data = AllData.valueForKey(keyOfSalary)?.objectAtIndex(indexPath.row) as! MainTableSalaryModul
            
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
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if((AllData.allKeys[indexPath.section] as? String) == keyOfSalary){
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
    
    //根据时间判断信用还款
    func calculateCredit(){
        let creditAccountNumber = (SQLLine.selectAllData(entityNameOfCredit) as NSArray).count
        let calculateTime = getTime()
        for i in 0  ..< creditAccountNumber{
            
            let day : Int = getCreditDayToIntArray()[i] as! Int
            let number : Float = getCreditNumberToFloatArray()[i] as! Float
            let periods : Int = getCreditPeriodsToIntArray()[i] as! Int
            let accout : String = getCreditAccountToStringArray()[i] as! String
            let date : NSDate = getCreditTimeToNsdateArray()[i] as! NSDate
            
            if(dateToInt(date, dd: "yyyy") == dateToInt(calculateTime, dd: "yyyy")){ //同一年
                let months = dateToInt(calculateTime, dd: "MM") - dateToInt(date, dd: "MM")
                if(months == 0 && day <= dateToInt(calculateTime, dd: "dd")){ //同一月 并且 过了还款日期
                    
                    if(periods == 1){
                        SQLLine.deleteData(entityNameOfCredit, indexPath: i)
                        SQLLine.insertTotalData(getCanUseToFloat() - number, time: calculateTime)
                    }else{
                        var timeTmp = stringToDateNoHH(String(dateToInt(date, dd: "yyyy")) + "-" + String(dateToInt(date, dd: "MM") + 1) + "-" + String(day))
                        if(dateToInt(calculateTime, dd: "MM") == 12){
                            timeTmp = stringToDateNoHH(String(dateToInt(date, dd: "yyyy") + 1) + "-1-" + String(day))
                        }
                        SQLLine.updateCreditData(i, periods: periods - 1, number: number, date: day, account: accout, time: timeTmp)
                        SQLLine.insertTotalData( getCanUseToFloat() - number, time: calculateTime)
                    }
                    
                }else if(months > 0 && day <= dateToInt(calculateTime, dd: "dd")){ //月份过了还款日期 并且 日也过了还款日期
                    
                    if((months+1) >= periods){
                        SQLLine.deleteData(entityNameOfCredit, indexPath: i)
                        SQLLine.insertTotalData( getCanUseToFloat() - number * Float(periods), time:  calculateTime)
                    }else{
                        var timeTmp = stringToDateNoHH(String(dateToInt(date, dd: "yyyy")) + "-" + String(dateToInt(calculateTime, dd: "MM") + 1) + "-" + String(day))
                        if(dateToInt(calculateTime, dd: "MM") == 12){
                            timeTmp = stringToDateNoHH(String(dateToInt(date, dd: "yyyy") + 1) + "-1-" + String(day))
                        }
                        SQLLine.updateCreditData(i, periods: periods - months - 1, number: number, date: day, account: accout, time: timeTmp)
                        SQLLine.insertTotalData(getCanUseToFloat() - number * Float(months+1), time:  calculateTime)
                    }
                    
                }else if(months > 0 && day > dateToInt(calculateTime, dd: "dd")){  //月份过了还款日期 并且 日未过还款日期
                    if(months >= periods){
                        SQLLine.deleteData(entityNameOfCredit, indexPath: i)
                        SQLLine.insertTotalData( getCanUseToFloat() - number * Float(periods), time:  calculateTime)
                    }else{
                        let timeTmp = stringToDateNoHH(String(dateToInt(calculateTime, dd: "yyyy"))  + "-" + String(dateToInt(calculateTime, dd: "MM")) + "-" + String(day))
                        SQLLine.updateCreditData(i, periods: periods - months, number: number, date: day, account: accout, time: timeTmp)
                        SQLLine.insertTotalData(getCanUseToFloat() - number * Float(months), time:  calculateTime)
                    }
                }
                
            }else if(dateToInt(date, dd: "yyyy") < dateToInt(calculateTime, dd: "yyyy")){ //年过了还款日期
                let months = dateToInt(calculateTime, dd: "MM") + 12 - dateToInt(date, dd: "MM")
                if(day <= dateToInt(calculateTime, dd: "dd")){
                    if((months+1) >= periods){
                        SQLLine.deleteData(entityNameOfCredit, indexPath: i)
                        SQLLine.insertTotalData(getCanUseToFloat() - number * Float(periods), time:  calculateTime)
                    }else{
                        var timeTmp = stringToDateNoHH(String(dateToInt(calculateTime, dd: "yyyy"))  + "-" + String(dateToInt(calculateTime, dd: "MM") + 1) + "-" + String(day))
                        if((dateToInt(calculateTime, dd: "MM")) == 12){
                            timeTmp = stringToDateNoHH(String(dateToInt(calculateTime, dd: "yyyy") + 1) + "-1-" + String(day))
                        }
                        SQLLine.updateCreditData(i, periods: periods - months - 1, number: number, date: day, account: accout, time: timeTmp)
                        SQLLine.insertTotalData(getCanUseToFloat() - number * Float(months+1), time:  calculateTime)
                    }
                }else if(day > dateToInt(calculateTime, dd: "dd")){
                    if(months >= periods){
                        SQLLine.deleteData(entityNameOfCredit, indexPath: i)
                        SQLLine.insertTotalData(getCanUseToFloat() - number * Float(periods), time:  calculateTime)
                    }else{
                        let timeTmp = stringToDateNoHH(String(dateToInt(calculateTime, dd: "yyyy"))  + "-" + String(dateToInt(calculateTime, dd: "MM")) + "-" + String(day))
                        SQLLine.updateCreditData(i, periods: periods - months, number: number, date: day, account: accout, time: timeTmp)
                        SQLLine.insertTotalData(getCanUseToFloat() - number * Float(months), time:  calculateTime)
                    }
                }
            }
        }
    }
}

//选择的协议
extension MainTableViewController: bottomMenuViewDelegate{
    func buttonClicked(tag: Int, eventFlag: Int) {
        switch eventFlag{
        case 0:
            switch tag{
            case 0:
                let vc = AddCreditAccountViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = AddCreditViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            case 2:
                let vc = AddSalaryViewController()
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
