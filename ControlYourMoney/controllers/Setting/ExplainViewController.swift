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
        self.view.backgroundColor = UIColor.clearColor()
    }
    
    func setScroll(){
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: Width, height: Height))
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
    }
    
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
    
    func getStr() -> NSMutableAttributedString{
        let allStr = NSMutableAttributedString()
        let single = NSMutableArray()
        
        single.addObject(getArrtibuteStr("今日现金支出：今日现金支出\n", rang: NSMakeRange(0, 7)))
        single.addObject(getArrtibuteStr("本月现金支出：本月的现金支出\n", rang: NSMakeRange(0, 7)))
        single.addObject(getArrtibuteStr("现在现金余额：现在现金的余额\n", rang: NSMakeRange(0, 7)))
        single.addObject(getArrtibuteStr("实际本月支出：实际本月的现金支出＋本月信用所有还的\n", rang: NSMakeRange(0, 7)))
        single.addObject(getArrtibuteStr("今年现金支出：今年的现金支出（到次年2月，过年）\n", rang: NSMakeRange(0, 7)))
        single.addObject(getArrtibuteStr("今年总共支出：今年的现金支出 ＋ 今年的信用卡支出（到次年2月，过年）\n\n", rang: NSMakeRange(0, 7)))
        
        single.addObject(getArrtibuteStr("今年总共收入：目前总的收入，没有时间限制，有问题？？？\n", rang: NSMakeRange(0, 7)))
        single.addObject(getArrtibuteStr("目前总共财产：目前余额 － 行用卡剩余该还的\n\n", rang: NSMakeRange(0, 7)))
        
        single.addObject(getArrtibuteStr("预计本月支出：自己设置每月的固定支出额\n", rang: NSMakeRange(0, 7)))
        single.addObject(getArrtibuteStr("预计年底结余：根据每个月的收入，计算到次年2月（）年底双薪 ＋ 现有的余额 － 今年总开支（每月预计的支出＊剩余月份 ＋ 每年一次性支出 ＋ 信用卡今年总应还）（到次年2月，过年）\n", rang: NSMakeRange(0, 7)))
        single.addObject(getArrtibuteStr("预计月底结余：现有的 － 本月总支出（预计现金支出 ＋ 信用卡本月剩余应还）\n", rang: NSMakeRange(0, 7)))
        single.addObject(getArrtibuteStr("预计本年支出：每月预计的支出＊剩余月份 ＋ 每年一次性支出 ＋ 信用卡今年总应还（到次年2月，过年）\n\n", rang: NSMakeRange(0, 7)))
        
        single.addObject(getArrtibuteStr("本月信用总还：包括已还和本月还完到期的\n", rang: NSMakeRange(0, 7)))
        single.addObject(getArrtibuteStr("下月信用总还：下月信用总还\n", rang: NSMakeRange(0, 7)))
        single.addObject(getArrtibuteStr("所有信用余还：剩余未还完的\n", rang: NSMakeRange(0, 7)))
        single.addObject(getArrtibuteStr("本月信用余出：本月剩余应还的\n", rang: NSMakeRange(0, 7)))
        single.addObject(getArrtibuteStr("今年信用总还：今年信用总共还的，包括已还（到次年2月，过年）\n", rang: NSMakeRange(0, 7)))
        single.addObject(getArrtibuteStr("今年信用余还：今年信用还需要还的（到次年2月，过年）", rang: NSMakeRange(0, 7)))
        
        for i in 0 ..< single.count {
            allStr.appendAttributedString(single[i] as! NSMutableAttributedString)
        }
        return allStr
    }
    
    func getArrtibuteStr(str: String, rang: NSRange) -> NSMutableAttributedString{
        let strB = NSMutableAttributedString(string: str)
        strB.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: rang)
        return strB
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
