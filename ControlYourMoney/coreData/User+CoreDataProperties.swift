//
//  User+CoreDataProperties.swift
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

extension User {

    @NSManaged var account: String?
    @NSManaged var name: String?
    @NSManaged var nickname: String?
    @NSManaged var address: String?
    @NSManaged var location: String?
    @NSManaged var pw: String?
    @NSManaged var sex: String?
    @NSManaged var create_time: Date?
    @NSManaged var motto: String?
    @NSManaged var pic: Data?
    @NSManaged var http: String?
    @NSManaged var picPath: String?
    @NSManaged var changed: NSNumber? //0没改过 1改过

}
