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
    var yearCostPie: MCYPiePolyLineChartView!  //支出百分比
    var yearIncomePie: MCYPiePolyLineChartView! //收入百分比
    var isIn = false //是否已经加载了视图
    
    private var refreshView: RefreshHeaderView? //自己写的
    let wiatView = MyWaitView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setScroll()
        addCostPie()
        addIncomePie()
        
        setData()
    }
    
    //计算数据并显示
    func setData(){
        
        if !isIn {
            wiatView.showWait("计算中...")
            isIn = true
        }
        
        let PieChartPageQueue: dispatch_queue_t = dispatch_queue_create("PieChartPageQueue", DISPATCH_QUEUE_SERIAL)
        
        dispatch_async(PieChartPageQueue,{
            let dataDic1 = GetAnalyseData.getCostPercent()
            let dataDic2 = GetAnalyseData.getIncomePercent()
            let thisYearPayTotal = GetAnalyseData.getThisYearPayTotal() + GetAnalyseData.getCreditThisYearTotalPay()
            let strOne = "\(thisYearPayTotal)"
            
            let allRealSalary = GetAnalyseData.getAllRealSalary()
            var strTwo = "\(allRealSalary)"
            if allRealSalary == 0{
                strTwo = "无数据"
            }
            
            dispatch_async(mainQueue, {
                
                if dataDic1 != nil {
                    self.yearCostPie.setPieChartData(dataDic1!, holeText: strOne)
                }
                if dataDic2 != nil {
                    self.yearIncomePie.setPieChartData(dataDic2!, holeText: strTwo)
                }
                self.yearCostPie.setNeedsDisplay()
                self.yearIncomePie.setNeedsDisplay()
                
                self.wiatView.hideView()
                self.endFresh()
            })
        })
        
    }
    
    //设置ScrollView
    func setScroll(){
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: Width, height: Height-100-60))
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
        
        refreshView =  RefreshHeaderView(frame: scrollView.frame, subView: scrollView, target: self)  //添加下拉刷新
    }
    
    //设置第四个饼状图
    func addCostPie(){
        
        let viewFrame = CGRect(x: 0, y: 0, width: Width, height: Width*2/3)
        yearCostPie = MCYPiePolyLineChartView(frame: viewFrame, title: "今年花费比例")
        yearCostPie.frame = CGRect(x: 0, y: 0, width: Width, height: Width*2/3)
        self.scrollView.addSubview(yearCostPie)
    }
    
    //设置第五个饼状图
    func addIncomePie(){
        let viewFrame = CGRect(x: 0, y: 0, width: Width, height: Width*2/3)
        yearIncomePie = MCYPiePolyLineChartView(frame: viewFrame, title: "今年收入比例")
        yearIncomePie.frame = CGRect(x: 0, y: yearCostPie.frame.maxY+20, width: Width, height: Width*2/3)
        
        self.scrollView.addSubview(yearIncomePie)
        
        scrollView.contentSize = CGSize(width: Width, height: yearIncomePie.frame.maxY+20)
    }
    
    //结束刷新时调用
    func endFresh(){
        self.scrollView.scrollEnabled = true
        self.scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        
        self.refreshView?.endRefresh()
        let toast = MyToastView()
        toast.showToast("刷新完成！")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PieChartsViewController: isRefreshingDelegate{
    //isfreshing中的代理方法
    func reFreshing(){
        scrollView.setContentOffset(CGPointMake(0, -RefreshHeaderHeight), animated: true)
        scrollView.scrollEnabled = false
        //这里做你想做的事
        self.setData()
    }
}
