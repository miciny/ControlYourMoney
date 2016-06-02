//
//  SyncDataExplainViewController.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/6/2.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class SyncDataExplainViewController: UIViewController {

    var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitle()
        setScroll()
        setUpLabel()
        // Do any additional setup after loading the view.
    }
    
    func setUpTitle(){
        self.title = "说明"
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
    }
    
    // 设置scroll
    func setScroll(){
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: Width, height: Height))
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
    }
    
    // 设置label，用于显示文字
    func setUpLabel(){
        let str = getStr()
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: Width-20, height: 44))
        label.attributedText = str
        label.font = explainFont
        label.backgroundColor = UIColor.clearColor()
        label.numberOfLines = 0
        label.sizeToFit()
        
        scrollView.addSubview(label)
        scrollView.contentSize = CGSize(width: Width, height: label.frame.maxY+20)
    }
    
    //获取富文本
    func getStr() -> NSMutableAttributedString{
        let allStr = NSMutableAttributedString()
        let single = NSMutableArray()
        
        single.addObject(getArrtibuteStr("上传数据：本地导出时，数据会显示在本页，复制之后可以手动添加到json文件里，进行本地导入数据\n                网络上传数据，配置好地址和端口号后，连接服务器上传数据，上传失败或者成功都会提示！上传时，会将服务器里的数据全部清空，然后写入本地数据！！！\n\n", rang: NSMakeRange(0, 5)))
        single.addObject(getArrtibuteStr("下载数据：本地导入时，是从本地的json文件里导入\n                网络导入数据，配置好地址和端口号后，从服务器下载数据，失败成功都会提示！！！\n\n", rang: NSMakeRange(0, 5)))
        single.addObject(getArrtibuteStr("注意：导入数据只能导入一次，如果本地有数据了，就无法导入，只能删除客户端之后再次导入！！！", rang: NSMakeRange(0, 3)))
        
        for i in 0 ..< single.count {
            allStr.appendAttributedString(single[i] as! NSMutableAttributedString)
        }
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        paragraphStyle.alignment = .Left  //靠左
        paragraphStyle.lineSpacing = 5 //行间距
        
        allStr.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, allStr.length))
        
        return allStr
    }
    
    // 设置富文本，前5个字是蓝色的
    func getArrtibuteStr(str: String, rang: NSRange) -> NSMutableAttributedString{
        let strB = NSMutableAttributedString(string: str)
        strB.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: rang)
        return strB
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
