//
//  DetailTableViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 15/12/24.
//  Copyright © 2015年 maocaiyuan. All rights reserved.
//

import UIKit
import CoreData

class SalaryDetailTableViewController: UITableViewController {
    
    var AllData = [SalaryDetailTableDataModul]() //需要现实的数据

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitle()
        setupData()
    }

    //设置title等
    func setUpTitle(){
        self.title = "收入列表"
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
        
    }
    
    //获得数据
    func setupData(){
        
        let aa = GetDataArray.getSalaryDetailShowArray()
        if aa != nil {
            AllData = aa!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.AllData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.AllData[indexPath.row]
        let cell = MainTableViewCell(data: data, dataType: dataTpye.salaryDetail, reuseIdentifier: "cell")
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView!.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
}
