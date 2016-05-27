//
//  SettingViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/26.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    private var mainTabelView: UITableView? //整个table
    private var settingData : NSMutableArray? //数据

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitle()
        setData()
        setUpTable()
    }
    
    func setUpTitle(){
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
        self.title = "设置"
        
    }
    
    func setData(){
        settingData = NSMutableArray()
        
        let settingOne = SettingDataModul(icon: "DefaultIcon", name: "毛彩元", nickname: "miciny", pic: "TDIcon")
        let settingTwo1 = SettingDataModul(icon: nil, name: "修改密码", lable: nil, pic: nil)
        let settingTwo2 = SettingDataModul(icon: nil, name: "同步数据", lable: nil, pic: nil)
        let settingThree = SettingDataModul(icon: nil, name: "数据说明", lable: nil, pic: nil)
        
        settingData?.addObject([settingOne])
        settingData?.addObject([settingTwo1, settingTwo2])
        settingData?.addObject([settingThree])
    }
    
    //设置tableView
    func setUpTable(){
        mainTabelView = UITableView(frame: self.view.frame, style: .Grouped)  //为group模式
        mainTabelView?.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        
        mainTabelView?.showsVerticalScrollIndicator = false
        mainTabelView?.showsHorizontalScrollIndicator = false
        mainTabelView?.separatorStyle = UITableViewCellSeparatorStyle.SingleLine //是否显示线条
        mainTabelView?.sectionFooterHeight = 5  //每个section的间距
        
        mainTabelView?.delegate = self
        mainTabelView?.dataSource = self
        
        self.view.addSubview(mainTabelView!)
    }
    
    //section个数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return settingData!.count
    }
    
    //每个section的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingData![section].count
    }
    
    //计算每个cell高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section: [AnyObject]  =  self.settingData![indexPath.section] as! [AnyObject] //获取section里的对象
        let data = section[indexPath.row]
        let item =  data as! SettingDataModul
        let height  = item.cellHeigth
        
        return height
    }
    
    //每个cell内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "SettingCell"
        let section : NSArray =  self.settingData![indexPath.section] as! NSArray
        let data = section[indexPath.row]
        let cell =  SettingTableViewCell(data:data as! SettingDataModul, reuseIdentifier:cellId)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator  //显示后面的小箭头
        
        return cell
    }
    
    //选择了row
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        mainTabelView!.deselectRowAtIndexPath(indexPath, animated: true)  //被选择后，会变灰，这么做还原
        
        switch indexPath.section{
        //进入个人信息页
        case 0:
            switch indexPath.row {
            //个人信息页
            case 0:
                break
            default:
                break
            }
            
        //第二个设置栏
        case 1:
            switch indexPath.row {
            case 0: //设置密码
                break
                
            default:
                break
            }
            
        //设置
        case 2:
            switch indexPath.row {
            case 0: //说明
                let vc = ExplainViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        default:
            break
        }
    }

    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
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
