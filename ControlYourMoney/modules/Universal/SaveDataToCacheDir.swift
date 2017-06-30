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
        
        let cachePaths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let cachePath = cachePaths[0]
        return cachePath as AnyObject
    }
    
    //创建一个文件夹
    class func getDirInCache(_ dirName: String) -> AnyObject{
        
        let cacheDir = getCacheDirectory()
        let findPetsDir = cacheDir.appendingPathComponent(dirName)
        let manager = FileManager.default
        if !manager.fileExists(atPath: findPetsDir) {
            do{
                try
                    manager.createDirectory(atPath: findPetsDir, withIntermediateDirectories: true, attributes: nil)
            }catch let error as NSError{
                print("创建失败！")
                print(error)
            }
        }
        return findPetsDir
    }
    
    //保存图片到TempUserIcon目录
    class func savaUserIconToCacheDir(_ imageData: Data, imageName: String) -> Bool {
        
        let chatDirPath = getDirInCache(tempPicDir)
        let imageName = imageName
        var isSaved = Bool()
        
        do{
            try
                imageData.write(to: URL(fileURLWithPath: chatDirPath.appendingPathComponent(imageName+".png")), options: .atomicWrite)
            isSaved = true
        }catch let error as NSError{
            print(error)
            isSaved = false
        }
        
        return isSaved
    }
    
    //获取图片路径
    class func getUserIconPath(_ imageName: String) -> String?{
        let manager = FileManager.default
        let imagePath = getDirInCache(tempPicDir).appendingPathComponent(imageName+".png")
        
        if !manager.fileExists(atPath: imagePath) {
           return nil
        }
        return imagePath
    }
    
    // 从cache读取image
    class func loadIconFromCacheDir(_ imageName: String) -> Data?{
        let imagePath = getDirInCache(tempPicDir).appendingPathComponent(imageName+".png")
        var imageData: Data?
        if FileManager.default.fileExists(atPath: imagePath) {
            imageData = try! Data(contentsOf: URL(fileURLWithPath: imagePath))
        }
        return imageData
    }
}
