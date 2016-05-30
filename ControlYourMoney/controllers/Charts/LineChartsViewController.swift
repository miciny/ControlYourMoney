//
//  LineChartsViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/28.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class LineChartsViewController: UIViewController {
    
    var isCounting = false //是否正在计算，在计算中就不重新加载数据了
    
    var scrollView: UIScrollView!
    var monthCostLine: MCYLineChartView!  //月支出表
    var monthPreLine: MCYLineChartView! //月预计支出表
    var dayCostLine: MCYLineChartView! //日支出表
    
    //五项数据源
    var months = NSArray()
    var monthsCost = NSArray()
    var monthsPreCost = NSArray()
    var days = [String]()
    var daysCost = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        setScroll()
        addMonthCostLine()
        addMonthPreLine()
        addDayCostLine()
        
    }
    
    //进入页面就计算数据
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        let wiatView = MyWaitToast()
        
        if days.count == 0 {
            wiatView.title = "计算中..."
            wiatView.showWait(self.view)
        }
        
        if !isCounting {
            let LineChartPageQueue: dispatch_queue_t = dispatch_queue_create("LineChartPageQueue", DISPATCH_QUEUE_SERIAL)
            
            dispatch_async(LineChartPageQueue,{
                self.getData()
                self.isCounting = true
                
                let thisYearCreditPayTotal = GetAnalyseData.getCreditThisYearTotalPay()
                let thisYearCashPayTotal = GetAnalyseData.getThisYearPayTotal()
                let thisYearPayTotal = thisYearCashPayTotal + thisYearCreditPayTotal
                let thisMonthPayTotal = GetAnalyseData.getThisMonthUse()
                
                dispatch_async(mainQueue, {
                    wiatView.hideView()
                    
                    self.monthCostLine.lineChart.descriptionText = "月现金支出(\(thisYearCashPayTotal))"
                    self.monthPreLine.lineChart.descriptionText = "预计月支出(\(thisYearPayTotal))"
                    self.dayCostLine.lineChart.descriptionText = "日现金支出(\(thisMonthPayTotal))"
                    
                    self.setData()
                    
                    self.isCounting = false
                })
            })
        }
    }
    
    //初始化数据
    func getData(){
        months = ["1","2","3","4","5","6","7","8","9","10","11","12"]
        days = []
        for i in 0 ..< getTime().currentDay {
            days.append("\(i+1)")
        }
        
        monthsCost = GetAnalyseData.getEveryMonthPay()
        monthsPreCost = GetAnalyseData.getPreEveryMonthPay()
        daysCost = GetAnalyseData.getEveryDayPay()
    }
    
    //设置显示数据
    func setData(){
        
        self.monthCostLine.setLineChartData(self.months, ydata: self.monthsCost)
        self.monthPreLine.setLineChartData(self.months, ydata: self.monthsPreCost)
        self.dayCostLine.setLineChartData(self.days, ydata: self.daysCost)
        
        self.monthCostLine.setNeedsDisplay()
        self.monthPreLine.setNeedsDisplay()
        self.dayCostLine.setNeedsDisplay()
    }
    
    // 设置整个scrollView
    func setScroll(){
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: Width, height: Height-100-60))
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
    }
    
    //设置第一个表格
    func addMonthCostLine(){
        let viewFrame = CGRect(x: 5, y: 0, width: Width-10, height: Width/2)
        monthCostLine = MCYLineChartView(frame: viewFrame, title: "月现金支出", scaleEnabled: false)
        monthCostLine.frame = CGRect(x: 0, y: 5, width: Width, height: Width/2)
        scrollView.addSubview(monthCostLine)
    }
    
    //设置第二个表格
    func addMonthPreLine(){
        monthPreLine = MCYLineChartView()
        let viewFrame = CGRect(x: 5, y: 0, width: Width-10, height: Width/2)
        monthPreLine = MCYLineChartView(frame: viewFrame, title: "预计月支出", scaleEnabled: false)
        monthPreLine.frame = CGRect(x: 0, y: monthCostLine.frame.maxY+20, width: Width, height: Width/2)
        scrollView.addSubview(monthPreLine)
    }
    
    //设置第三个表格
    func addDayCostLine(){
        dayCostLine = MCYLineChartView()
        let viewFrame = CGRect(x: 5, y: 0, width: Width-10, height: Width/2)
        dayCostLine = MCYLineChartView(frame: viewFrame, title: "日现金支出", scaleEnabled: false)
        dayCostLine.frame = CGRect(x: 0, y: monthPreLine.frame.maxY+20, width: Width, height: Width/2)
        dayCostLine.visibleXRangeMaximum = CGFloat(getTime().currentDay)
        scrollView.addSubview(dayCostLine)
        
        scrollView.contentSize = CGSize(width: Width, height: dayCostLine.frame.maxY+20)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}