//
//  ExplainViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/26.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class ExplainViewController: UIViewController {
    var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitle()
        setScroll()
        setUpLabel()
        // Do any additional setup after loading the view.
    }
    
    func setUpTitle(){
        self.title = "说明"
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
    }
    
    // 设置scroll
    func setScroll(){
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: Width, height: Height))
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
    }
    
    // 设置label，用于显示文字
    func setUpLabel(){
        let str = getStr()
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: Width-20, height: 44))
        label.attributedText = str
        label.font = explainFont
        label.backgroundColor = UIColor.clearColor()
        label.numberOfLines = 0
        label.sizeToFit()
        
        scrollView.addSubview(label)
        scrollView.contentSize = CGSize(width: Width, height: label.frame.maxY+20)
    }
    
    //获取富文本
    func getStr() -> NSMutableAttributedString{
        let allStr = NSMutableAttributedString()
        let single = NSMutableArray()
        
        single.addObject(getArrtibuteStr("今日现金支出：统计今天的现金支出\n", rang: NSMakeRange(0, 7)))
        single.addObject(getArrtibuteStr("本月现金支出：统计本月的现金支出\n", rang: NSMakeRange(0, 7)))
        single.addObject(getArrtibuteStr("现在现金余额：统计现在的现金余额\n", rang: NSMakeRange(0, 7)))
        single.addObject(getArrtibuteStr("实际本月支出：实际本月的现金支出＋本月的所有信用还还款额\n", rang: NSMakeRange(0, 7)))
        single.addObject(getArrtibuteStr("今年现金支出：统计今年的现金支出（到次年2月）\n", rang: NSMakeRange(0, 7)))
        single.addObject(getArrtibuteStr("今年总共支出：今年的现金支出 ＋ 今年的信用卡总还款额（到次年2月）\n\n", rang: NSMakeRange(0, 7)))
        
        single.addObject(getArrtibuteStr("今年总共收入：统计今年的总收入\n", rang: NSMakeRange(0, 7)))
        single.addObject(getArrtibuteStr("目前总共财产：目前余额 － 信用卡剩余该还额\n\n", rang: NSMakeRange(0, 7)))
        
        single.addObject(getArrtibuteStr("预计本月支出：根据自己设置每月的固定支出额度表计算得出 ＋ 信用卡本月总还\n", rang: NSMakeRange(0, 7)))
        single.addObject(getArrtibuteStr("预计年底结余：根据每个月的收入 x 剩余月份（不包括本月，计算到到次年2月，年底双薪）＋ 目前余额 － 今年总开支（每月预计的支出＊剩余月份 ＋ 每年一次性支出 ／ 12 x 剩余月份 ＋ 信用卡今年总应还）\n", rang: NSMakeRange(0, 7)))
        single.addObject(getArrtibuteStr("预计月底结余：目前余额 － 本月总支出（预计现金支出 ＋ 信用卡本月剩余应还）（不准）\n", rang: NSMakeRange(0, 7)))
        single.addObject(getArrtibuteStr("预计本年支出：每月预计的支出＊剩余月份 ＋ 每年一次性支出 ／ 12 x 剩余月份 ＋ 信用卡今年剩余还款额（到次年2月）\n\n", rang: NSMakeRange(0, 7)))
        
        single.addObject(getArrtibuteStr("本月信用总还：统计包括已还和本月还完到期的\n", rang: NSMakeRange(0, 7)))
        single.addObject(getArrtibuteStr("下月信用总还：统计下月信用总还\n", rang: NSMakeRange(0, 7)))
        single.addObject(getArrtibuteStr("所有信用余还：统计所有剩余未还完的信用款\n", rang: NSMakeRange(0, 7)))
        single.addObject(getArrtibuteStr("本月信用余出：统计本月信用剩余应还的\n", rang: NSMakeRange(0, 7)))
        single.addObject(getArrtibuteStr("今年信用总还：统计今年信用总共还的，包括已还（到次年2月）\n", rang: NSMakeRange(0, 7)))
        single.addObject(getArrtibuteStr("今年信用余还：统计今年信用还需要还的（到次年2月）", rang: NSMakeRange(0, 7)))
        
        for i in 0 ..< single.count {
            allStr.appendAttributedString(single[i] as! NSMutableAttributedString)
        }
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        paragraphStyle.alignment = .Left  //靠左
        paragraphStyle.lineSpacing = 5 //行间距
        
        allStr.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, allStr.length))
        
        return allStr
    }
    
    // 设置富文本，前7个字是蓝色的
    func getArrtibuteStr(str: String, rang: NSRange) -> NSMutableAttributedString{
        let strB = NSMutableAttributedString(string: str)
        strB.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: rang)
        return strB
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
