//
//  AddedTableViewCell.swift
//  YaQiHahah
//
//  Created by maocaiyuan on 15/12/14.
//  Copyright © 2015年 maocaiyuan. All rights reserved.
//

import UIKit

enum dataTpye {
    case credit
    case salary
    case cash
    case cashDetail
    case salaryDetail
}

class MainTableViewCell: UITableViewCell {
    
    var dataLable: UILabel?
    var dataLine: UIView?
    var dataNumber1: UILabel?
    var dataNumber2: UILabel?
    var dataNumber11: UILabel?
    var dataNumber22: UILabel?
    var dataNumber111: UILabel?
    var dataNumber222: UILabel?
    var dataNumber1111: UILabel?
    var dataNumber2222: UILabel?
    var dataNumber111111: UILabel?
    
    var dataModul: AnyObject?
    
    init(data: AnyObject, dataType: dataTpye, reuseIdentifier cellId:String){
        let dataTypt = dataType
        self.dataModul = data
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier:cellId)
        self.setUpLabel()
        self.setLable(dataTypt)
    }
    
    func setLable(dataType: dataTpye){
        switch dataType {
        case .credit:
            self.setUpCreditLabel()
        case .salary:
            self.setUpSalaryLabel()
        case .cash:
            self.setUpCashLabel()
        case .cashDetail:
            self.setUpCashDetailLabel()
        case .salaryDetail:
            self.setUpSalaryDetailLabel()
        }
    }
    
    func setUpLabel(){
        
        self.dataLable = UILabel(frame: CGRectZero)
        self.dataLable!.font = detailTitleFont
        self.dataLable!.textAlignment = NSTextAlignment.Center
        self.dataLable!.backgroundColor = UIColor.clearColor()
        self.dataLable!.textColor = UIColor.blackColor()
        
        self.dataLine = UIView(frame: CGRectZero)
        self.dataLine!.backgroundColor = UIColor.lightGrayColor()
        
        self.dataNumber1 = UILabel(frame: CGRectZero)
        self.dataNumber1!.font = detailFont
        self.dataNumber1!.textAlignment = NSTextAlignment.Left
        self.dataNumber1!.backgroundColor = UIColor.clearColor()
        self.dataNumber1!.textColor = UIColor.blackColor()
        
        self.dataNumber2 = UILabel(frame: CGRectZero)
        self.dataNumber2!.font = detailFont
        self.dataNumber2!.textAlignment = NSTextAlignment.Right
        self.dataNumber2!.backgroundColor = UIColor.clearColor()
        self.dataNumber2!.textColor = UIColor.redColor()
        
        self.dataNumber11 = UILabel(frame: CGRectZero)
        self.dataNumber11!.font = detailFont
        self.dataNumber11!.textAlignment = NSTextAlignment.Left
        self.dataNumber11!.backgroundColor = UIColor.clearColor()
        self.dataNumber11!.textColor = UIColor.blackColor()
        
        self.dataNumber22 = UILabel(frame: CGRectZero)
        self.dataNumber22!.font = detailFont
        self.dataNumber22!.textAlignment = NSTextAlignment.Right
        self.dataNumber22!.backgroundColor = UIColor.clearColor()
        self.dataNumber22!.textColor = UIColor.redColor()
        
        self.dataNumber111 = UILabel(frame: CGRectZero)
        self.dataNumber111!.font = detailFont
        self.dataNumber111!.textAlignment = NSTextAlignment.Left
        self.dataNumber111!.backgroundColor = UIColor.clearColor()
        self.dataNumber111!.textColor = UIColor.blackColor()
        
        self.dataNumber222 = UILabel(frame: CGRectZero)
        self.dataNumber222!.font = detailFont
        self.dataNumber222!.textAlignment = NSTextAlignment.Right
        self.dataNumber222!.backgroundColor = UIColor.clearColor()
        self.dataNumber222!.textColor = UIColor.redColor()
        
        self.dataNumber1111 = UILabel(frame: CGRectZero)
        self.dataNumber1111!.font = detailFont
        self.dataNumber1111!.textAlignment = NSTextAlignment.Left
        self.dataNumber1111!.backgroundColor = UIColor.clearColor()
        self.dataNumber1111!.textColor = UIColor.blackColor()
        
        self.dataNumber2222 = UILabel(frame: CGRectZero)
        self.dataNumber2222!.font = detailFont
        self.dataNumber2222!.textAlignment = NSTextAlignment.Right
        self.dataNumber2222!.backgroundColor = UIColor.clearColor()
        self.dataNumber2222!.textColor = UIColor.redColor()
    }
    
    //设置信用卡的label
    func setUpCreditLabel(){
        
        self.addSubview(self.dataLable!)
        self.addSubview(self.dataLine!)
        self.addSubview(self.dataNumber1!)
        self.addSubview(self.dataNumber2!)
        self.addSubview(self.dataNumber11!)
        self.addSubview(self.dataNumber22!)
        self.addSubview(self.dataNumber111!)
        self.addSubview(self.dataNumber222!)
        self.addSubview(self.dataNumber1111!)
        self.addSubview(self.dataNumber2222!)
        
        let modul = self.dataModul as! MainTableCreditModul
        
        let size = sizeWithText(modul.title, font: detailTitleFont, maxSize: CGSizeMake(Width, 30))
        let size1 = sizeWithText("剩余周期：", font: detailFont, maxSize: CGSizeMake(Width, 30))
        self.dataLable!.frame = CGRectMake((Width-size.width)/2, 0, size.width, 30)
        self.dataLine!.frame = CGRectMake(self.dataLable!.frame.minX, self.dataLable!.frame.maxY+2, size.width, 1)
        
        self.dataNumber1!.frame = CGRectMake(20, self.dataLable!.frame.maxY+10, size1.width, 15)
        self.dataNumber2!.frame = CGRectMake(self.dataNumber1!.frame.maxX, self.dataLable!.frame.maxY+10, Width-self.dataNumber1!.frame.maxX-20, 15)
        
        self.dataNumber11!.frame = CGRectMake(20, self.dataLable!.frame.maxY+30, size1.width, 15)
        self.dataNumber22!.frame = CGRectMake(self.dataNumber11!.frame.maxX, self.dataLable!.frame.maxY+30, Width-self.dataNumber11!.frame.maxX-20, 15)
        
        self.dataNumber111!.frame = CGRectMake(20, self.dataLable!.frame.maxY+50, size1.width, 15)
        self.dataNumber222!.frame = CGRectMake(self.dataNumber111!.frame.maxX, self.dataLable!.frame.maxY+50, Width-self.dataNumber111!.frame.maxX-20, 15)
        
        self.dataNumber1111!.frame = CGRectMake(20, self.dataLable!.frame.maxY+70, size1.width, 15)
        self.dataNumber2222!.frame = CGRectMake(self.dataNumber1111!.frame.maxX, self.dataLable!.frame.maxY+70, Width-self.dataNumber1111!.frame.maxX-20, 15)
        
        self.dataLable!.text = modul.title
        self.dataNumber1!.text = "剩余周期："
        self.dataNumber2!.text = modul.periods
        self.dataNumber11!.text = "还款金额："
        self.dataNumber22!.text = modul.number
        self.dataNumber111!.text = "还款时间："
        self.dataNumber222!.text = modul.time
        self.dataNumber1111!.text = "还款总额："
        self.dataNumber2222!.text = modul.all
        
    }
    
    //设置工资的label
    func setUpSalaryLabel(){
        
        
        self.addSubview(self.dataLable!)
        self.addSubview(self.dataLine!)
        self.addSubview(self.dataNumber1!)
        self.addSubview(self.dataNumber2!)
        self.addSubview(self.dataNumber11!)
        self.addSubview(self.dataNumber22!)
        
        let modul = self.dataModul as! MainTableSalaryModul
        
        let size = sizeWithText(modul.date, font: detailTitleFont, maxSize: CGSizeMake(Width, 30))
        let size1 = sizeWithText("金额：", font: detailFont, maxSize: CGSizeMake(Width, 30))
        self.dataLable!.frame = CGRectMake((Width-size.width)/2, 0, size.width, 30)
        self.dataLine!.frame = CGRectMake(self.dataLable!.frame.minX, self.dataLable!.frame.maxY+2, size.width, 1)
        
        self.dataNumber1!.frame = CGRectMake(20, self.dataLable!.frame.maxY+10, size1.width, 15)
        self.dataNumber2!.frame = CGRectMake(self.dataNumber1!.frame.maxX, self.dataLable!.frame.maxY+10, Width-self.dataNumber1!.frame.maxX-20, 15)
        
        self.dataNumber11!.frame = CGRectMake(20, self.dataLable!.frame.maxY+30, size1.width, 15)
        self.dataNumber22!.frame = CGRectMake(self.dataNumber11!.frame.maxX, self.dataLable!.frame.maxY+30, Width-self.dataNumber11!.frame.maxX-20, 15)
        
        self.dataLable!.text = modul.date
        self.dataNumber1!.text = "金额："
        self.dataNumber2!.text = modul.number
        self.dataNumber11!.text = "时间："
        self.dataNumber22!.text = modul.time

    }
    
    //设置现金的label
    func setUpCashLabel(){
        
        self.addSubview(self.dataLable!)
        self.addSubview(self.dataLine!)
        self.addSubview(self.dataNumber1!)
        self.addSubview(self.dataNumber2!)
        self.addSubview(self.dataNumber11!)
        self.addSubview(self.dataNumber22!)
        self.addSubview(self.dataNumber111!)
        self.addSubview(self.dataNumber222!)
        self.addSubview(self.dataNumber1111!)
        self.addSubview(self.dataNumber2222!)
        
        let modul = self.dataModul as! MainTableCashModul
        
        let size = sizeWithText(modul.useWhere, font: detailTitleFont, maxSize: CGSizeMake(Width, 30))
        let size1 = sizeWithText("金额：", font: detailFont, maxSize: CGSizeMake(Width, 30))
        let size2 = sizeWithText("日总额：", font: detailFont, maxSize: CGSizeMake(Width, 30))
        self.dataLable!.frame = CGRectMake((Width-size.width)/2, 0, size.width, 30)
        self.dataLine!.frame = CGRectMake(self.dataLable!.frame.minX, self.dataLable!.frame.maxY+2, size.width, 1)
        
        self.dataNumber1!.frame = CGRectMake(20, self.dataLable!.frame.maxY+10, size1.width, 15)
        self.dataNumber2!.frame = CGRectMake(self.dataNumber1!.frame.maxX, self.dataLable!.frame.maxY+10, Width-self.dataNumber1!.frame.maxX-20, 15)
        
        self.dataNumber11!.frame = CGRectMake(20, self.dataLable!.frame.maxY+30, size1.width, 15)
        self.dataNumber22!.frame = CGRectMake(self.dataNumber11!.frame.maxX, self.dataLable!.frame.maxY+30, Width-self.dataNumber11!.frame.maxX-20, 15)
        
        self.dataNumber111!.frame = CGRectMake(20, self.dataLable!.frame.maxY+50, size2.width, 15)
        self.dataNumber222!.frame = CGRectMake(self.dataNumber111!.frame.maxX, self.dataLable!.frame.maxY+50, Width-self.dataNumber111!.frame.maxX-20, 15)
        
        self.dataNumber1111!.frame = CGRectMake(20, self.dataLable!.frame.maxY+70, size2.width, 15)
        self.dataNumber2222!.frame = CGRectMake(self.dataNumber1111!.frame.maxX, self.dataLable!.frame.maxY+70, Width-self.dataNumber1111!.frame.maxX-20, 15)
        
        self.dataLable!.text = modul.useWhere
        self.dataNumber1!.text = "金额："
        self.dataNumber2!.text = modul.useNumber
        self.dataNumber11!.text = "时间："
        self.dataNumber22!.text = modul.useTime
        self.dataNumber111!.text = "日总额："
        self.dataNumber222!.text = modul.useTotalDayStr
        self.dataNumber1111!.text = "月总额："
        self.dataNumber2222!.text = modul.useTotalStr
    }
    
    //设置现金详情列表也的label
    func setUpCashDetailLabel(){
        
        self.addSubview(self.dataLable!)
        self.addSubview(self.dataLine!)
        self.addSubview(self.dataNumber1!)
        self.addSubview(self.dataNumber2!)
        self.addSubview(self.dataNumber11!)
        self.addSubview(self.dataNumber22!)
        self.addSubview(self.dataNumber111!)
        self.addSubview(self.dataNumber222!)
        
        let modul = self.dataModul as! CashDetailTableDataModul
        
        let size = sizeWithText(modul.type, font: detailTitleFont, maxSize: CGSizeMake(Width, 30))
        let size1 = sizeWithText("金额：", font: detailFont, maxSize: CGSizeMake(Width, 30))
        self.dataLable!.frame = CGRectMake((Width-size.width)/2, 0, size.width, 30)
        self.dataLine!.frame = CGRectMake(self.dataLable!.frame.minX, self.dataLable!.frame.maxY+2, size.width, 1)
        
        self.dataNumber1!.frame = CGRectMake(20, self.dataLable!.frame.maxY+10, size1.width, 15)
        self.dataNumber2!.frame = CGRectMake(self.dataNumber1!.frame.maxX, self.dataLable!.frame.maxY+10, Width-self.dataNumber1!.frame.maxX-20, 15)
        
        self.dataNumber11!.frame = CGRectMake(20, self.dataLable!.frame.maxY+30, size1.width, 15)
        self.dataNumber22!.frame = CGRectMake(self.dataNumber11!.frame.maxX, self.dataLable!.frame.maxY+30, Width-self.dataNumber11!.frame.maxX-20, 15)
        
        self.dataNumber111!.frame = CGRectMake(20, self.dataLable!.frame.maxY+50, size1.width, 15)
        self.dataNumber222!.frame = CGRectMake(self.dataNumber111!.frame.maxX, self.dataLable!.frame.maxY+50, Width-self.dataNumber111!.frame.maxX-20, 15)
        
        self.dataLable!.text = modul.type
        self.dataNumber1!.text = "金额："
        self.dataNumber2!.text = modul.useNumber
        self.dataNumber11!.text = "时间："
        self.dataNumber22!.text = modul.useTime
        self.dataNumber111!.text = "用途："
        self.dataNumber222!.text = modul.useWhere
        
    }
    
    
    //设置工资详情列表也的label
    func setUpSalaryDetailLabel(){
        
        self.addSubview(self.dataLable!)
        self.addSubview(self.dataLine!)
        self.addSubview(self.dataNumber1!)
        self.addSubview(self.dataNumber2!)
        self.addSubview(self.dataNumber11!)
        self.addSubview(self.dataNumber22!)
        self.addSubview(self.dataNumber111!)
        self.addSubview(self.dataNumber222!)
        
        let modul = self.dataModul as! SalaryDetailTableDataModul
        
        let size = sizeWithText(modul.date, font: detailTitleFont, maxSize: CGSizeMake(Width, 30))
        let size1 = sizeWithText("金额：", font: detailFont, maxSize: CGSizeMake(Width, 30))
        self.dataLable!.frame = CGRectMake((Width-size.width)/2, 0, size.width, 30)
        self.dataLine!.frame = CGRectMake(self.dataLable!.frame.minX, self.dataLable!.frame.maxY+2, size.width, 1)
        
        self.dataNumber1!.frame = CGRectMake(20, self.dataLable!.frame.maxY+10, size1.width, 15)
        self.dataNumber2!.frame = CGRectMake(self.dataNumber1!.frame.maxX, self.dataLable!.frame.maxY+10, Width-self.dataNumber1!.frame.maxX-20, 15)
        
        self.dataNumber11!.frame = CGRectMake(20, self.dataLable!.frame.maxY+30, size1.width, 15)
        self.dataNumber22!.frame = CGRectMake(self.dataNumber11!.frame.maxX, self.dataLable!.frame.maxY+30, Width-self.dataNumber11!.frame.maxX-20, 15)
        
        self.dataNumber111!.frame = CGRectMake(20, self.dataLable!.frame.maxY+50, size1.width, 15)
        self.dataNumber222!.frame = CGRectMake(self.dataNumber111!.frame.maxX, self.dataLable!.frame.maxY+50, Width-self.dataNumber111!.frame.maxX-20, 15)
        
        self.dataLable!.text = modul.date
        self.dataNumber1!.text = "金额："
        self.dataNumber2!.text = modul.number
        self.dataNumber11!.text = "时间："
        self.dataNumber22!.text = modul.time
        self.dataNumber111!.text = "来源："
        self.dataNumber222!.text = modul.type
        
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
