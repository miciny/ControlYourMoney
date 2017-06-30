//
//  MainTableHeaderView.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/11.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class MainTableHeaderView: UIView {
    
    fileprivate let totalLabel: UILabel! //财产
    fileprivate let lastLabel: UILabel! //可用
    fileprivate let shouldPayLabel: UILabel! //应还
    
    fileprivate let shouldPayText: UILabel!
    fileprivate let totalText: UILabel!
    fileprivate let lastText: UILabel!
    
    fileprivate var total: String! //总的财产
    fileprivate var last: String! //可用的数据
    fileprivate var shouldPay: String! //应还
    
    fileprivate var headerViewHeight: CGFloat!
    fileprivate var shouldPayType: Int! //显示 本月应还 还是 下月应还 的flag， 1为本月 0为下月
    fileprivate var creditTotal: Float! //所有信用应还
    
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
        self.setUpView()
        self.setUpData()
    }
    
    //显示数据
    func setUpLabelData(){
        self.shouldPayText.text = ""
        self.lastText.text = ""
        self.totalText.text = ""
        
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
    
    //设置元素
    func setUpView(){
        
        self.frame = CGRect(x: 0, y: 0, width: Width, height: headerViewHeight)
        self.backgroundColor = UIColor.white
        
        let totalSize = sizeWithText("财产：", font: totalFont, maxSize: CGSize(width: self.frame.width/2, height: headerViewHeight/3))
        self.totalText.frame = CGRect(x: 20, y: 0, width: totalSize.width , height: headerViewHeight/3)
        self.totalText.textAlignment = NSTextAlignment.left
        self.totalText.font = totalFont
        self.totalText.textColor = UIColor.black
        
        self.totalLabel.frame = CGRect(x: totalText.frame.maxX, y: 0, width: self.frame.width-totalText.frame.maxX-20 , height: headerViewHeight/3)
        self.totalLabel.textAlignment = NSTextAlignment.right
        self.totalLabel.font = totalFont
        self.totalLabel.textColor = UIColor.blue
        
        let lastSize = sizeWithText("可用：", font: lastFont, maxSize: CGSize(width: self.frame.width/2, height: headerViewHeight/3))
        self.lastText.frame = CGRect(x: 20, y: headerViewHeight/3, width: lastSize.width , height: headerViewHeight/3)
        self.lastText.textAlignment = NSTextAlignment.left
        self.lastText.font = lastFont
        self.lastText.textColor = UIColor.black
        
        self.lastLabel.frame = CGRect(x: lastText.frame.maxX, y: headerViewHeight/3, width: self.frame.width-lastText.frame.maxX-20, height: headerViewHeight/3)
        self.lastLabel.textAlignment = NSTextAlignment.right
        self.lastLabel.font = lastFont
        self.lastLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeLast))
        self.lastLabel.addGestureRecognizer(tap)
        self.lastLabel.textColor = UIColor.blue
        
        let shouldPaySize = sizeWithText("本月应还：", font: lastFont, maxSize: CGSize(width: self.frame.width/2, height: headerViewHeight/3))
        self.shouldPayText.frame = CGRect(x: 20, y: headerViewHeight*2/3, width: shouldPaySize.width, height: headerViewHeight/3)
        self.shouldPayText.textAlignment = NSTextAlignment.left
        self.shouldPayText.font = lastFont
        self.shouldPayText.textColor = UIColor.black
        
        self.shouldPayLabel.frame = CGRect(x: shouldPayText.frame.maxX, y: headerViewHeight*2/3, width: self.frame.width-shouldPayText.frame.maxX-20, height: headerViewHeight/3)
        self.shouldPayLabel.textAlignment = NSTextAlignment.right
        self.shouldPayLabel.font = lastFont
        self.shouldPayLabel.textColor = UIColor.blue
        
        self.addSubview(self.totalLabel)
        self.addSubview(self.totalText)
        self.addSubview(self.lastLabel)
        self.addSubview(self.lastText)
        self.addSubview(self.shouldPayLabel)
        self.addSubview(self.shouldPayText)
    }
    
    //提取数据
    func setUpData(){
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
            //这里写需要放到子线程做的耗时的代码
            var shouldPayData : Float = 0
            let thisMonthCreditLeftPay = GetAnalyseData.getCreditThisMonthLeftPay()
            if thisMonthCreditLeftPay > 0{
                self.shouldPayType = 1
                shouldPayData = thisMonthCreditLeftPay
            }else{
                self.shouldPayType = 0
                let nextMonthCredit = GetAnalyseData.getCreditNextMonthAllPay()
                shouldPayData = nextMonthCredit
            }
            
            //计算信用卡全部应还
            self.creditTotal = GetAnalyseData.getCreditTotalLeftPay()
            
            //显示总金额，可用和应还
            let lastData = GetAnalyseData.getCanUseToFloat()
            
            DispatchQueue.main.async(execute: {
                if self.creditTotal > 3000{
                    self.shouldPayLabel.textColor = UIColor.red
                }else{
                    self.shouldPayLabel.textColor = UIColor.green
                }
                
                if lastData < 1000{
                    self.lastLabel.textColor = UIColor.red
                }else{
                    self.lastLabel.textColor = UIColor.green
                }
                
                if -self.creditTotal + lastData < 1000{
                    self.totalLabel.textColor = UIColor.red
                }else{
                    self.totalLabel.textColor = UIColor.green
                }
                
                self.total = String(-self.creditTotal + lastData)
                self.last = String(format: "%.2f", lastData)
                self.shouldPay = String(shouldPayData)
                self.setUpLabelData()
            })
        })
    }
    
    //点击可用金额的label，跳转到改可用金额页面
    func changeLast(){
        self.delegate?.buttonClicked(self.last)
    }

}
