//
//  Expense+CoreDataClass.swift
//  TrackMyBudget
//
//  Created by Prabhav Chawla on 10/14/17.
//  Copyright © 2017 Prabhav Chawla. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Expense)
public class Expense: NSManagedObject {
    
    convenience init(amount: Double, date: String, descirption: String? = nil, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Expense", in: context) {
            self.init(entity: ent, insertInto: context)
            
            self.amount = amount
            self.descript = description
           // self.date = TO DO
        } else {
            fatalError("Error")
        }
    }
}
