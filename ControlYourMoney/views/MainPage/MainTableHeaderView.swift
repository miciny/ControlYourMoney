//
//  MainTableHeaderView.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/11.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class MainTableHeaderView: UIView {
    
    private let totalLabel: UILabel! //财产
    private let lastLabel: UILabel! //可用
    private let shouldPayLabel: UILabel! //应还
    
    private let shouldPayText: UILabel!
    private let totalText: UILabel!
    private let lastText: UILabel!
    
    private var total: String! //总的财产
    private var last: String! //可用的数据
    private var shouldPay: String! //应还
    
    private var headerViewHeight: CGFloat!
    private var shouldPayType: Int! //显示 本月应还 还是 下月应还 的flag， 1为本月 0为下月
    private var creditTotal: Float! //所有信用应还
    
    var delegate : mainHeaderChangeLastDelegate?
    
    override init(frame: CGRect) {
        self.totalLabel = UILabel() //财产
        self.lastLabel = UILabel() //可用
        self.shouldPayLabel = UILabel() //应还
        
        self.shouldPayText = UILabel()
        self.totalText = UILabel()
        self.lastText = UILabel()
        
        self.total = String() //总的财产
        self.last = String() //可用的数据
        self.shouldPay = String() //应还
        
        self.headerViewHeight = 120
        self.shouldPayType = 0 //显示 本月应还 还是 下月应还 的flag， 1为本月 0为下月
        self.creditTotal = 0 //所有信用应还
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(viewHeight: CGFloat, target: mainHeaderChangeLastDelegate) {
        self.init()
        self.delegate = target
        self.headerViewHeight = viewHeight
        self.setUpData()
        self.setUpView()
        self.setUpLabelData()
    }
    
    func setUpLabelData(){
        
        self.totalText.text = "财产："
        self.lastText.text = "可用："
        if(self.shouldPayType == 0){
            self.shouldPayText.text = "下月应还："
        }else{
            self.shouldPayText.text = "本月应还："
        }
        
        self.totalLabel.text = self.total
        self.lastLabel.text = self.last
        self.shouldPayLabel.text = self.shouldPay
    }
    
    func setUpView(){
        
        self.frame = CGRectMake(0, 0, Width, headerViewHeight)
        self.backgroundColor = UIColor.whiteColor()
        
        let totalSize = sizeWithText("财产：", font: totalFont, maxSize: CGSizeMake(self.frame.width/2, headerViewHeight/3))
        self.totalText.frame = CGRectMake(20, 0, totalSize.width , headerViewHeight/3)
        self.totalText.textAlignment = NSTextAlignment.Left
        self.totalText.font = totalFont
        self.totalText.textColor = UIColor.redColor()
        
        self.totalLabel.frame = CGRectMake(totalText.frame.maxX, 0, self.frame.width-totalText.frame.maxX-20 , headerViewHeight/3)
        self.totalLabel.textAlignment = NSTextAlignment.Right
        self.totalLabel.font = totalFont
        self.totalLabel.textColor = UIColor.redColor()
        
        let lastSize = sizeWithText("可用：", font: lastFont, maxSize: CGSizeMake(self.frame.width/2, headerViewHeight/3))
        self.lastText.frame = CGRectMake(20, headerViewHeight/3, lastSize.width , headerViewHeight/3)
        self.lastText.textAlignment = NSTextAlignment.Left
        self.lastText.font = lastFont
        self.lastText.textColor = UIColor.blueColor()
        
        self.lastLabel.frame = CGRectMake(lastText.frame.maxX, headerViewHeight/3, self.frame.width-lastText.frame.maxX-20, headerViewHeight/3)
        self.lastLabel.textAlignment = NSTextAlignment.Right
        self.lastLabel.font = lastFont
        self.lastLabel.userInteractionEnabled = true
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeLast))
        self.lastLabel.addGestureRecognizer(tap)
        self.lastLabel.textColor = UIColor.blueColor()
        
        let shouldPaySize = sizeWithText("本月应还：", font: lastFont, maxSize: CGSizeMake(self.frame.width/2, headerViewHeight/3))
        self.shouldPayText.frame = CGRectMake(20, headerViewHeight*2/3, shouldPaySize.width, headerViewHeight/3)
        self.shouldPayText.textAlignment = NSTextAlignment.Left
        self.shouldPayText.font = lastFont
        self.shouldPayText.textColor = UIColor.blueColor()
        
        self.shouldPayLabel.frame = CGRectMake(shouldPayText.frame.maxX, headerViewHeight*2/3, self.frame.width-shouldPayText.frame.maxX-20, headerViewHeight/3)
        self.shouldPayLabel.textAlignment = NSTextAlignment.Right
        self.shouldPayLabel.font = lastFont
        self.shouldPayLabel.textColor = UIColor.blueColor()
        
        self.addSubview(self.totalLabel)
        self.addSubview(self.totalText)
        self.addSubview(self.lastLabel)
        self.addSubview(self.lastText)
        self.addSubview(self.shouldPayLabel)
        self.addSubview(self.shouldPayText)
    }
    
    //提取数据
    func setUpData(){
        let timeNow = getTime() //当前时间
        let creditArray = SQLLine.selectAllData(entityNameOfCredit)
        
        //显示本月应还／下月应还金额
        //无需判断本月还款已过的，因为过了之后，会自动到下个月
        var shouldPayData: Float = 0
        let creditTimeArray = creditArray.valueForKey(creditNameOfTime) as! NSArray
        let creditNumberArray = creditArray.valueForKey(creditNameOfNumber) as! NSArray
        let creditPeriodArray = creditArray.valueForKey(creditNameOfPeriods) as! NSArray
        
        let MM = dateToInt(timeNow, dd: "MM")
        
        //有一个月份与现月相同，则为本月
        for i in 0  ..< creditTimeArray.count{
            if(MM == dateToInt(creditTimeArray[i] as! NSDate, dd: "MM")){
                self.shouldPayType = 1
                break
            }
        }
        
        //计算本月或者下月应还
        if(self.shouldPayType == 1){
            for i in 0  ..< creditTimeArray.count{
                if(MM == dateToInt(creditTimeArray[i] as! NSDate, dd: "MM")){
                    shouldPayData = shouldPayData + (creditNumberArray[i] as! Float)
                }
            }
        }else{
            for i in 0  ..< creditTimeArray.count{
                if(MM == 12){
                    if(dateToInt(creditTimeArray[i] as! NSDate, dd: "MM") == 1){
                        shouldPayData = shouldPayData + (creditNumberArray[i] as! Float)
                    }
                }else{
                    if(dateToInt(creditTimeArray[i] as! NSDate, dd: "MM") == MM + 1){
                        shouldPayData = shouldPayData + (creditNumberArray[i] as! Float)
                    }
                }
            }
        }
        
        //计算信用卡全部应还
        for i in 0  ..< creditTimeArray.count{
            self.creditTotal = self.creditTotal - (creditPeriodArray[i] as! Float)*(creditNumberArray[i] as! Float)
        }
        
        //显示总金额，可用和应还
        let lastData = getCanUseToFloat()
        self.total = String(creditTotal + lastData)
        self.last = String(lastData)
        self.shouldPay = String(shouldPayData)
    }
    
    //点击可用金额的label，跳转到改可用金额页面
    func changeLast(){
        self.delegate?.buttonClicked(self.last)
    }

}
