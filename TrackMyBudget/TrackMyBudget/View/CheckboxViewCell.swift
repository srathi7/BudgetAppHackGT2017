//
//  CheckboxViewCell.swift
//  TrackMyBudget
//
//  Created by Prabhav Chawla on 10/14/17.
//  Copyright © 2017 Prabhav Chawla. All rights reserved.
//

import UIKit

class CheckboxViewCell: UITableViewCell {
    @IBOutlet weak var checkboxImage: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var isChecked: Bool!
    
    @objc func here() {
        isChecked = !isChecked
        BudgetInfoTableViewController.categoriesCheckedStatus[categoryLabel.text!] = isChecked
        UserDefaults.standard.set(BudgetInfoTableViewController.categoriesCheckedStatus, forKey: "categoriesCheckedStatus")
        
        if isChecked {
            checkboxImage.setImage(UIImage(named: "checked"), for: .normal)
        } else {
            checkboxImage.setImage(UIImage(named: "unchecked"), for: .normal)
        }
    }
}
