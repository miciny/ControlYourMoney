//
//  SaveDataToCacheDir.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/6/7.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

public let tempPicDir = "TempUserIcon"

class SaveDataToCacheDir: NSObject {
    // 获取沙盒缓存文件夹路径
    class func getCacheDirectory() -> AnyObject{
        
        let cachePaths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
        let cachePath = cachePaths[0]
        return cachePath
    }
    
    //创建一个文件夹
    class func getDirInCache(dirName: String) -> AnyObject{
        
        let cacheDir = getCacheDirectory()
        let findPetsDir = cacheDir.stringByAppendingPathComponent(dirName)
        let manager = NSFileManager.defaultManager()
        if !manager.fileExistsAtPath(findPetsDir) {
            do{
                try
                    manager.createDirectoryAtPath(findPetsDir, withIntermediateDirectories: true, attributes: nil)
            }catch let error as NSError{
                print("创建失败！")
                print(error)
            }
        }
        return findPetsDir
    }
    
    //保存图片到TempUserIcon目录
    class func savaUserIconToCacheDir(imageData: NSData, imageName: String) -> Bool {
        
        let chatDirPath = getDirInCache(tempPicDir)
        let imageName = imageName
        var isSaved = Bool()
        
        do{
            try
                imageData.writeToFile(chatDirPath.stringByAppendingPathComponent(imageName+".png"), options: .AtomicWrite)
            isSaved = true
        }catch let error as NSError{
            print(error)
            isSaved = false
        }
        
        return isSaved
    }
    
    //获取图片路径
    class func getUserIconPath(imageName: String) -> String?{
        let manager = NSFileManager.defaultManager()
        let imagePath = getDirInCache(tempPicDir).stringByAppendingPathComponent(imageName+".png")
        
        if !manager.fileExistsAtPath(imagePath) {
           return nil
        }
        return imagePath
    }
    
    // 从cache读取image
    class func loadIconFromCacheDir(imageName: String) -> NSData?{
        let imagePath = getDirInCache(tempPicDir).stringByAppendingPathComponent(imageName+".png")
        var imageData: NSData?
        if NSFileManager.defaultManager().fileExistsAtPath(imagePath) {
            imageData = NSData(contentsOfFile: imagePath)!
        }
        return imageData
    }
}
