//
//  UserInfoViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/6/3.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    private var mainTabelView: UITableView? //整个table
    private var infoData : NSMutableArray? //数据

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEles()
        setData()
        setUpTable()

        // Do any additional setup after loading the view.
    }
    
    func setUpEles(){
        self.title = "个人信息"                        //页面title和底部title
        self.view.backgroundColor = UIColor.whiteColor() //背景色
    }
    
    func setData(){
        infoData = NSMutableArray()
        
        //从CoreData里读取数据
        let userData = InitData.getUserDataToModel()
        
        let infoOne1 = SettingDataModul(name: "头像", pic: "DefaultIcon")
        let infoOne2 = SettingDataModul(icon: nil, name: "名字", lable: userData.name, pic: nil)
        let infoOne3 = SettingDataModul(icon: nil, name: "昵称", lable: userData.nickname, pic: nil)
        let infoOne4 = SettingDataModul(icon: nil, name: "我的二维码", lable: nil, pic: "TDIcon")
        let infoOne5 = SettingDataModul(icon: nil, name: "我的地址", lable: userData.address, pic: nil)
        
        let infoTwo1 = SettingDataModul(icon: nil, name: "性别", lable: userData.sex, pic: nil)
        let infoTwo2 = SettingDataModul(icon: nil, name: "地区", lable: userData.location, pic: nil)
        let infoTwo3 = SettingDataModul(icon: nil, name: "个性签名", lable: userData.motto, pic: nil)
        
        infoData?.addObject([infoOne1, infoOne2, infoOne3, infoOne4, infoOne5])
        infoData?.addObject([infoTwo1, infoTwo2, infoTwo3])
    }

    
    //设置tableView
    func setUpTable(){
        mainTabelView = UITableView(frame: self.view.frame, style: .Grouped)  //为group模式
        mainTabelView?.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        
        mainTabelView?.showsVerticalScrollIndicator = false
        mainTabelView?.showsHorizontalScrollIndicator = false
        mainTabelView?.sectionFooterHeight = 5
        mainTabelView?.separatorStyle = UITableViewCellSeparatorStyle.SingleLine //是否显示线条
        
        mainTabelView?.delegate = self
        mainTabelView?.dataSource = self
        
        self.view.addSubview(mainTabelView!)
    }
    
    //section个数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return infoData!.count
    }
    
    //每个section的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoData![section].count
    }
    
    //计算每个cell高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section: [AnyObject]  =  self.infoData![indexPath.section] as! [AnyObject] //获取section里的对象
        let data = section[indexPath.row]
        let item =  data as! SettingDataModul
        let height  = item.cellHeigth
        
        return height
    }
    
    //每个cell内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "InfoCell"
        let section : NSArray =  self.infoData![indexPath.section] as! NSArray
        let data = section[indexPath.row]
        let cell =  SettingTableViewCell(data: data as! SettingDataModul, reuseIdentifier: cellId)
        //寻宠好不能变
        if indexPath.section != 0 || indexPath.row != 2 {
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        
        return cell
    }
    
    //选择了row
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        mainTabelView!.deselectRowAtIndexPath(indexPath, animated: true)  //被选择后，会变灰，这么做还原
        
        //提取cell的数据
        let section : NSArray =  self.infoData![indexPath.section] as! NSArray
        let data = section[indexPath.row]
        let item = data as! SettingDataModul
        
        switch indexPath.section{
        case 0:
            switch indexPath.row {
                
            //头像页
            case 0:
//                let myIconVc = MyIconViewController()
//                myIconVc.image = item.pic
//                self.navigationController?.pushViewController(myIconVc, animated: true)
                break
            //名字页
            case 1:
//                let myNameVc = PersonInfoChangeNameViewController()
//                myNameVc.name = item.lable
//                self.navigationController?.pushViewController(myNameVc, animated: true)
                break
            //二维码页
            case 3:
//                let myTDIcon = MyTDCodeImageViewController()
//                self.navigationController?.pushViewController(myTDIcon, animated: true)
                break
            default:
                break
            }
        default:
            break
        }
    }
    
    //第一个section距离navigationbar的距离,第一个和第二个的间距设置，用mainTabelView?.sectionFooterHeight = 10，这个距离的计算是header的高度加上footer的高度
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
