//
//  Expense+CoreDataClass.swift
//  TrackMyBudget
//
//  Created by Prabhav Chawla on 10/15/17.
//  Copyright © 2017 Prabhav Chawla. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Expense)
public class Expense: NSManagedObject {
    convenience init(amount: Double, date: NSDate, descirption: String? = nil, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Expense", in: context) {
            self.init(entity: ent, insertInto: context)
            
            self.amount = amount
            self.date = date
        } else {
            fatalError("Error")
        }
    }
}
