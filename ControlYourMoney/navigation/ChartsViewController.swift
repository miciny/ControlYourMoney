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
    
    var isCounting = false
    
    var months = NSArray()
    var temps = NSArray()
    var weights = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTitle()
        setScroll()
        addMonthCostLine()
        addMonthPreLine()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let wiatView = MyWaitToast()
        if temps.count == 0 {
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
                
                dispatch_async(dispatch_get_main_queue(), {
                    wiatView.hideView()
                    self.monthCostLine.setLineChartData(self.months, ydata: self.temps)
                    self.monthPreLine.setLineChartData(self.months, ydata: self.weights)
                    self.monthCostLine.lineChart.descriptionText = "月现金支出(\(thisYearCashPayTotal))"
                    self.monthPreLine.lineChart.descriptionText = "预计月支出(\(thisYearPayTotal))"
                    self.monthCostLine.setNeedsDisplay()
                    self.monthPreLine.setNeedsDisplay()
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
        temps = GetAnalyseData.getEveryMonthPay()
        weights = GetAnalyseData.getPreEveryMonthPay()
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
        
        scrollView.contentSize = CGSize(width: Width, height: monthPreLine.frame.maxY+20)
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
