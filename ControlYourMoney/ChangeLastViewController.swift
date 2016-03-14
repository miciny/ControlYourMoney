//
//  ChangeTotalViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 15/12/22.
//  Copyright © 2015年 maocaiyuan. All rights reserved.
//

import UIKit

class ChangeLastViewController: UIViewController {
    
    var totalData = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改可用余额"
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        
        let total = UILabel(frame: CGRectMake(20, 140, self.view.frame.size.width / 5 + 20, 30))
        total.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        total.textAlignment = NSTextAlignment.Left
        total.backgroundColor = UIColor.clearColor()
        total.textColor = UIColor.blackColor()
        total.text = "可用总额："
        self.view.addSubview(total)
        
        totalData = UITextField(frame: CGRectMake(self.view.frame.size.width / 5 + 30, 140, self.view.frame.size.width * 2 / 3 - 20, 30))
        totalData.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        totalData.textAlignment = NSTextAlignment.Left
        totalData.borderStyle = UITextBorderStyle.RoundedRect
        totalData.clearButtonMode = UITextFieldViewMode.WhileEditing
        totalData.backgroundColor = UIColor.whiteColor()
        totalData.textColor = UIColor.blackColor()
        totalData.placeholder = "请输入金额..."
        self.view.addSubview(totalData)


        let save = UIButton(frame: CGRectMake(self.view.frame.size.width / 3 - 30, 200, self.view.frame.size.width / 3 + 60, 44))
        save.layer.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1).CGColor
        save.setTitle("保  存", forState: UIControlState.Normal)
        save.addTarget(self,action:Selector("saveLast:"),forControlEvents:.TouchUpInside)
        self.view.addSubview(save)

        // Do any additional setup after loading the view.
    }

    @IBAction func saveLast(sender : AnyObject){
        if(totalData.text == "" ){
            textView("请输入内容！")
        }else{
            if(stringIsFloat(totalData.text! as String)){
                InsertTotaleData(Float(totalData.text!)!, time: getTime())
                showToast().showToast("修改成功！")
                self.navigationController?.popToRootViewControllerAnimated(true)
            }else{
                textView("请输入正确金额！")
            }
        }
    }
    
    func textView(str :String) ->UIAlertView{
        let alert=UIAlertView()
        alert.message=str
        alert.addButtonWithTitle("Ok")
        alert.delegate=self
        alert.show()
        return alert
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
