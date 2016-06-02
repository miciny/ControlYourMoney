//
//  InternetSetting+CoreDataProperties.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/6/2.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension InternetSetting {

    @NSManaged var ip: String?
    @NSManaged var port: String?
    @NSManaged var internet: NSNumber?

}
