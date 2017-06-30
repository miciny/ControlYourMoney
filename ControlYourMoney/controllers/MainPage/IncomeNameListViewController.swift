//
//  IncomeNameListViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/18.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class IncomeNameListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var searchTable = UITableView()
    var dataAll: NSMutableArray!
    var dataShow: [AccountListModul]!
    var delegate: accountListViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "选择收入类型"
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        
        //取消按钮
        let leftBarBtn = UIBarButtonItem(title: "取消", style: .plain, target: self,
                                         action: #selector(AccountListViewController.backToPrevious))
        self.navigationItem.leftBarButtonItem = leftBarBtn
        
        //+按钮
        let addItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(goAddIncomeName))
        self.navigationItem.rightBarButtonItem = addItem
        
        setUpTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpData()
        self.searchTable.reloadData()
    }
    
    // 退出页面
    func backToPrevious(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //进入添加页面
    func goAddIncomeName(){
        let vc = AddIncomeAccountViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //哦配置tabel
    func setUpTable(){
        searchTable.frame = CGRect(x: 0, y: 0, width: Width, height: Height)  //为普通模式
        searchTable.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        
        searchTable.showsHorizontalScrollIndicator = false
        searchTable.tableFooterView = UIView(frame: CGRect.zero)
        
        searchTable.delegate = self
        searchTable.dataSource = self
        
        self.view.addSubview(searchTable)
    }
    
    //获取数据
    func setUpData(){
        
        dataAll = NSMutableArray()
        let accountTempArray = IncomeName.selectAllData()
        for i in 0 ..< accountTempArray.count {
            let name = (accountTempArray[i] as AnyObject).value(forKey: incomeNameOfName) as! String
            dataAll.add(name)
        }
        
        self.dataShow = [AccountListModul]()
        let titleModul = AccountListModul(name: "收入类型", type: 0)
        dataShow.append(titleModul)
        for i in 0 ..< dataAll.count {
            let str = (dataAll[i] as! String)
            let tempModul = AccountListModul(name: str, type: 1)
            dataShow.append(tempModul)
        }
    }
    
    /*
     // MARK: - tabel view delegate
     */
    
    //section个数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    //每个section的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        count = dataShow.count
        return count
        
    }
    
    //计算每个cell高度,固定44
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height  = CGFloat(44)
        return height
    }
    
    
    //每个cell内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = "Cell"
        let data = dataShow[indexPath.row]
        let cell =  AccountListTableViewCell(data: data , reuseIdentifier:cellId)
        
        if indexPath.row == 0 {
            cell.selectionStyle = .none
        }
        return cell
    }
    
    //点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            return
        }
        
        let data = dataShow[indexPath.row]
        let labelText = data.name
        self.delegate?.buttonClicked(labelText)
        self.backToPrevious()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
