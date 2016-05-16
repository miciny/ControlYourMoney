//
//  AnalyseMainViewCollectionViewCell.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/13.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class AnalyseMainViewCollectionViewCell: UICollectionViewCell {
    
    var dataLable: UILabel! //cell上title
    var dataPic: UIImageView? //cell上的图片
    var data: UILabel!
    private let picHeight = CGFloat(20)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        rebuildCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rebuildCell(){
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.backgroundColor = UIColor.whiteColor()
        
        
        self.dataPic = UIImageView()
        self.dataPic?.frame = CGRectMake(10, (self.frame.height-picHeight)/2, 20, 20)
        
        self.dataLable = UILabel()
        self.dataLable.frame = CGRectMake(self.dataPic!.frame.maxX+10, 0, self.frame.width-40, self.frame.height/2)
        self.dataLable!.font = analyseTitleFont
        self.dataLable!.textAlignment = NSTextAlignment.Left
        self.dataLable!.backgroundColor = UIColor.clearColor()
        self.dataLable!.textColor = UIColor.blackColor()
        self.dataLable!.numberOfLines = 0
        self.addSubview(self.dataLable)
        
        self.data = UILabel()
        self.data.font = analyseDataFont
        self.data.frame = CGRectMake(self.dataLable.frame.minX, self.frame.height/2, self.frame.width-40, self.frame.height/2)
        self.data.textAlignment = NSTextAlignment.Left
        self.data.backgroundColor = UIColor.clearColor()
        self.data.textColor = UIColor.grayColor()
        self.data.numberOfLines = 0
        self.addSubview(data)
    }
}
