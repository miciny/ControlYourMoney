//
//  DataAnalyseViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/11.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class DataAnalyseViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    fileprivate var collectionView : UICollectionView?  //整个集合视图
    fileprivate let cellReuseIdentifier = "analyseCell"
    fileprivate var cellData: NSMutableDictionary?
    fileprivate var refreshView: RefreshHeaderView? //自己写的
    
    let preOneStr = "预计本月支出"
    let preTowStr = "预计年底结余"
    let preThreeStr = "预计月底结余"
    let preFourStr = "预计本年支出"
    
    let cashOneStr = "今日现金支出"
    let cashTwoStr = "本月现金支出"
    let cashFourStr = "实际本月支出"
    let cashFiveStr = "今年现金支出"
    let cashSixStr = "今年总共支出"
    
    let creditOneStr = "本月信用总还"
    let creditTwoStr = "下月信用总还"
    let creditThreeStr = "所有信用余还"
    let creditFourStr = "本月信用余还"
    let creditFiveStr = "今年信用总还"
    let creditSixStr = "今年信用余还"
    
    let incomeOneStr = "今年总共收入"
    let incomeTwoStr = "目前总共财产"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTitle()
        setUpCollection()
    }
    
    //初始化collectionView
    func setUpCollection(){
        
        let layout = UICollectionViewFlowLayout() //也可自定义的
        layout.minimumLineSpacing = 0 //上下
        layout.minimumInteritemSpacing = 0 //左右
        
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: Width, height: Height), collectionViewLayout: layout)
        self.collectionView?.backgroundColor = UIColor.clear
        
        //注册一个cell
        self.collectionView!.register(AnalyseMainViewCollectionViewCell.self, forCellWithReuseIdentifier: self.cellReuseIdentifier)
        
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        
        self.view.addSubview(self.collectionView!)
        refreshView =  RefreshHeaderView(frame: collectionView!.frame, subView: collectionView!, target: self)  //添加下拉刷新
        setUpData()
    }
    
    //获取数据
    let wiatView = MyWaitView()
    func setUpData(){
        self.cellData = NSMutableDictionary()
        wiatView.showWait("计算中...")
        calculateData()
    }
    
    //计算数据
    func calculateData(){
        let DataAnalysePageQueue: DispatchQueue = DispatchQueue(label: "DataAnalysePageQueue", attributes: [])
        DataAnalysePageQueue.async(execute: {
            let thisMonthPay = GetAnalyseData.getPreThisMonthPay()
            let thisYearPay = GetAnalyseData.getPreThisYearPay()
            let nowLeft = GetAnalyseData.getPreNowLeft()
            let thisYearLeft = GetAnalyseData.getPreThisYearLeft()
            
            let preOne = AnalysePageDataModul(pic: nil, name: self.preOneStr, data: "\(thisMonthPay)")
            let preTow = AnalysePageDataModul(pic: nil, name: self.preTowStr, data: "\(thisYearLeft)")
            let preThree = AnalysePageDataModul(pic: nil, name: self.preThreeStr, data: "\(nowLeft)")
            let preFour = AnalysePageDataModul(pic: nil, name: self.preFourStr, data: "\(thisYearPay)")
            
            let thisMonthCreditLeftPay = GetAnalyseData.getCreditThisMonthLeftPay()
            let allCreditLeftPay = GetAnalyseData.getCreditTotalLeftPay()
            let thisMonthCredit = GetAnalyseData.getCreditThisMonthAllPayIncludeDone()
            let nextMonthCredit = GetAnalyseData.getCreditNextMonthAllPay()
            let thisYearCreditPayTotal = GetAnalyseData.getCreditThisYearTotalPay()
            let thisYearCreditLeftPay = GetAnalyseData.getCreditThisYearLeftPay()
            
            let creditOne = AnalysePageDataModul(pic: nil, name: self.creditOneStr, data: "\(thisMonthCredit)")
            let creditTwo = AnalysePageDataModul(pic: nil, name: self.creditTwoStr, data: "\(nextMonthCredit)")
            let creditThree = AnalysePageDataModul(pic: nil, name: self.creditThreeStr, data: "\(allCreditLeftPay)")
            let creditFour = AnalysePageDataModul(pic: nil, name: self.creditFourStr, data: "\(thisMonthCreditLeftPay)")
            let creditfive = AnalysePageDataModul(pic: nil, name: self.creditFiveStr, data: "\(thisYearCreditPayTotal)")
            let creditSix = AnalysePageDataModul(pic: nil, name: self.creditSixStr, data: "\(thisYearCreditLeftPay)")
            
            let todayUse = GetAnalyseData.getTodayUse()
            let thisMonthUse = GetAnalyseData.getThisMonthUse()
            let thisMonthRealPay = thisMonthUse + thisMonthCredit
            let canUse =  GetAnalyseData.getCanUseToFloat()
            let thisYearCashPayTotal = GetAnalyseData.getThisYearPayTotal()
            let thisYearPayTotal = thisYearCashPayTotal + thisYearCreditPayTotal
            
            let cashOne = AnalysePageDataModul(pic: nil, name: self.cashOneStr, data: "\(todayUse)")
            let cashTwo = AnalysePageDataModul(pic: nil, name: self.cashTwoStr, data: "\(thisMonthUse)")
            let cashThree = AnalysePageDataModul(pic: nil, name: "现金目前余额", data: String(format: "%.2f", canUse))
            let cashFour = AnalysePageDataModul(pic: nil, name: self.cashFourStr, data: "\(thisMonthRealPay)") //本月现金支出和本月信用卡支出
            let cashFive = AnalysePageDataModul(pic: nil, name: self.cashFiveStr, data: "\(thisYearCashPayTotal)")
            let cashSix = AnalysePageDataModul(pic: nil, name: self.cashSixStr, data: "\(thisYearPayTotal)")
            
            let allRealSalary = GetAnalyseData.getAllRealSalary()
            let allPropety = canUse-allCreditLeftPay
            let IncomeOne = AnalysePageDataModul(pic: nil, name: self.incomeOneStr, data: "\(allRealSalary)")
            let IncomeTwo = AnalysePageDataModul(pic: nil, name: self.incomeTwoStr, data: "\(allPropety)")
            
            mainQueue.async(execute: {
                self.cellData = NSMutableDictionary()
                self.cellData?.setValue([preOne, preTow, preThree, preFour], forKey: "预计")
                self.cellData?.setValue([creditOne, creditTwo, creditThree, creditFour, creditfive, creditSix], forKey: "信用")
                self.cellData?.setValue([cashOne, cashTwo, cashThree, cashFour, cashFive, cashSix], forKey: "现金")
                self.cellData?.setValue([IncomeOne, IncomeTwo], forKey: "收入")
                self.wiatView.hideView()
                self.collectionView?.reloadData()
                
                self.endFresh()
            })
        })
    }
    
    func setUpTitle(){
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
        self.title = "分析"
    }
    
    //结束刷新时调用
    func endFresh(){
        self.collectionView!.isScrollEnabled = true
        self.collectionView!.setContentOffset(CGPoint(x: 0, y: -RefreshHeaderHeight), animated: true)
        
        self.refreshView?.endRefresh()
        MyToastView().showToast("刷新完成！")
    }
    
    
    //=====================================================================================================
    /**
     MARK: UICollectionViewDataSource
     **/
    //=====================================================================================================
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return (cellData?.allKeys.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return (cellData!.allValues[section] as! NSArray).count
    }
    
    //collection的内容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! AnalyseMainViewCollectionViewCell
        
        let data = (cellData!.allValues[indexPath.section] as! NSArray)[indexPath.row] as! AnalysePageDataModul
        if data.pic != nil {
            cell.dataPic?.image = UIImage(named: (data.pic)!)
            cell.addSubview(cell.dataPic!)
        }
        
        cell.dataLable.text = data.name
        cell.data.text = data.data
        
        return cell
    }
    
    //cell点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = (cellData!.allValues[indexPath.section] as! NSArray)[indexPath.row] as! AnalysePageDataModul
        switch data.name {
        case preOneStr:
            let vc = MonthCostViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case preTowStr:
            let vc = EveryMonthSalaryViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case preFourStr:
            let vc = YearCostViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case incomeOneStr:
            let vc = SalaryDetailTableViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case cashOneStr:
            let vc = CashDetailTableViewController()
            vc.showData =  GetAnalyseDataArray.getTodayCashDetailShowArray()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case cashTwoStr:
            let vc = CashDetailTableViewController()
            vc.showData =  GetAnalyseDataArray.getThisMonthCashDetailShowArray()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case cashFourStr:
            let vc = CreditDetailListViewController()
            vc.AllData = GetAnalyseDataArray.getThisMonthRealPay()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case cashFiveStr:
            self.tabBarController?.selectedIndex = 2
        case cashSixStr:
            self.tabBarController?.selectedIndex = 2
        case creditOneStr:
            let vc = CreditDetailListViewController()
            vc.AllData = GetAnalyseDataArray.getThisCreditRealPay()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case creditTwoStr:
            let vc = CreditDetailListViewController()
            vc.AllData = GetAnalyseDataArray.getNextMonthCreditPay()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case creditThreeStr:
            let vc = CreditDetailListViewController()
            vc.AllData = GetAnalyseDataArray.getAllCreditLeftPay()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case creditFourStr:
            let vc = CreditDetailListViewController()
            vc.AllData = GetAnalyseDataArray.getThisCreditLeftPay()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case creditFiveStr:
            let vc = CreditDetailListViewController()
            vc.AllData = GetAnalyseDataArray.getThisYearCreditPayIncludeDone()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case creditSixStr:
            let vc = CreditDetailListViewController()
            vc.AllData = GetAnalyseDataArray.getThisYearCreditLeftPay()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        
    }

    //cell的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        //设置每一个cell的宽高
        return CGSize(width: Width/2, height: 64)
        
    }
    
    //返回分组头部视图的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let size = CGSize(width: Width, height: 5)
        return size
    }
    
    //返回分组脚部视图的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let size = CGSize(width: Width, height: 15)
        return size
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DataAnalyseViewController: isRefreshingDelegate{
    //isfreshing中的代理方法
    func reFreshing(){
        collectionView!.setContentOffset(CGPoint(x: 0, y: -RefreshHeaderHeight*2), animated: true)
        collectionView!.isScrollEnabled = false
        //这里做你想做的事
        self.calculateData()
    }
}
