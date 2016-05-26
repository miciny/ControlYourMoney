//
//  ChartsViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/17.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import Charts

class ChartsViewController: UIViewController, ChartViewDelegate{
    
    var scrollView: UIScrollView!
    var monthCostLine: MCYLineChartView!
    var monthPreLine: MCYLineChartView!
    var dayCostLine: MCYLineChartView!
    var yearCostPie: MCYPiePolyLineChartView!
    var yearIncomePie: MCYPiePolyLineChartView!
    
    var isCounting = false
    
    var months = NSArray()
    var monthsCost = NSArray()
    var monthsPreCost = NSArray()
    
    var days = [String]()
    var daysCost = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTitle()
        setScroll()
        addMonthCostLine()
        addMonthPreLine()
        addDayCostLine()
        addCostPie()
        addIncomePie()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let wiatView = MyWaitToast()
        if monthsCost.count == 0 {
            wiatView.title = "计算中..."
            wiatView.showWait(self.view)
        }
        
        if !isCounting {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),{
                self.isCounting = true
                self.getData()
                let thisYearCreditPayTotal = GetAnalyseData.getCreditThisYearTotalPay()
                let thisYearCashPayTotal = GetAnalyseData.getThisYearPayTotal()
                let thisYearPayTotal = thisYearCashPayTotal + thisYearCreditPayTotal
                let thisMonthPayTotal = GetAnalyseData.getThisMonthUse()
                
                let dataDic1 = GetAnalyseData.getCostPercent()
                let dataDic2 = GetAnalyseData.getIncomePercent()
                
                dispatch_async(dispatch_get_main_queue(), {
                    wiatView.hideView()
                    self.monthCostLine.setLineChartData(self.months, ydata: self.monthsCost)
                    self.monthPreLine.setLineChartData(self.months, ydata: self.monthsPreCost)
                    self.dayCostLine.setLineChartData(self.days, ydata: self.daysCost)
                    
                    if dataDic1 != nil {
                        self.yearCostPie.setPieChartData(dataDic1!)
                    }
                    if dataDic2 != nil {
                        self.yearIncomePie.setPieChartData(dataDic2!)
                    }
                    
                    self.monthCostLine.lineChart.descriptionText = "月现金支出(\(thisYearCashPayTotal))"
                    self.monthPreLine.lineChart.descriptionText = "预计月支出(\(thisYearPayTotal))"
                    self.dayCostLine.lineChart.descriptionText = "日现金支出(\(thisMonthPayTotal))"
                    
                    self.monthCostLine.setNeedsDisplay()
                    self.monthPreLine.setNeedsDisplay()
                    self.dayCostLine.setNeedsDisplay()
                    self.yearCostPie.setNeedsDisplay()
                    self.yearIncomePie.setNeedsDisplay()
                    self.isCounting = false
                })
            })
        }
    }
    
    func setUpTitle(){
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
        self.title = "图表"
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

    func setScroll(){
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: Width, height: Height))
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
    }
    
    //设置第四个饼状图
    func addCostPie(){
        let dataDic = GetAnalyseData.getCostPercent()
        
        let thisYearPayTotal = GetAnalyseData.getThisYearPayTotal() + GetAnalyseData.getCreditThisYearTotalPay()
        let strOne = "\(thisYearPayTotal)"
        
        let viewFrame = CGRect(x: 0, y: 0, width: Width, height: Width*2/3)
        yearCostPie = MCYPiePolyLineChartView(frame: viewFrame, title: "今年花费比例", holeText: strOne)
        yearCostPie.frame = CGRect(x: 0, y: dayCostLine.frame.maxY+20, width: Width, height: Width*2/3)
        
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
    
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        print(dataSetIndex)
    }
    
    func chartValueNothingSelected(chartView: ChartViewBase) {
        print("no data selected")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
