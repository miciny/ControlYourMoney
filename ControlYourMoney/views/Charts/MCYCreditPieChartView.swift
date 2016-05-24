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
    var delegate: ChartViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, title: String, scaleEnabled: Bool) {
        self.init()
        setUpPieChart(frame, title: title)
    }
    
    func setUpPieChart(frame: CGRect, title: String){
        pieChart = PieChartView()
        pieChart.frame = frame
        
        pieChart.usePercentValuesEnabled = true
        pieChart.drawSlicesUnderHoleEnabled = false
        pieChart.holeRadiusPercent = 0.58
        pieChart.transparentCircleRadiusPercent = 0.61
        pieChart.descriptionText = title
        pieChart.setExtraOffsets(left: 5, top: 10, right: 5, bottom: 5)
        pieChart.noDataText = "无数据"
        
        pieChart.drawCenterTextEnabled = true
        
        let paragraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        paragraphStyle.alignment = NSTextAlignment.Center
        
        let centerText = NSMutableAttributedString(string: "iOS Charts\nby Daniel Cohen Gindi")
        centerText.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size:12)!, NSParagraphStyleAttributeName: paragraphStyle], range: NSMakeRange(0, centerText.length))
        
        centerText.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size:10)!, NSParagraphStyleAttributeName: UIColor.grayColor()], range: NSMakeRange(10, centerText.length - 10))
        
        centerText.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-LightItalic", size:10)!, NSParagraphStyleAttributeName: UIColor(red: 51/255, green: 181/255, blue:229/255, alpha: 1)], range: NSMakeRange(centerText.length - 19, 19))
        
        pieChart.centerAttributedText = centerText
        
        pieChart.drawHoleEnabled = true
        pieChart.rotationAngle = 0
        pieChart.rotationEnabled = true
        pieChart.highlightPerTapEnabled = true
        
        let l = pieChart.legend
        l.horizontalAlignment = .Right
        l.verticalAlignment = .Top
        l.xEntrySpace = 7.0
        l.yEntrySpace = 0.0
        l.yOffset = 0.0
        
        pieChart.delegate = delegate
        self.addSubview(pieChart)
        pieChart.animate(xAxisDuration: 1.4, easingOption: ChartEasingOption.EaseOutBack)
    }
    
    func setPieChartData(count: Int, range: Double){
        var yVals = [ChartDataEntry]()
        var xVals = [String]()
    
        for i in 0 ..< count{
            yVals.append(ChartDataEntry(value: 0.5, xIndex: i))
        }
    
        for i in 0 ..< count{
            xVals.append(String(i+1))
        }
    
        let dataSet = PieChartDataSet(yVals: yVals, label: nil)
        dataSet.sliceSpace = 1.0
        var colors = [UIColor]()
        
        for _ in 0 ..< count{
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
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
    
        print(data.xVals)
        print(data.dataSets)
        
        pieChart.data = data
        pieChart.highlightValues(nil)
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Units Sold")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
//        pieChart.data = pieChartData
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        pieChartDataSet.colors = colors
    }
}
