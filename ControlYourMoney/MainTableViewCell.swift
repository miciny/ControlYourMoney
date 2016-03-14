//
//  AddedTableViewCell.swift
//  YaQiHahah
//
//  Created by maocaiyuan on 15/12/14.
//  Copyright © 2015年 maocaiyuan. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    var dataLable = UILabel()
    var dataLine = UIView()
    var dataNumber1 = UILabel()
    var dataNumber2 = UILabel()
    var dataNumber11 = UILabel()
    var dataNumber22 = UILabel()
    var dataNumber111 = UILabel()
    var dataNumber222 = UILabel()
    var dataNumber1111 = UILabel()
    var dataNumber2222 = UILabel()
    var dataNumber111111 = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLable()
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: -100)
        self.frame.size.height = rowHeight
    }
    
    func setLable(){
        dataLable = UILabel(frame: CGRectZero)
        dataLable.font = UIFont(name: "HelveticaNeue-Light", size: 20.0)
        dataLable.textAlignment = NSTextAlignment.Center
        dataLable.backgroundColor = UIColor.clearColor()
        dataLable.textColor = UIColor.blackColor()
        
        dataLine = UIView(frame: CGRectZero)
        dataLine.backgroundColor = UIColor.lightGrayColor()
        
        dataNumber1 = UILabel(frame: CGRectZero)
        dataNumber1.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        dataNumber1.textAlignment = NSTextAlignment.Left
        dataNumber1.backgroundColor = UIColor.clearColor()
        dataNumber1.textColor = UIColor.blackColor()
        
        dataNumber2 = UILabel(frame: CGRectZero)
        dataNumber2.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        dataNumber2.textAlignment = NSTextAlignment.Right
        dataNumber2.backgroundColor = UIColor.clearColor()
        dataNumber2.textColor = UIColor.redColor()
       
        dataNumber11 = UILabel(frame: CGRectZero)
        dataNumber11.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        dataNumber11.textAlignment = NSTextAlignment.Left
        dataNumber11.backgroundColor = UIColor.clearColor()
        dataNumber11.textColor = UIColor.blackColor()
        
        dataNumber22 = UILabel(frame: CGRectZero)
        dataNumber22.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        dataNumber22.textAlignment = NSTextAlignment.Right
        dataNumber22.backgroundColor = UIColor.clearColor()
        dataNumber22.textColor = UIColor.redColor()
        
        dataNumber111 = UILabel(frame: CGRectZero)
        dataNumber111.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        dataNumber111.textAlignment = NSTextAlignment.Left
        dataNumber111.backgroundColor = UIColor.clearColor()
        dataNumber111.textColor = UIColor.blackColor()
        
        dataNumber222 = UILabel(frame: CGRectZero)
        dataNumber222.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        dataNumber222.textAlignment = NSTextAlignment.Right
        dataNumber222.backgroundColor = UIColor.clearColor()
        dataNumber222.textColor = UIColor.redColor()
       
        dataNumber1111 = UILabel(frame: CGRectZero)
        dataNumber1111.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        dataNumber1111.textAlignment = NSTextAlignment.Left
        dataNumber1111.backgroundColor = UIColor.clearColor()
        dataNumber1111.textColor = UIColor.blackColor()
        
        
        dataNumber2222 = UILabel(frame: CGRectZero)
        dataNumber2222.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        dataNumber2222.textAlignment = NSTextAlignment.Right
        dataNumber2222.backgroundColor = UIColor.clearColor()
        dataNumber2222.textColor = UIColor.redColor()
   
    }
    
    override func layoutSubviews() {
        let screenWidth = UIScreen.mainScreen().bounds.width
        
        self.dataLable.frame = CGRectMake(0, 0, screenWidth, 30)
        self.dataLine.frame = CGRectMake(screenWidth*3/8, 32, screenWidth/4, 1)
        
        self.dataNumber1.frame = CGRectMake(20, 40, screenWidth / 3 + 10, 15)
        self.dataNumber2.frame = CGRectMake(screenWidth / 3 + 10, 40, screenWidth*2/3 - 20, 15)
        
        self.dataNumber11.frame = CGRectMake(20, 60, screenWidth / 3 + 10, 15)
        self.dataNumber22.frame = CGRectMake(self.contentView.frame.size.width / 3 + 10, 60, screenWidth*2/3 - 20, 15)
        
        self.dataNumber111.frame = CGRectMake(20, 80, screenWidth / 3 + 10, 15)
        self.dataNumber222.frame = CGRectMake(screenWidth / 3 + 10, 80, screenWidth*2/3 - 20, 15)
        
        self.dataNumber1111.frame = CGRectMake(20, 100, screenWidth / 3, 15)
        self.dataNumber2222.frame = CGRectMake(screenWidth / 3 + 10, 100, screenWidth*2/3 - 20, 15)
        
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
