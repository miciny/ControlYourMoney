//
//  TableViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 15/12/18.
//  Copyright © 2015年 maocaiyuan. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    let totalLable = UILabel()
    let lastLable = UILabel()
    let shouldPay = UILabel()
    let shouldPayText = UILabel()
    let totalText = UILabel()
    let lastText = UILabel()
    var shouldPayType = 0
    var total : NSString = "0.00"
    var canUse : NSString = "0.00"
    var tableHeaderView = UIView()
    var textData = NSMutableDictionary()
    
    var creditTotal : Float = 0 //所有信用

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        totalLable.text = ""
        lastLable.text = ""
        shouldPay.text = ""
        shouldPayText.text = ""
        totalText.text = ""
        lastText.text = ""
        setupData()
        setUpTitle()
        setUpTable()
        calculateCredit()
        self.tableView.reloadData()
    }
    
    func setupData(){
        creditTotal=0
        let timeNow = getTime() //当前时间
        textData.removeAllObjects()
        let cashArray = SelectAllData(entityNameOfCash)
        
        //给textdata字典添加数据，用于table显示
        if(cashArray.count != 0){
            textData.setObject(cashArray, forKey: keyOfCash)
        }
        var creditArray = SelectAllData(entityNameOfCredit)
        if(creditArray.count != 0){
            let time : NSSortDescriptor = NSSortDescriptor.init(key: creditNameOfTime, ascending: true)
            creditArray = creditArray.sortedArrayUsingDescriptors([time])
            textData.setObject(creditArray, forKey: keyOfCredit)
        }
        let salaryArray = SelectAllData(entityNameOfSalary)
        if(salaryArray.count != 0){
            textData.setObject(salaryArray, forKey: keyOfSalary)
        }
        
        //显示本月应还／下月应还金额
        //无需判断本月还款已过的，因为过了之后，会自动到下个月
        var shouldPayData : Float = 0 //显示 本月应还 还是 下月应还 的flag， 1为本月 0为下月
        let creditTimeArray = creditArray.valueForKey(creditNameOfTime) as! NSArray
        let creditNumberArray = creditArray.valueForKey(creditNameOfNumber) as! NSArray
        let creditPeriodArray = creditArray.valueForKey(creditNameOfPeriods) as! NSArray
        let MM = dateToInt(timeNow, dd: "MM")
        for(var i = 0 ; i < creditTimeArray.count ; i++){
            if(MM == dateToInt(creditTimeArray[i] as! NSDate, dd: "MM")){ //有一个月份与现月相同，则为本月
                shouldPayType = 1
                break
            }else{
                shouldPayType = 0
            }
        }
        if(shouldPayType == 1){
            for(var i = 0 ; i < creditTimeArray.count ; i++){
                if(MM == dateToInt(creditTimeArray[i] as! NSDate, dd: "MM")){
                    shouldPayData = shouldPayData + (creditNumberArray[i] as! Float)
                }
            }
        }else{
            for(var i = 0 ; i < creditTimeArray.count ; i++){
                if(MM == 12){
                    if(dateToInt(creditTimeArray[i] as! NSDate, dd: "MM") == 1){
                        shouldPayData = shouldPayData + (creditNumberArray[i] as! Float)
                    }
                }else{
                    if(dateToInt(creditTimeArray[i] as! NSDate, dd: "MM") == MM + 1){
                        shouldPayData = shouldPayData + (creditNumberArray[i] as! Float)
                    }
                }
            }
        }
        
        for(var i = 0 ; i < creditTimeArray.count ; i++){
            creditTotal = creditTotal - (creditPeriodArray[i] as! Float)*(creditNumberArray[i] as! Float)
        }
        
        //显示总金额，可用和应还
        total = String(creditTotal + getCanUseToFloat())
        canUse = String(getCanUseToFloat())
        
        totalLable.text = total as String
        lastLable.text = canUse as String
        shouldPay.text = String(shouldPayData)
    }
    
    //title,左边按钮和右边按钮
    func setUpTitle(){
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
        self.title = mainViewTitle
        let addItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "Add")
        self.navigationItem.rightBarButtonItem = addItem
        let addItemFast = UIBarButtonItem(title: "记账", style: .Plain, target: self, action: "AddFast")
        self.navigationItem.leftBarButtonItem = addItemFast
        let backItem = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        setUpHeaderView()
    }

    //点击可用金额的label，跳转到改可用金额页面
    func changeLast(){
        self.navigationController?.pushViewController(ChangeLastViewController(), animated: true)
    }
    
    //弹出添加的actionView
    func Add(){
        let bottomMenu = MyBottomMenuView()
        bottomMenu.showBottomMenu("选择添加类型", cancel: "取消", object: addArray,eventFlag: 0 , target: self)
    }
    
    //右上角快速记账的按钮
    func AddFast(){
        let vc = AddCashViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //table顶部，用于显示总金额 可用和应还
    func setUpHeaderView(){
        tableHeaderView.frame = CGRectMake(0, 0, self.tableView.frame.width , rowHeight)
        tableHeaderView.backgroundColor = UIColor.whiteColor()
        totalLable.frame = CGRectMake(self.tableView.frame.width/2 + 10, 0, self.tableView.frame.width/2  - 50 , rowHeight/3)
        totalLable.textAlignment = NSTextAlignment.Right
        totalLable.font = UIFont(name: "HelveticaNeue-Light", size: 24.0)
        totalLable.textColor = UIColor.redColor()
        
        totalText.frame = CGRectMake(20, 0, self.tableView.frame.width/2 - 50 , rowHeight/3)
        totalText.textAlignment = NSTextAlignment.Left
        totalText.font = UIFont(name: "HelveticaNeue-Light", size: 24.0)
        totalText.textColor = UIColor.redColor()
        totalText.text = "财产："
        
        lastLable.frame = CGRectMake(self.tableView.frame.width/2 + 10, rowHeight/3, self.tableView.frame.width/2 - 50 , rowHeight/3)
        lastLable.textAlignment = NSTextAlignment.Right
        lastLable.font = UIFont(name: "HelveticaNeue-Light", size: 20.0)
        lastLable.userInteractionEnabled = true
        let tap1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "changeLast")
        lastLable.addGestureRecognizer(tap1)
        lastLable.textColor = UIColor.blueColor()
        
        lastText.frame = CGRectMake(20, rowHeight/3, self.tableView.frame.width/2 - 50 , rowHeight/3)
        lastText.textAlignment = NSTextAlignment.Left
        lastText.font = UIFont(name: "HelveticaNeue-Light", size: 20.0)
        lastText.textColor = UIColor.blueColor()
        lastText.text = "可用："
        
        shouldPay.frame = CGRectMake(self.tableView.frame.width/2 + 10, rowHeight*2/3, self.tableView.frame.width/2 - 50 , rowHeight/3)
        shouldPay.textAlignment = NSTextAlignment.Right
        shouldPay.font = UIFont(name: "HelveticaNeue-Light", size: 20.0)
        shouldPay.textColor = UIColor.blueColor()
        
        shouldPayText.frame = CGRectMake(20, rowHeight*2/3, self.tableView.frame.width/2 - 50 , rowHeight/3)
        shouldPayText.textAlignment = NSTextAlignment.Left
        shouldPayText.font = UIFont(name: "HelveticaNeue-Light", size: 20.0)
        shouldPayText.textColor = UIColor.blueColor()
        if(shouldPayType == 0){
            shouldPayText.text = "下月应还："
        }else{
            shouldPayText.text = "本月应还："
        }
        
        
        self.tableHeaderView.addSubview(totalLable)
        self.tableHeaderView.addSubview(totalText)
        self.tableHeaderView.addSubview(lastLable)
        self.tableHeaderView.addSubview(lastText)
        self.tableHeaderView.addSubview(shouldPay)
        self.tableHeaderView.addSubview(shouldPayText)
        self.tableView.tableHeaderView = tableHeaderView
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    //注册cell cell的高度
    func setUpTable(){
        let cell = MainTableViewCell.self
        tableView.registerClass(cell, forCellReuseIdentifier: "cell")
        tableView.rowHeight = rowHeight
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return textData.allKeys.count
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if((textData.allKeys[section] as? String) == keyOfCash){
            return 1
        }else if((textData.allKeys[section] as? String) == keyOfSalary){
            return 1
        }else{
            return (textData.allValues[section] as! NSArray).count
        }
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : MainTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MainTableViewCell
        
        // Configure the cell...
        
        cell.contentView.addSubview(cell.dataLable)
        cell.contentView.addSubview(cell.dataLine)
        cell.contentView.addSubview(cell.dataNumber1)
        cell.contentView.addSubview(cell.dataNumber2)
        cell.contentView.addSubview(cell.dataNumber11)
        cell.contentView.addSubview(cell.dataNumber22)
        cell.contentView.addSubview(cell.dataNumber111)
        cell.contentView.addSubview(cell.dataNumber222)
        cell.contentView.addSubview(cell.dataNumber1111)
        cell.contentView.addSubview(cell.dataNumber2222)
        
        if((textData.allKeys[indexPath.section] as? String) == keyOfCash){
            
            cell.dataLable.text = (textData.allValues[indexPath.section] as! NSArray).lastObject!.valueForKey(cashNameOfUseWhere) as? String
            
            
            cell.dataNumber1.text = "金额："
            if((textData.allValues[indexPath.section] as! NSArray).lastObject!.valueForKey(cashNameOfUseNumber) as! Float > 0){
                cell.dataNumber2.text = "-" + String((textData.allValues[indexPath.section] as! NSArray).lastObject!.valueForKey(cashNameOfUseNumber) as! Float)
            }else{
                cell.dataNumber2.text = "+" + String(0-((textData.allValues[indexPath.section] as! NSArray).lastObject!.valueForKey(cashNameOfUseNumber) as! Float))
            }
            
            
            cell.dataNumber11.text = "时间："
            cell.dataNumber22.text = dateToString((textData.allValues[indexPath.section] as! NSArray).lastObject!.valueForKey(cashNameOfTime) as! NSDate)
            
            let useNo = (textData.allValues[indexPath.section] as! NSArray).count
            var useTotal = Float()
            for(var i = 0 ; i < useNo; i++){
                if(dateToInt((textData.allValues[indexPath.section] as! NSArray).lastObject!.valueForKey(cashNameOfTime) as! NSDate, dd: "MM") == dateToInt((textData.allValues[indexPath.section] as! NSArray).objectAtIndex(i).valueForKey(cashNameOfTime) as! NSDate, dd: "MM")){
                    useTotal = useTotal + ((textData.allValues[indexPath.section] as! NSArray).objectAtIndex(i).valueForKey(cashNameOfUseNumber) as! Float)
                }
            }
            
            var useTotalDay = Float()
            for(var i = 0 ; i < useNo; i++){
                if(dateToStringBySelf((textData.allValues[indexPath.section] as! NSArray).lastObject!.valueForKey(cashNameOfTime) as! NSDate, str: "yyyy-MM-dd") == dateToStringBySelf((textData.allValues[indexPath.section] as! NSArray).objectAtIndex(i).valueForKey(cashNameOfTime) as! NSDate, str: "yyyy-MM-dd")){
                    useTotalDay = useTotalDay + ((textData.allValues[indexPath.section] as! NSArray).objectAtIndex(i).valueForKey(cashNameOfUseNumber) as! Float)
                }
            }
            
            cell.dataNumber111.text =  String(dateToInt((textData.allValues[indexPath.section] as! NSArray).lastObject!.valueForKey(cashNameOfTime) as! NSDate, dd: "dd")) + "日总额："
            if(useTotalDay > 0){
                cell.dataNumber222.text = "-" + String(useTotalDay)
            }else{
                cell.dataNumber222.text = "+" + String(0-useTotalDay)
            }
            
            
            cell.dataNumber1111.text = String(dateToInt((textData.allValues[indexPath.section] as! NSArray).lastObject!.valueForKey(cashNameOfTime) as! NSDate, dd: "MM")) + "月总额："
            if(useTotal>0){
                cell.dataNumber2222.text = "-" + String(useTotal)
            }else{
                cell.dataNumber2222.text = "+" + String(0-useTotal)
            }
            
        }
        
        if((textData.allKeys[indexPath.section] as? String) == keyOfCredit){
            
            cell.dataLable.text = (textData.allValues[indexPath.section] as! NSArray).objectAtIndex(indexPath.row).valueForKey(creditNameOfAccount)  as? String
            
            cell.dataNumber1.text = "还款周期："
            cell.dataNumber2.text = String((textData.allValues[indexPath.section] as! NSArray).objectAtIndex(indexPath.row).valueForKey(creditNameOfPeriods) as! NSInteger)
            
            cell.dataNumber11.text = "每期还款金额："
            cell.dataNumber22.text = "-" + String((textData.allValues[indexPath.section] as! NSArray).objectAtIndex(indexPath.row).valueForKey(creditNameOfNumber) as! Float)
            
            cell.dataNumber111.text = "下期还款时间："
            cell.dataNumber222.text = dateToStringNoHH((textData.allValues[indexPath.section] as! NSArray).objectAtIndex(indexPath.row).valueForKey(creditNameOfTime) as! NSDate)
            
            cell.dataNumber1111.text = "还款总额："
            cell.dataNumber2222.text = "-" + String(Float((textData.allValues[indexPath.section] as! NSArray).objectAtIndex(indexPath.row).valueForKey(creditNameOfPeriods) as! NSInteger) * ((textData.allValues[indexPath.section] as! NSArray).objectAtIndex(indexPath.row).valueForKey(creditNameOfNumber) as! Float))
            
        }
        
        if((textData.allKeys[indexPath.section] as? String) == keyOfSalary){
            cell.dataNumber111.removeFromSuperview()
            cell.dataNumber222.removeFromSuperview()
            cell.dataNumber1111.removeFromSuperview()
            cell.dataNumber2222.removeFromSuperview()
            
            cell.dataLable.text = String(dateToInt((textData.allValues[indexPath.section] as! NSArray).lastObject!.valueForKey(salaryNameOftime) as! NSDate, dd: "MM")) + "月" + keyOfSalary
            
            cell.dataNumber1.text = "金额："
            cell.dataNumber2.text = "+" + String((textData.allValues[indexPath.section] as! NSArray).lastObject!.valueForKey(salaryNameOfNumber) as! Float)
            
            cell.dataNumber11.text = "发放时间："
            cell.dataNumber22.text = dateToStringNoHH((textData.allValues[indexPath.section] as! NSArray).lastObject!.valueForKey(salaryNameOftime) as! NSDate)
        }
        
        return cell
    }
    
    //cell点击事件
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)
        
        if((textData.allKeys[indexPath.section] as? String) == keyOfCash){
            let vc = CashDetailTableViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if((textData.allKeys[indexPath.section] as? String) == keyOfSalary){
            let vc = CreditDetailTableViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = ChangeCreditViewController()
            vc.recivedData.append(String((textData.allValues[indexPath.section] as! NSArray).objectAtIndex(indexPath.row).valueForKey(creditNameOfPeriods) as! NSInteger))
            vc.recivedData.append(String((textData.allValues[indexPath.section] as! NSArray).objectAtIndex(indexPath.row).valueForKey(creditNameOfNumber) as! Float))
            vc.recivedData.append(String((textData.allValues[indexPath.section] as! NSArray).objectAtIndex(indexPath.row).valueForKey(creditNameOfDate) as! Int))
            vc.recivedData.append(((textData.allValues[indexPath.section] as! NSArray).objectAtIndex(indexPath.row).valueForKey(creditNameOfAccount)  as? String)!)
            vc.changeIndex = indexPath.row
            
            print(indexPath.row)
            
            vc.nextPaydayString = dateToStringNoHH((textData.allValues[indexPath.section] as! NSArray).objectAtIndex(indexPath.row).valueForKey(creditNameOfTime) as! NSDate)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //section的title
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return textData.allKeys[section] as? String
    }

}

//选择的协议
extension TableViewController : bottomMenuViewDelegate{
    func buttonClicked(tag: Int, eventFlag: Int) {
        switch eventFlag{
        case 0:
            switch tag{
            case 0:
                let vc = AddCashViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = AddCreditViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            case 2:
                let vc = AddSalaryViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        default:
            break
        }
    }
}
