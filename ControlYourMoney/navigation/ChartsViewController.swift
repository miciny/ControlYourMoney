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
    var monthCostLine: LineChartView!
    var monthPreLine: LineChartView!
    
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
                    self.setTempData(self.months, ydata: self.temps)
                    self.setWeightData(self.months, ydata: self.weights)
                    self.monthCostLine.descriptionText = "月现金支出(\(thisYearCashPayTotal))"
                    self.monthPreLine.descriptionText = "预计月支出(\(thisYearPayTotal))"
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
        scrollView.contentSize = CGSize(width: Width, height: Width/2 + Height/2+50)
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
    }
    
    //设置第一个表格
    func addMonthCostLine(){
        monthCostLine = LineChartView()
        monthCostLine.frame = CGRect(x: 5, y: 10, width: Width-10, height: Width/2)
        monthCostLine.backgroundColor = UIColor(red: 255/255, green: 127/255, blue: 80/255, alpha: 1)
        
        monthCostLine.descriptionText = "月现金支出()"
        monthCostLine.descriptionTextColor = UIColor.whiteColor()
        monthCostLine.noDataTextDescription = "无数据"
        monthCostLine.dragEnabled = true
        monthCostLine.descriptionFont = UIFont.systemFontOfSize(20)
        monthCostLine.descriptionTextPosition = CGPoint(x: monthCostLine.frame.width-20, y: 0)
        monthCostLine.layer.masksToBounds = true
        monthCostLine.layer.cornerRadius = 5
        monthCostLine.setScaleEnabled(true)
        monthCostLine.drawGridBackgroundEnabled = false
        //        monthCostLine.drawBordersEnabled = true
        monthCostLine.pinchZoomEnabled = true
        monthCostLine.autoScaleMinMaxEnabled = false
        monthCostLine.delegate = self
        
        //图例
        let legend = monthCostLine.legend
        legend.enabled = false
        
        //X数据线
        let XAxis = monthCostLine.xAxis
        XAxis.labelTextColor=UIColor.whiteColor()
        XAxis.labelPosition = ChartXAxis.LabelPosition.Bottom //x轴位置
        XAxis.drawGridLinesEnabled = false
        XAxis.drawAxisLineEnabled = false
        
        //左侧数据线
        let leftAxis = monthCostLine.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.drawGridLinesEnabled = false
        leftAxis.drawLimitLinesBehindDataEnabled = true
        leftAxis.drawAxisLineEnabled = true
        leftAxis.labelTextColor = UIColor.whiteColor()
        leftAxis.enabled = true
        
        monthCostLine.rightAxis.enabled = false
        monthCostLine.viewPortHandler.setMaximumScaleY(1.0)
        
        //用于点击之后显示数据
        let marker = BalloonMarker(color: UIColor.clearColor(), font:UIFont.systemFontOfSize(12.0), insets:UIEdgeInsetsMake(20.0, 8.0, 8.0, 8.0))
        marker.minimumSize = CGSizeMake(80, 40)
        monthCostLine.marker = marker
        
        //        monthCostLine.legend.form = ChartLegend.ChartLegendForm.Line
        monthCostLine.animate(xAxisDuration: 2.0, easingOption: ChartEasingOption.EaseInOutCubic)
        scrollView.addSubview(monthCostLine)
    }
    
    //设置第一个表格的数据
    func setTempData(xdata : NSArray, ydata : NSArray){
        let count = xdata.count
        var xVals = [String]()
        var yVals = [ChartDataEntry]()
        var index = 0  // 添加Y数据时的位置
        
        for i in 0 ..< count{
            xVals.append(xdata[i] as! String)
        }
        
        for i in 0 ..< count{
            yVals.append(ChartDataEntry(value: ydata[i] as! Double, xIndex:index))
            index += 1
        }
        
        let set1 = LineChartDataSet(yVals: yVals, label: nil)
        set1.lineDashLengths = [5, 0] // 线条格式
        set1.highlightLineDashLengths = [5, 2.5]
        set1.setColor(UIColor.whiteColor())
        set1.setCircleColor(UIColor.whiteColor())
        set1.circleHoleColor = UIColor(red: 255/255, green: 127/255, blue: 80/255, alpha: 1)
        set1.lineWidth = 1.0
        set1.circleRadius = 3.0
        set1.drawCircleHoleEnabled = true
        set1.drawValuesEnabled = false
        set1.valueFont = UIFont.systemFontOfSize(9)
        set1.drawFilledEnabled = true
        set1.fillAlpha = 30/255.0
        set1.fillColor = UIColor.whiteColor()
        
        var dataSets = [ChartDataSet]()
        dataSets.append(set1)
        
        monthCostLine.data = LineChartData.init(xVals: xVals, dataSets: dataSets)
        monthCostLine.setVisibleXRangeMaximum(CGFloat(12))
    }
    
     //设置第二个表格
    func addMonthPreLine(){
        monthPreLine = LineChartView()
        monthPreLine.frame = CGRect(x: 5, y: Width/2 + 20, width: Width-10, height: Width/2)
        monthPreLine.backgroundColor = UIColor(red: 255/255, green: 127/255, blue: 80/255, alpha: 1)
        
        monthPreLine.descriptionText = "预计月支出()"
        monthPreLine.descriptionTextColor = UIColor.whiteColor()
        monthPreLine.noDataTextDescription = "无数据"
        monthPreLine.dragEnabled = true
        monthPreLine.descriptionFont = UIFont.systemFontOfSize(20)
        monthPreLine.descriptionTextPosition = CGPoint(x: monthPreLine.frame.width-20, y: 0)
        monthPreLine.layer.masksToBounds = true
        monthPreLine.layer.cornerRadius = 5
        monthPreLine.setScaleEnabled(true)
        monthPreLine.drawGridBackgroundEnabled = false
        monthPreLine.pinchZoomEnabled = true
        monthPreLine.autoScaleMinMaxEnabled = false
        monthPreLine.delegate = self
        
        //图例
        let legend = monthPreLine.legend
        legend.enabled = false
        
        //X数据线
        let XAxis = monthPreLine.xAxis
        XAxis.labelTextColor=UIColor.whiteColor()
        XAxis.labelPosition = ChartXAxis.LabelPosition.Bottom //x轴位置
        XAxis.drawGridLinesEnabled = false
        XAxis.drawAxisLineEnabled = false
        
        //左侧数据线
        let leftAxis = monthPreLine.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.drawLimitLinesBehindDataEnabled = true
        leftAxis.drawGridLinesEnabled = false
        leftAxis.drawAxisLineEnabled = true
        leftAxis.labelTextColor = UIColor.whiteColor()
        leftAxis.enabled = true
        
        monthPreLine.rightAxis.enabled = false
        
        monthPreLine.viewPortHandler.setMaximumScaleY(1.0)
        
        //用于点击之后显示数据
        let marker = BalloonMarker.init(color: UIColor.clearColor(), font:UIFont.systemFontOfSize(12.0), insets:UIEdgeInsetsMake(20.0, 8.0, 8.0, 8.0))
        marker.minimumSize = CGSizeMake(80, 40)
        monthPreLine.marker = marker
        
        //        monthPreLine.legend.form = ChartLegend.ChartLegendForm.Line //图例样式
        monthPreLine.animate(xAxisDuration: 2.0, easingOption: ChartEasingOption.EaseInOutCubic)
        scrollView.addSubview(monthPreLine)
    }
    
    func setWeightData(xdata : NSArray, ydata : NSArray){
        let count = xdata.count
        var xVals = [String]()
        var yVals = [ChartDataEntry]()
        var index = 0  // 添加Y数据时的位置
        
        for i in 0 ..< count{
            xVals.append(xdata[i] as! String)
        }
        
        for i in 0 ..< count{
            yVals.append(ChartDataEntry(value: ydata[i] as! Double, xIndex:index))
            index += 1
            
        }
        
        let set1 = LineChartDataSet(yVals: yVals, label: nil)
        set1.lineDashLengths = [5, 0] // 线条格式
        set1.highlightLineDashLengths = [5, 2.5]
        set1.setColor(UIColor.whiteColor())
        set1.setCircleColor(UIColor.whiteColor())
        set1.circleHoleColor = UIColor(red: 255/255, green: 127/255, blue: 80/255, alpha: 1)
        set1.lineWidth = 1.0
        set1.circleRadius = 3.0
        set1.drawCircleHoleEnabled = true
        set1.drawValuesEnabled = false
        set1.valueFont = UIFont.systemFontOfSize(9)
        set1.drawFilledEnabled = true
        set1.fillAlpha = 30/255.0
        set1.fillColor = UIColor.whiteColor()
        
        var dataSets = [ChartDataSet]()
        dataSets.append(set1)
        
        monthPreLine.data = LineChartData.init(xVals: xVals, dataSets: dataSets)
        monthPreLine.setVisibleXRangeMaximum(CGFloat(12))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
