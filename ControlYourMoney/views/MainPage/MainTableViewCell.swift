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
    var dataNumber1: UILabel?
    var dataNumber2: UILabel?
    var dataNumber11: UILabel?
    var dataNumber22: UILabel?
    var dataNumber111: UILabel?
    var dataNumber222: UILabel?
    
    var creditCellHeight = CGFloat(130)
    var cashDetailCellHeight = CGFloat(120)
    var salaryCellHeight = CGFloat(90)
    var salaryDetailCellHeight = CGFloat(120)
    
    var dataModul: AnyObject?
    
    init(data: AnyObject, dataType: dataTpye, reuseIdentifier cellId:String){
        let dataTypt = dataType
        self.dataModul = data
        super.init(style: UITableViewCellStyle.default, reuseIdentifier:cellId)
        self.setUpLabel()
        self.setLable(dataTypt)
    }
    
    func setLable(_ dataType: dataTpye){
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
        
        self.dataLable = UILabel(frame: CGRect.zero)
        self.dataLable!.font = detailTitleFont
        self.dataLable!.textAlignment = NSTextAlignment.center
        self.dataLable!.backgroundColor = UIColor.clear
        self.dataLable!.textColor = UIColor.black
        
        self.dataNumber1 = UILabel(frame: CGRect.zero)
        self.dataNumber1!.font = detailFont
        self.dataNumber1!.textAlignment = NSTextAlignment.left
        self.dataNumber1!.backgroundColor = UIColor.clear
        self.dataNumber1!.textColor = UIColor.black
        
        self.dataNumber2 = UILabel(frame: CGRect.zero)
        self.dataNumber2!.font = detailFont
        self.dataNumber2!.textAlignment = NSTextAlignment.right
        self.dataNumber2!.backgroundColor = UIColor.clear
        self.dataNumber2!.textColor = UIColor.red
        
        self.dataNumber11 = UILabel(frame: CGRect.zero)
        self.dataNumber11!.font = detailFont
        self.dataNumber11!.textAlignment = NSTextAlignment.left
        self.dataNumber11!.backgroundColor = UIColor.clear
        self.dataNumber11!.textColor = UIColor.black
        
        self.dataNumber22 = UILabel(frame: CGRect.zero)
        self.dataNumber22!.font = detailFont
        self.dataNumber22!.textAlignment = NSTextAlignment.right
        self.dataNumber22!.backgroundColor = UIColor.clear
        self.dataNumber22!.textColor = UIColor.red
        
        self.dataNumber111 = UILabel(frame: CGRect.zero)
        self.dataNumber111!.font = detailFont
        self.dataNumber111!.textAlignment = NSTextAlignment.left
        self.dataNumber111!.backgroundColor = UIColor.clear
        self.dataNumber111!.textColor = UIColor.black
        
        self.dataNumber222 = UILabel(frame: CGRect.zero)
        self.dataNumber222!.font = detailFont
        self.dataNumber222!.textAlignment = NSTextAlignment.right
        self.dataNumber222!.backgroundColor = UIColor.clear
        self.dataNumber222!.textColor = UIColor.red
    }
    
    //设置信用卡的label
    func setUpCreditLabel(){
        
        self.addSubview(self.dataLable!)
        self.addSubview(self.dataNumber1!)
        self.addSubview(self.dataNumber2!)
        self.addSubview(self.dataNumber11!)
        self.addSubview(self.dataNumber22!)
        
        let modul = self.dataModul as! MainTableCreditModul
        
        let size = sizeWithText(modul.title, font: detailTitleFont, maxSize: CGSize(width: Width, height: creditCellHeight/3))
        let size1 = sizeWithText("剩余周期：", font: detailFont, maxSize: CGSize(width: Width, height: 30))
        self.dataLable!.frame = CGRect(x: (Width*2/3-size.width)/2, y: 0, width: size.width, height: creditCellHeight/3)
        
        self.dataNumber1!.frame = CGRect(x: 20, y: self.dataLable!.frame.maxY, width: size1.width, height: self.dataLable!.frame.height)
        self.dataNumber2!.frame = CGRect(x: self.dataNumber1!.frame.maxX, y: self.dataNumber1!.frame.minY, width: Width*2/3-self.dataNumber1!.frame.maxX-10, height: self.dataLable!.frame.height)

        self.dataNumber11!.frame = CGRect(x: 20, y: self.dataNumber1!.frame.maxY, width: size1.width, height: self.dataLable!.frame.height)
        self.dataNumber22!.frame = CGRect(x: self.dataNumber11!.frame.maxX, y: self.dataNumber11!.frame.minY, width: Width*2/3-self.dataNumber11!.frame.maxX-10, height: self.dataLable!.frame.height)
        
        self.dataLable!.text = modul.title
        self.dataNumber1!.text = "还款时间："
        self.dataNumber2!.text = modul.time
        self.dataNumber11!.text = "还款总额："
        self.dataNumber22!.text = modul.all
        
        let titles = ["", ""] //["已还周期", "未还周期"]
        let values : [Double] = [Double(modul.allPeriods)!-Double(modul.periods)!, Double(modul.periods)!]
        let strOne = "\(Int(modul.allPeriods)!-Int(modul.periods)!)/\(modul.allPeriods)"
        let strTwo = "每期:\(modul.number)"
        
        let viewFrame = CGRect(x: 0, y: 0, width: self.creditCellHeight, height: self.creditCellHeight)
        let pie = MCYCreditPieChartView(frame: viewFrame, title: "", holeText: strOne+"\n"+strTwo)
        pie.frame = CGRect(x: Width*2/3+Width/6-self.creditCellHeight/2, y: 0, width: self.creditCellHeight, height: self.creditCellHeight)
        pie.setPieChartData(titles, values: values)
        
        self.addSubview(pie)
    }
    
    //设置工资的label
    func setUpSalaryLabel(){
        self.addSubview(self.dataLable!)
        self.addSubview(self.dataNumber1!)
        self.addSubview(self.dataNumber2!)
        self.addSubview(self.dataNumber11!)
        self.addSubview(self.dataNumber22!)
        
        let modul = self.dataModul as! MainTableSalaryModul
        
        let size = sizeWithText(modul.date, font: detailTitleFont, maxSize: CGSize(width: Width, height: 300))
        let size1 = sizeWithText("金额：", font: detailFont, maxSize: CGSize(width: Width, height: 300))
        let size2 = sizeWithText(modul.time, font: detailFont, maxSize: CGSize(width: Width, height: 300))
        let size3 = sizeWithText(modul.number, font: useNumberFont, maxSize: CGSize(width: Width, height: 300))
        
        self.dataLable!.frame = CGRect(x: (Width*2/3-size.width)/2, y: 0, width: size.width, height: salaryCellHeight/3)
        
        self.dataNumber1!.frame = CGRect(x: 20, y: self.dataLable!.frame.maxY, width: size1.width, height: self.dataLable!.frame.height)
        self.dataNumber2!.frame = CGRect(x: Width-size3.width-10, y: self.dataLable!.frame.maxY-10, width: size3.width, height: size3.height)
        self.dataNumber2!.font = useNumberFont
        
        self.dataNumber11!.frame = CGRect(x: 20, y: self.dataLable!.frame.maxY+30, width: size1.width, height: salaryCellHeight/3)
        self.dataNumber22!.frame = CGRect(x: self.dataNumber11!.frame.maxX, y: self.dataNumber11!.frame.minY, width: size2.width, height: salaryCellHeight/3)
        
        self.dataLable!.text = modul.date
        self.dataNumber1!.text = "金额："
        self.dataNumber2!.text = modul.number
        self.dataNumber11!.text = "时间："
        self.dataNumber22!.text = modul.time

    }
    
    //设置现金的label
    func setUpCashLabel(){
        
        self.addSubview(self.dataLable!)
        self.addSubview(self.dataNumber1!)
        self.addSubview(self.dataNumber2!)
        self.addSubview(self.dataNumber11!)
        self.addSubview(self.dataNumber22!)
        
        let modul = self.dataModul as! MainTableCashModul
        
        let size = sizeWithText(modul.useWhere, font: detailTitleFont, maxSize: CGSize(width: Width, height: 30))
        let size1 = sizeWithText("金额：", font: detailFont, maxSize: CGSize(width: Width, height: 30))
        let size2 = sizeWithText("日总额：", font: detailFont, maxSize: CGSize(width: Width, height: 30))
        let size3 = sizeWithText(modul.useTotalStr, font: detailFont, maxSize: CGSize(width: Width, height: 30))
        let size4 = sizeWithText(modul.useNumber, font: useNumberFont, maxSize: CGSize(width: Width, height: 30))
        self.dataLable!.frame = CGRect(x: (Width*2/3-size.width)/2, y: 0, width: size.width, height: creditCellHeight/3)
        
        self.dataNumber1!.frame = CGRect(x: 20, y: self.dataLable!.frame.maxY, width: size1.width, height: self.dataLable!.frame.height)
        
        self.dataNumber11!.frame = CGRect(x: 20, y: self.dataNumber1!.frame.maxY, width: size2.width, height: self.dataLable!.frame.height)
        self.dataNumber22!.frame = CGRect(x: self.dataNumber11!.frame.maxX, y: self.dataNumber11!.frame.minY, width: size3.width, height: self.dataLable!.frame.height)
        
        self.dataNumber2!.frame = CGRect(x: Width*5/6-self.creditCellHeight/2-10-size4.width, y: self.dataNumber1!.frame.minY, width: size4.width, height: size4.height)
        
        self.dataLable!.text = modul.useWhere
        self.dataNumber1!.text = "金额："
        self.dataNumber2!.text = modul.useNumber
        self.dataNumber2!.font = useNumberFont
        self.dataNumber11!.text = "月总额："
        self.dataNumber22!.text = modul.useTotalStr
        self.dataNumber22!.textAlignment = .left
        
        let titles = ["", ""] //["平均", "今日"]
        let dayOffset = getTime().currentDay
        let avg = Double(modul.useTotalStr)!/Double(dayOffset)
        let values : [Double] = [avg, Double(modul.useTotalDayStr)!]
        let strOne = "今日:\(modul.useTotalDayStr)"
        let strTwo = "平均:\(String(format: "%.2f", avg))"
        
        let viewFrame = CGRect(x: 0, y: 0, width: self.creditCellHeight, height: self.creditCellHeight)
        let pie = MCYCreditPieChartView(frame: viewFrame, title: "", holeText: strOne+"\n"+strTwo)
        pie.frame = CGRect(x: Width*2/3+Width/6-self.creditCellHeight/2, y: 0, width: self.creditCellHeight, height: self.creditCellHeight)
        pie.setPieChartData(titles, values: values)
        
        self.addSubview(pie)
    }
    
    //设置现金详情列表也的label
    func setUpCashDetailLabel(){
        
        self.addSubview(self.dataLable!)
        self.addSubview(self.dataNumber2!)
        self.addSubview(self.dataNumber11!)
        self.addSubview(self.dataNumber22!)
        self.addSubview(self.dataNumber111!)
        self.addSubview(self.dataNumber222!)
        
        let modul = self.dataModul as! CashDetailTableDataModul
        
        let size = sizeWithText(modul.type, font: detailTitleFont, maxSize: CGSize(width: Width, height: 100))
        let size1 = sizeWithText("金额：", font: detailFont, maxSize: CGSize(width: Width, height: 300))
        let size2 = sizeWithText(modul.useWhere, font: detailFont, maxSize: CGSize(width: Width, height: 300))
        let size3 = sizeWithText(modul.useTime, font: detailFont, maxSize: CGSize(width: Width, height: 300))
        let size4 = sizeWithText(modul.useNumber, font: useNumberFont, maxSize: CGSize(width: Width, height: 300))
        
        self.dataLable!.frame = CGRect(x: (Width*2/3-size.width)/2, y: 0, width: size.width, height: cashDetailCellHeight/3)
        
        self.dataNumber2!.frame = CGRect(x: Width-size4.width-10, y: self.dataLable!.frame.maxY-10, width: size4.width, height: self.dataLable!.frame.height)
        self.dataNumber2!.font = useNumberFont
        
        self.dataNumber11!.frame = CGRect(x: 20, y: self.dataLable!.frame.maxY, width: size1.width, height: self.dataLable!.frame.height)
        self.dataNumber22!.frame = CGRect(x: self.dataNumber11!.frame.maxX, y: self.dataNumber11!.frame.minY, width: size2.width, height: self.dataLable!.frame.height)
        
        self.dataNumber111!.frame = CGRect(x: 20, y: self.dataNumber11!.frame.maxY, width: size1.width, height: self.dataLable!.frame.height)
        self.dataNumber222!.frame = CGRect(x: self.dataNumber111!.frame.maxX, y: self.dataNumber111!.frame.minY, width: size3.width, height: self.dataNumber111!.frame.height)
        
        self.dataLable!.text = modul.type
        self.dataNumber2!.text = modul.useNumber
        self.dataNumber111!.text = "时间："
        self.dataNumber222!.text = modul.useTime
        self.dataNumber11!.text = "用途："
        self.dataNumber22!.text = modul.useWhere
        
    }
    
    //设置工资详情列表也的label
    func setUpSalaryDetailLabel(){
        
        self.addSubview(self.dataLable!)
        self.addSubview(self.dataNumber2!)
        self.addSubview(self.dataNumber11!)
        self.addSubview(self.dataNumber22!)
        self.addSubview(self.dataNumber111!)
        self.addSubview(self.dataNumber222!)
        
        let modul = self.dataModul as! SalaryDetailTableDataModul
        
        let size = sizeWithText(modul.date, font: detailTitleFont, maxSize: CGSize(width: Width, height: 300))
        let size1 = sizeWithText("金额：", font: detailFont, maxSize: CGSize(width: Width, height: 300))
        let size2 = sizeWithText(modul.type, font: detailFont, maxSize: CGSize(width: Width, height: 300))
        let size3 = sizeWithText(modul.time, font: detailFont, maxSize: CGSize(width: Width, height: 300))
        let size4 = sizeWithText(modul.number, font: useNumberFont, maxSize: CGSize(width: Width, height: 300))
        
        self.dataLable!.frame = CGRect(x: (Width*2/3-size.width)/2, y: 0, width: size.width, height: salaryDetailCellHeight/3)
        
        self.dataNumber2!.frame = CGRect(x: Width-size4.width-10, y: self.dataLable!.frame.maxY-10, width: size4.width, height: self.dataLable!.frame.height)
        self.dataNumber2!.font = useNumberFont
        
        self.dataNumber11!.frame = CGRect(x: 20, y: self.dataLable!.frame.maxY, width: size1.width, height: self.dataLable!.frame.height)
        self.dataNumber22!.frame = CGRect(x: self.dataNumber11!.frame.maxX, y: self.dataNumber11!.frame.minY, width: size2.width, height: self.dataLable!.frame.height)
        
        self.dataNumber111!.frame = CGRect(x: 20, y: self.dataNumber11!.frame.maxY, width: size1.width, height: self.dataLable!.frame.height)
        self.dataNumber222!.frame = CGRect(x: self.dataNumber111!.frame.maxX, y: self.dataNumber111!.frame.minY, width: size3.width, height: self.dataNumber111!.frame.height)
        
        self.dataLable!.text = modul.date
        self.dataNumber2!.text = modul.number
        self.dataNumber111!.text = "时间："
        self.dataNumber222!.text = modul.time
        self.dataNumber11!.text = "来源："
        self.dataNumber22!.text = modul.type
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
