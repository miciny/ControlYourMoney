//
//  PieChartsViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/28.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class PieChartsViewController: UIViewController {
    
    var scrollView: UIScrollView!
    var yearCostPie: MCYPiePolyLineChartView!
    var yearIncomePie: MCYPiePolyLineChartView!
    var isCounting = false
    var isIn = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setScroll()
        addCostPie()
        addIncomePie()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        setData()
    }
    
    func setData(){
        let wiatView = MyWaitToast()
        
        if !isIn {
            wiatView.title = "计算中..."
            wiatView.showWait(self.view)
            isIn = true
        }
        if !isCounting {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),{
                self.isCounting = true
                let dataDic1 = GetAnalyseData.getCostPercent()
                let dataDic2 = GetAnalyseData.getIncomePercent()
                
                dispatch_async(dispatch_get_main_queue(), {
                    wiatView.hideView()
                    
                    if dataDic1 != nil {
                        self.yearCostPie.setPieChartData(dataDic1!)
                    }
                    if dataDic2 != nil {
                        self.yearIncomePie.setPieChartData(dataDic2!)
                    }
                    self.yearCostPie.setNeedsDisplay()
                    self.yearIncomePie.setNeedsDisplay()
                    
                    self.isCounting = false
                })
            })
        }
    }
    
    func setScroll(){
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: Width, height: Height-100-60))
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
    }
    
    //设置第四个饼状图
    func addCostPie(){
        let dataDic = GetAnalyseData.getCostPercent()
        
        let thisYearPayTotal = GetAnalyseData.getThisYearPayTotal() + GetAnalyseData.getCreditThisYearTotalPay()
        let strOne = "\(thisYearPayTotal)"
        
        let viewFrame = CGRect(x: 0, y: 0, width: Width, height: Width*2/3)
        yearCostPie = MCYPiePolyLineChartView(frame: viewFrame, title: "今年花费比例", holeText: strOne)
        yearCostPie.frame = CGRect(x: 0, y: 0, width: Width, height: Width*2/3)
        
        if dataDic != nil {
            yearCostPie.setPieChartData(dataDic!)
        }
        
        self.scrollView.addSubview(yearCostPie)
    }
    
    //设置第五个饼状图
    func addIncomePie(){
        let dataDic = GetAnalyseData.getIncomePercent()
        
        let allRealSalary = GetAnalyseData.getAllRealSalary()
        var strOne = "\(allRealSalary)"
        if allRealSalary == 0{
            strOne = "无数据"
        }
        
        let viewFrame = CGRect(x: 0, y: 0, width: Width, height: Width*2/3)
        yearIncomePie = MCYPiePolyLineChartView(frame: viewFrame, title: "今年收入比例", holeText: strOne)
        yearIncomePie.frame = CGRect(x: 0, y: yearCostPie.frame.maxY+20, width: Width, height: Width*2/3)
        
        if dataDic != nil {
            yearIncomePie.setPieChartData(dataDic!)
        }
        
        self.scrollView.addSubview(yearIncomePie)
        
        scrollView.contentSize = CGSize(width: Width, height: yearIncomePie.frame.maxY+20)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
