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
    var data: UILabel!  //cell上的数据
    fileprivate let picHeight = CGFloat(20)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        rebuildCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rebuildCell(){
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.backgroundColor = UIColor.white
        
        self.dataPic = UIImageView()
        self.dataPic?.frame = CGRect(x: 10, y: (self.frame.height-picHeight)/2, width: 20, height: 20)
        
        self.dataLable = UILabel()
        self.dataLable.frame = CGRect(x: self.dataPic!.frame.maxX+10, y: 0, width: self.frame.width-40, height: self.frame.height/2)
        self.dataLable!.font = analyseTitleFont
        self.dataLable!.textAlignment = NSTextAlignment.left
        self.dataLable!.backgroundColor = UIColor.clear
        self.dataLable!.textColor = UIColor.black
        self.dataLable!.numberOfLines = 0
        self.addSubview(self.dataLable)
        
        self.data = UILabel()
        self.data.font = analyseDataFont
        self.data.frame = CGRect(x: self.dataLable.frame.minX, y: self.frame.height/2, width: self.frame.width-40, height: self.frame.height/2)
        self.data.textAlignment = NSTextAlignment.left
        self.data.backgroundColor = UIColor.clear
        self.data.textColor = UIColor.gray
        self.data.numberOfLines = 0
        self.addSubview(data)
    }
}
