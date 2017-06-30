//
//  Credit+CoreDataProperties.swift
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

extension Credit {

    @NSManaged var account: String?
    @NSManaged var date: NSNumber?
    @NSManaged var leftPeriods: NSNumber?
    @NSManaged var nextPayDay: Date?
    @NSManaged var number: NSNumber?
    @NSManaged var periods: NSNumber?
    @NSManaged var time: Date?
    @NSManaged var type: String?

}
