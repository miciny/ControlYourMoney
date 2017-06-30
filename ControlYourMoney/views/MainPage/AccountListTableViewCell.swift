//
//  AccountListTableViewCell.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/12.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class AccountListTableViewCell: UITableViewCell {
    
    var accountList: AccountListModul! //数据模型 0代表title 1 代表数据 2代表底部删除按钮
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(data: AccountListModul, reuseIdentifier cellId:String){
        self.accountList = data
        super.init(style: UITableViewCellStyle.default, reuseIdentifier:cellId)
        rebuildCell()
    }
    
    func rebuildCell(){
        if(accountList.type == 0){
            //
            let searchRecodeSize = sizeWithText(accountList.name, font: accountListTitleFont, maxSize: CGSize(width: Width/2, height: 1000))
            let searchRecodeLabel = UILabel(frame: CGRect(x: 10, y: self.frame.origin.y,
                width: searchRecodeSize.width, height: self.frame.height))
            searchRecodeLabel.backgroundColor = UIColor.clear
            searchRecodeLabel.textColor = UIColor.lightGray
            searchRecodeLabel.font = accountListTitleFont
            searchRecodeLabel.textAlignment = .left
            searchRecodeLabel.text = accountList.name
            self.addSubview(searchRecodeLabel)
        }else if(accountList.type == 1){
            //
            let searchRecodeSize = sizeWithText(accountList.name, font: standardFont, maxSize: CGSize(width: Width/2, height: 1000))
            let searchRecodeLabel = UILabel(frame: CGRect(x: 20, y: self.frame.origin.y,
                width: searchRecodeSize.width, height: self.frame.height))
            searchRecodeLabel.backgroundColor = UIColor.clear
            searchRecodeLabel.font = standardFont
            searchRecodeLabel.textAlignment = .left
            searchRecodeLabel.text = accountList.name
            self.addSubview(searchRecodeLabel)
        }else if(accountList.type == 2){
            //
            let searchRecodeSize = sizeWithText(accountList.name, font: standardFont, maxSize: CGSize(width: Width/2, height: 1000))
            let searchRecodeLabel = UILabel(frame: CGRect(x: Width/2-searchRecodeSize.width/2, y: self.frame.origin.y,
                width: searchRecodeSize.width, height: self.frame.height))
            searchRecodeLabel.backgroundColor = UIColor.clear
            searchRecodeLabel.font = standardFont
            searchRecodeLabel.textAlignment = .center
            searchRecodeLabel.text = accountList.name
            self.addSubview(searchRecodeLabel)
        }
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
