//
//  Cache.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/6/7.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class Cache: NSObject {

    static var cacheSize: String{
        get{
            let basePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
            let fileManager = FileManager.default
            
            func caculateCache() -> Float{
                var total: Float = 0
                if fileManager.fileExists(atPath: basePath!){
                    let childrenPath = fileManager.subpaths(atPath: basePath!)
                    if childrenPath != nil{
                        for path in childrenPath!{
                            let childPath = (basePath! + "/") + path
                            do{
                                let attr = try fileManager.attributesOfItem(atPath: childPath)
                                let fileSize = attr["NSFileSize"] as! Float
                                total += fileSize
                                
                            }catch _{
                                
                            }
                        }
                    }
                }
                return total
            }
            let totalCache = caculateCache()
            return NSString(format: "%.2fMB", totalCache / 1024.0 / 1024.0 ) as String
        }
    }
    
    // 清除缓存
    class func clearCache() -> Bool{
        var result = true
        let basePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: basePath!){
            let childrenPath = fileManager.subpaths(atPath: basePath!)
            for childPath in childrenPath!{
                let cachePath = ((basePath)! + "/") + childPath
                do{
                    try fileManager.removeItem(atPath: cachePath)
                }catch _{
                    result = false
                }
            }
        }
        
        return result
    }

}
