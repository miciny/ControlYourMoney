//
//  DataAnalyseViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/11.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class DataAnalyseViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    private var collectionView : UICollectionView?
    private let cellReuseIdentifier = "analyseCell"
    private var cellData: NSMutableDictionary?

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
        
        self.collectionView = UICollectionView(frame: CGRectMake(0, 0, Width, Height), collectionViewLayout: layout)
        self.collectionView?.backgroundColor = UIColor.clearColor()
        
        //注册一个cell
        self.collectionView!.registerClass(AnalyseMainViewCollectionViewCell.self, forCellWithReuseIdentifier: self.cellReuseIdentifier)
        
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        
        self.view.addSubview(self.collectionView!)
        
        setUpData()
    }
    
    
    func setUpData(){
        self.cellData = NSMutableDictionary()
        
        let thisMonthPay = GetAnalyseData.getThisMonthPay()
        let thisMonthLeft = GetAnalyseData.getThisMonthLeft()
        let nowLeft = GetAnalyseData.getNowLeft()
        let thisYearLeft = GetAnalyseData.getThisYearLeft()
        
        let thisMonthCreditLeftPay = GetAnalyseData.getCreditThisMonthLeftPay()
        let allCreditLeftPay = GetAnalyseData.getCreditTotalPay()
        let thisMonthCredit = GetAnalyseData.getCreditThisMonthPay()
        let nextMonthCredit = GetAnalyseData.getCreditNextMonthPay()
        
        let todayUse = GetAnalyseData.getTodayUse()
        let thisMonthUse = GetAnalyseData.getThisMonthUse()
        
        let dataOne = AnalysePageDataModul(pic: nil, name: "预计本月支出", data: "\(thisMonthPay)")
        let dataTow = AnalysePageDataModul(pic: nil, name: "预计年底结余", data: "\(thisYearLeft)")
        let dataThree = AnalysePageDataModul(pic: nil, name: "预计本月结余", data: "\(thisMonthLeft)")
        let dataFour = AnalysePageDataModul(pic: nil, name: "预计目前结余", data: "\(nowLeft)")
        
        let dataFive = AnalysePageDataModul(pic: nil, name: "本月信用卡总还", data: "\(thisMonthCredit)")
        let dataSix = AnalysePageDataModul(pic: nil, name: "下月信用卡总还", data: "\(nextMonthCredit)")
        let dataSeven = AnalysePageDataModul(pic: nil, name: "所有信用卡总还", data: "\(allCreditLeftPay)")
        let dataEight = AnalysePageDataModul(pic: nil, name: "本月信用卡剩余应还", data: "\(thisMonthCreditLeftPay)")
        
        let dataNine = AnalysePageDataModul(pic: nil, name: "今日现金总额", data: "\(todayUse)")
        let dataTem = AnalysePageDataModul(pic: nil, name: "本月现金总额", data: "\(thisMonthUse)")
        
        self.cellData?.setValue([dataOne, dataTow, dataThree, dataFour], forKey: "预计")
        self.cellData?.setValue([dataFive, dataSix, dataSeven, dataEight], forKey: "信用")
        self.cellData?.setValue([dataNine, dataTem], forKey: "现金")
        
    }
    
    func setUpTitle(){
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
        self.title = "分析"
        
        let refresh = UIBarButtonItem(title: "刷新", style: .Plain, target: self, action:
            #selector(DataAnalyseViewController.refresh))
        self.navigationItem.leftBarButtonItem = refresh
    }
    
    func refresh(){
        setUpData()
        self.collectionView?.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return (cellData?.allKeys.count)!
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return (cellData!.allValues[section] as! NSArray).count
    }
    
    //collection的内容
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! AnalyseMainViewCollectionViewCell
        
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
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let data = (cellData!.allValues[indexPath.section] as! NSArray)[indexPath.row] as! AnalysePageDataModul
        print(data.name)
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                print("0")
            case 1:
                print("1")
            case 2:
                print("2")
            case 3:
                print("3")
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                print("4")
            case 1:
                print("5")
            case 2:
                print("6")
            case 3:
                print("7")
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                print("8")
            case 1:
                print("9")
            default:
                break
            }
        default:
            break
        }
        
    }

    //cell的大小
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        //设置每一个cell的宽高
        return CGSizeMake(Width/2, 64)
        
    }
    
    //返回分组头部视图的尺寸
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let size = CGSize(width: Width, height: 5)
        return size
    }
    
    //返回分组脚部视图的尺寸
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let size = CGSize(width: Width, height: 15)
        return size
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
