//
//  MCYCreditPieChartView.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/24.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import Charts

class MCYCreditPieChartView: UIView {
    var pieChart: PieChartView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, title: String, holeText: String) {
        self.init()
        setUpPieChart(frame, title: title, holeText: holeText)
    }
    
    func setUpPieChart(frame: CGRect, title: String, holeText:String){
        pieChart = PieChartView()
        pieChart.frame = frame
        
        pieChart.usePercentValuesEnabled = true  //百分百显示
        pieChart.drawSlicesUnderHoleEnabled = false
        pieChart.holeRadiusPercent = 0.9 //图表中间的半径
        pieChart.transparentCircleRadiusPercent = 0.68
        pieChart.descriptionText = title
        pieChart.setExtraOffsets(left: -10, top: 0, right: -10, bottom: -10)
        pieChart.noDataText = "无数据"
        
        pieChart.drawCenterTextEnabled = true
        
        let centerText = NSMutableAttributedString(string: holeText)
        
        pieChart.centerAttributedText = centerText
        
        pieChart.drawHoleEnabled = true //允许中间的文字
        pieChart.rotationAngle = 270 //开始的角度
        pieChart.rotationEnabled = true
        pieChart.highlightPerTapEnabled = false //点击之后高亮
        
        let l = pieChart.legend  // 图例，暂时不需要
        l.horizontalAlignment = .Right
        l.verticalAlignment = .Top
        l.xEntrySpace = 7.0
        l.yEntrySpace = 0.0
        l.yOffset = 0.0
        l.enabled = false //显不显示
    
        self.addSubview(pieChart)
//        pieChart.animate(xAxisDuration: 1.4, easingOption: ChartEasingOption.EaseOutBack) //动画
    }
    
    func setPieChartData(titles: [String], values: [Double]){
        var yVals = [ChartDataEntry]()
        var xVals = [String]()
        let count = titles.count
        for i in 0 ..< count{
            yVals.append(ChartDataEntry(value: values[i], xIndex: i))
        }
    
        for i in 0 ..< count{
            xVals.append(titles[i])
        }
    
        let dataSet = PieChartDataSet(yVals: yVals, label: nil)
        dataSet.sliceSpace = 0 //每个弧度的间隔
        var colors = [UIColor]()
        colors.append(UIColor.greenColor())
        colors.append(UIColor.redColor())
        colors.append(UIColor.yellowColor())
        dataSet.colors = colors
    
        let data = PieChartData(xVals: xVals, dataSet: dataSet)
    
        let pFormatter = NSNumberFormatter()
        pFormatter.numberStyle = .PercentStyle
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        
        data.setValueFormatter(pFormatter)
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size:11))
        data.setValueTextColor(UIColor.whiteColor())
        data.setDrawValues(false) //不显示每个弧度的values
    
        pieChart.data = data
        pieChart.highlightValues(nil)
    }
}
