//
//  ChartRootViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/28.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class ChartsRootViewController: UIViewController, UIScrollViewDelegate{
    
    var mainScroll: UIScrollView!
    
    var currentPage:Int = 0
    var viewControllers = NSMutableArray()
    
    let lineTab = UIButton()
    let pieTab = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitle()
        setUpTop()
        setUpScrollView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpTitle(){
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
        self.title = "图表"
    }
    
    func setUpScrollView(){
        let y:CGFloat = CGRectGetMaxY(pieTab.frame) + 6
        let rect:CGRect = CGRectMake(0, y, Width, Height - 64)
        let scrollView = UIScrollView()
        scrollView.frame = rect
        view.addSubview(scrollView)
        mainScroll = scrollView
        
        addChildViewController()
        
        automaticallyAdjustsScrollViewInsets = false
        // 设置内容视图的 contentSize
        mainScroll.contentSize = CGSizeMake(CGFloat(childViewControllers.count) * Width, 0)
        // 设置整屏滑动
        mainScroll.pagingEnabled = true
        // 隐藏滚动条
        mainScroll.showsHorizontalScrollIndicator = false
        // 设置代理(必须先遵守协议!)
        mainScroll.delegate = self
        
        setUpOneChildViewController(0)
    }
    
    func selTitleBtn(btn: UIButton){
        let tag = btn.tag
        changeBtn(tag)
        
        let offset = Width * CGFloat(tag)
        mainScroll.setContentOffset(CGPointMake(offset, 0), animated: true)
        setUpOneChildViewController(tag)
    }
    
    func setUpTop(){
        lineTab.frame = CGRect(x: 20, y: 70, width: Width/2-20, height: 34)
        lineTab.setTitle("支出", forState: .Normal)
        lineTab.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        lineTab.backgroundColor = UIColor.blueColor()
        lineTab.tag = 0
        lineTab.addTarget(self, action: #selector(selTitleBtn(_:)), forControlEvents: .TouchUpInside)
        
        lineTab.layer.cornerRadius = 5
        lineTab.layer.borderWidth = 1
        lineTab.layer.borderColor = UIColor.blueColor().CGColor
        
        self.view.addSubview(lineTab)
        
        pieTab.frame = CGRect(x: Width/2, y: 70, width: Width/2-20, height: 34)
        pieTab.setTitle("比例", forState: .Normal)
        pieTab.setTitleColor(UIColor.blackColor(), forState: .Normal)
        pieTab.backgroundColor = UIColor.whiteColor()
        pieTab.tag = 1
        pieTab.addTarget(self, action: #selector(selTitleBtn(_:)), forControlEvents: .TouchUpInside)
        
        pieTab.layer.cornerRadius = 5
        pieTab.layer.borderWidth = 1
        pieTab.layer.borderColor = UIColor.blueColor().CGColor
        
        self.view.addSubview(pieTab)
    }
    
    /**  添加子控制器  */
    func addChildViewController(){
        let vc1 = LineChartsViewController()
        let vc2 = PieChartsViewController()
        
        addChildViewController(vc1)
        addChildViewController(vc2)
    }
    
    func setUpOneChildViewController(i: Int){
        // 显示当前 btn 个数对应的偏移量
        let x:CGFloat = CGFloat(i) * Width
        // 得到 btn 对应的控制器
        let vc = childViewControllers[i]
        // 如果视图存在结束函数
        if vc.view.superview != nil{
            return
        }
        // 设置当前视图控制器视图的 frame
        vc.view.frame = CGRectMake(x, 0, Width, Height - self.mainScroll.frame.origin.y)
        // 添加当前视图控制器的视图
        mainScroll.addSubview(vc.view)
    }
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let i = Int(offset.x/Width)
        changeBtn(i)
        setUpOneChildViewController(i)
    }
    
    func changeBtn(index: Int){
        switch index{
        case 0:
            lineTab.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            lineTab.backgroundColor = UIColor.blueColor()
            pieTab.setTitleColor(UIColor.blackColor(), forState: .Normal)
            pieTab.backgroundColor = UIColor.whiteColor()
        case 1:
            pieTab.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            pieTab.backgroundColor = UIColor.blueColor()
            lineTab.setTitleColor(UIColor.blackColor(), forState: .Normal)
            lineTab.backgroundColor = UIColor.whiteColor()
        default:
            break
        }
    }

}
