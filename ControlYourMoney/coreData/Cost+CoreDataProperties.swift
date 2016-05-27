//
//  Cost+CoreDataProperties.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/5/27.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Cost {

    @NSManaged var name: String?
    @NSManaged var number: NSNumber?
    @NSManaged var period: NSNumber?
    @NSManaged var time: NSDate?
    @NSManaged var type: String?

}
