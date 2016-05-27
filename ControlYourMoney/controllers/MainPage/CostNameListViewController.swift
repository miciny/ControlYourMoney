//
//  CostNameListViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/18.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class CostNameListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var searchTable = UITableView()
    var dataAll: NSMutableArray!
    var dataShow: [AccountListModul]!
    var delegate: costNameListViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择支出类型"
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        
        //取消按钮
        let leftBarBtn = UIBarButtonItem(title: "取消", style: .Plain, target: self,
                                         action: #selector(backToPrevious))
        self.navigationItem.leftBarButtonItem = leftBarBtn
        
        //+按钮
        let addItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(goAddPayName))
        self.navigationItem.rightBarButtonItem = addItem
        
        setUpTable()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        setUpData()
        self.searchTable.reloadData()
    }
    
    func setUpTable(){
        searchTable.frame = CGRect(x: 0, y: 0, width: Width, height: Height)  //为普通模式
        searchTable.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        
        searchTable.showsHorizontalScrollIndicator = false
        searchTable.tableFooterView = UIView(frame: CGRectZero)
        
        searchTable.delegate = self
        searchTable.dataSource = self
        
        self.view.addSubview(searchTable)
    }
    
    func setUpData(){
        
        dataAll = NSMutableArray()
        let accountTempArray = PayName.selectAllData()
        for i in 0 ..< accountTempArray.count {
            let name = accountTempArray[i].valueForKey(payNameNameOfName) as! String
            dataAll.addObject(name)
        }
        
        self.dataShow = [AccountListModul]()
        let titleModul = AccountListModul(name: "支出类型", type: 0)
        dataShow.append(titleModul)
        for i in 0 ..< dataAll.count {
            let str = (dataAll[i] as! String)
            let tempModul = AccountListModul(name: str, type: 1)
            dataShow.append(tempModul)
        }
    }
    
    /*
     // MARK: - uitabelview
     */
    //section个数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    //每个section的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        count = dataShow.count
        return count
        
    }
    
    //计算每个cell高度,固定44
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let height  = CGFloat(44)
        return height
    }
    
    
    //每个cell内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellId = "Cell"
        let data = dataShow[indexPath.row]
        let cell =  AccountListTableViewCell(data: data , reuseIdentifier:cellId)
        
        if indexPath.row == 0 {
            cell.selectionStyle = .None
        }
        return cell
    }
    
    //点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 {
            return
        }
        
        let data = dataShow[indexPath.row]
        let labelText = data.name
        self.delegate?.costNameClicked(labelText)
        self.backToPrevious()
    }

    func backToPrevious(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func goAddPayName(){
        let vc = AddCostNameViewController()
        self.navigationController?.pushViewController(vc, animated: true)
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
