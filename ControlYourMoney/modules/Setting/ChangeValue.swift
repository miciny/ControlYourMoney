//
//  ChangeValue.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/6/3.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class ChangeValue: NSObject {
    //nsdata转为image
    class func dataToImage(data: NSData?) -> UIImage {
        var image = UIImage()
        if let localData = data {
            image = UIImage(data: localData)!
        }else{
            image = UIImage(named: "DefaultIcon")!
        }
        return image
    }
    
    //image转为nsdata
    class func imageToData(image: UIImage) -> NSData {
        let imageData = UIImagePNGRepresentation(image)
        return imageData!
    }
}
