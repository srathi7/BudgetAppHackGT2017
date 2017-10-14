//
//  BudgetInfoTableViewController.swift
//  TrackMyBudget
//
//  Created by Prabhav Chawla on 10/14/17.
//  Copyright © 2017 Prabhav Chawla. All rights reserved.
//

import UIKit

class BudgetInfoTableViewController: UITableViewController {
    
    let section = ["Monthly Budget", "Categories"]
    let categories = ["Transport", "Groceries", "Coffee", "Alcohol", "GoingOut", "PhoneBill", "Shopping", "Miscellaneous"]
    
    static var categoriesCheckedStatus = [String:Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let arr = UserDefaults.standard.value(forKey: "categoriesCheckedStatus") as? [String:Bool] {
            BudgetInfoTableViewController.categoriesCheckedStatus = arr
        } else {
            for category in categories {
                BudgetInfoTableViewController.categoriesCheckedStatus[category] = false
            }
        }
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.allowsSelection = false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AmountViewCell", for: indexPath) as! AmountViewCell
            cell.amountTextField.addTarget(self, action: #selector(self.myTextFieldDidChange), for: .editingChanged)
            cell.amountTextField.keyboardType = .numberPad
            
            if let budget = UserDefaults.standard.string(forKey: "budget") {
                cell.amountTextField.text = budget
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckboxViewCell", for: indexPath) as! CheckboxViewCell
        cell.categoryLabel.text = categories[indexPath.row]
        
        cell.isChecked = BudgetInfoTableViewController.categoriesCheckedStatus[categories[indexPath.row]]!
        if cell.isChecked {
            cell.checkboxImage.setImage(UIImage(named: "checked"), for: .normal)
        } else {
           cell.checkboxImage.setImage(UIImage(named: "unchecked"), for: .normal)
        }
        cell.checkboxImage.addTarget(cell, action: #selector(cell.here), for: .touchUpInside)
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section[section]
    }
    
    @objc private func myTextFieldDidChange(_ textField: UITextField) {
        
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
            UserDefaults.standard.set(amountString, forKey: "budget")
        }
    }
}

extension String {
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
}
