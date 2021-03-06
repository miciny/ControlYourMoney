//
//  ChartRootViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/28.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class ChartsRootViewController: UIViewController, UIScrollViewDelegate{
    
    var mainScroll: UIScrollView! //用于加载视图的scrollView
    
    var currentPage: Int = 0 //当前页
    var viewControllers = NSMutableArray() //用于存储所需要显示的视图
    
    let lineTab = UIButton()  //显示line的按钮
    let pieTab = UIButton()  //显示pie的按钮
    let animationLine = UIView() //显示在title按钮底下的线

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitle()
        setUpTop()
        setUpScrollView()
        setAnimationLine()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpTitle(){
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
        self.title = "图表"
    }
    
    //设置scrollView
    func setUpScrollView(){
        automaticallyAdjustsScrollViewInsets = false
        
        let y = pieTab.frame.maxY + 6
        let rect = CGRect(x: 0, y: y, width: Width, height: Height - 64)
        mainScroll = UIScrollView()
        mainScroll.frame = rect
        mainScroll.isPagingEnabled = true // 设置整屏滑动
        mainScroll.showsHorizontalScrollIndicator = false // 隐藏滚动条
        mainScroll.delegate = self
        self.view.addSubview(mainScroll)
        
        addChildViewController()
        mainScroll.contentSize = CGSize(width: CGFloat(childViewControllers.count) * Width, height: 0)
        
        setUpOneChildViewController(0)
    }
    
    //顶部title按钮的点击事件
    func selTitleBtn(_ btn: UIButton){
        let tag = btn.tag
        changeBtn(tag)
        
        let offset = Width * CGFloat(tag)
        mainScroll.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        setUpOneChildViewController(tag)
    }
    
    //设置顶部title按钮
    func setUpTop(){
        lineTab.frame = CGRect(x: 0, y: 70, width: Width/2-1, height: 34)
        lineTab.setTitle("支出", for: UIControlState())
        lineTab.setTitleColor(UIColor.red, for: UIControlState())
        lineTab.backgroundColor = UIColor.clear
        lineTab.tag = 0
        lineTab.addTarget(self, action: #selector(selTitleBtn(_:)), for: .touchUpInside)
        self.view.addSubview(lineTab)
        
        let gapLine = UIView(frame: CGRect(x: Width/2, y: 67, width: 1, height: 40))
        gapLine.backgroundColor = UIColor.gray
        self.view.addSubview(gapLine)
        
        pieTab.frame = CGRect(x: Width/2+1, y: 70, width: Width/2, height: 34)
        pieTab.setTitle("比例", for: UIControlState())
        pieTab.setTitleColor(UIColor.black, for: UIControlState())
        pieTab.backgroundColor = UIColor.clear
        pieTab.tag = 1
        pieTab.addTarget(self, action: #selector(selTitleBtn(_:)), for: .touchUpInside)
        self.view.addSubview(pieTab)
    }
    
    //设置animationLine
    func setAnimationLine(){
        animationLine.frame = CGRect(x: lineTab.frame.minX + 10, y: mainScroll.frame.minY-2,
                                     width: lineTab.frame.width-20, height: 2)
        animationLine.backgroundColor = UIColor.red
        self.view.addSubview(animationLine)
    }
    
    /**  添加子控制器  */
    func addChildViewController(){
        let vc1 = LineChartsViewController()
        let vc2 = PieChartsViewController()
        
        addChildViewController(vc1)
        addChildViewController(vc2)
    }
    
    //添加视图到scrollView
    func setUpOneChildViewController(_ i: Int){
        let x:CGFloat = CGFloat(i) * Width  // 显示当前 btn 个数对应的偏移量
        let vc = childViewControllers[i] // 得到 btn 对应的控制器
        
        if vc.view.superview != nil{ // 如果视图存在结束函数
            return
        }
        
        vc.view.frame = CGRect(x: x, y: 0, width: Width, height: Height - self.mainScroll.frame.origin.y) // 设置当前视图控制器视图的 frame
        mainScroll.addSubview(vc.view) // 添加当前视图控制器的视图
    }
    
    //=====================================================================================================
    /**
     MARK: - ScrollView delegate
     **/
    //=====================================================================================================
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let i = Int(offset.x/Width)
        changeBtn(i)
        setUpOneChildViewController(i)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x //偏移量
        let realOffsetX = pieTab.frame.minX -  lineTab.frame.minX //总移动距离
        
        let x = offsetX * realOffsetX / Width //x坐标
        
        animationLine.frame = CGRect(x: x + 10, y: mainScroll.frame.minY-2,
                                     width: pieTab.frame.width-20, height: 2)
    }
    
    //改变title的颜色啥的
    func changeBtn(_ index: Int){
        switch index{
        case 0:
            lineTab.setTitleColor(UIColor.red, for: UIControlState())
            pieTab.setTitleColor(UIColor.black, for: UIControlState())
        case 1:
            pieTab.setTitleColor(UIColor.red, for: UIControlState())
            lineTab.setTitleColor(UIColor.black, for: UIControlState())
        default:
            break
        }
    }

}
