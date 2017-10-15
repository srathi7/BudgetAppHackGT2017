//
//  ManualEntryVC.swift
//  TrackMyBudget
//
//  Created by Prabhav Chawla on 10/14/17.
//  Copyright © 2017 Prabhav Chawla. All rights reserved.
//

import UIKit
import CoreData

class ManualEntryVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationBarDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var datePickerView: UIPickerView!
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var categoryText: UITextField!
    @IBOutlet weak var navBar: UINavigationBar!
    
    let datesArr: [Int] = Array(1...31)
    var categoryArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navBar.delegate = self
    
        amountTextField.addTarget(self, action: #selector(self.myTextFieldDidChange), for: .editingChanged)
        amountTextField.addTarget(self, action: #selector(self.hideAllPickers), for: .editingDidBegin)
        amountTextField.keyboardType = .numberPad
        
        self.setUpDelegatesAndInitialUI(picker: datePickerView, text: dateText)
        self.setUpDelegatesAndInitialUI(picker: categoryPicker, text: categoryText)
        
        if let dict = UserDefaults.standard.value(forKey: "categoriesCheckedStatus") as? [String:Bool] {
            for (key, value) in dict {
                if value {
                    categoryArr.append(key)
                }
            }
        } else {
            categoryArr.append("No Possible Value")
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
        tapRecognizer.delegate = self
        view.addGestureRecognizer(tapRecognizer)
    }
    
    
    @objc func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        self.hideAllPickers()
        if self.amountTextField.isFirstResponder {
            self.amountTextField.resignFirstResponder()
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if String(describing: type(of: touch.view!)) == "_UIButtonBarButton" {
            return false
        }
        return true
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    private func setUpDelegatesAndInitialUI(picker: UIPickerView, text: UITextField) {
        picker.delegate = self
        picker.dataSource = self
        self.view.sendSubview(toBack: picker) // Ensures that the `picker` does not overlap on top of the `text`.
        
        text.delegate = self
        
        self.updateUI(picker: picker, text: text, bool: true)
    }
    
    private func updateUI(picker: UIPickerView, text: UITextField, bool: Bool) {
        picker.isHidden = bool
        text.isHidden = !bool
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
            
        case 0:
            return datesArr.count
            
        case 1:
            return categoryArr.count
            
        default:
            return 0
        }
    }
    
     func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            dateText.text = String(self.datesArr[row])
            
        case 1:
            categoryText.text = self.categoryArr[row]
            
        default:
            break
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label = view as? UILabel
        if label == nil {
            label = UILabel()
        }
        
        switch pickerView.tag {
            
        case 0:
            label?.text = String(self.datesArr[row])
            
        case 1:
            label?.text = self.categoryArr[row]
            
        default:
            label?.text = ""
        }
        
        label?.textAlignment = .center
        label?.font = UIFont.preferredFont(forTextStyle: .body)
        return label!
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if self.amountTextField.isFirstResponder {
            self.amountTextField.resignFirstResponder()
        }
        
        self.hideAllPickers()
        switch textField.tag {
        case 0:
            self.updateUI(picker: datePickerView, text: dateText, bool: false)
            
        case 1:
            self.updateUI(picker: categoryPicker, text: categoryText, bool: false)
            
        default:
            break
            
        }
        return false
    }
    
    @objc private func hideAllPickers() {
        self.updateUI(picker: datePickerView, text: dateText, bool: true)
        self.updateUI(picker: categoryPicker, text: categoryText, bool: true)
    }
    
    @IBAction func save() {
        let alert = UIAlertController()
        
        if amountTextField.text == "" || dateText.text == "" || categoryText.text == "" {
            alert.title = "Details Missing"
            alert.message = "Please enter all the details!"
            let okAction = UIAlertAction(title: "OK", style: .destructive)
            alert.addAction(okAction)
        } else {
            var dollarString = amountTextField.text!
            dollarString.remove(at: dollarString.startIndex)
            var dollar = Double(dollarString)!
            dollar = (dollar * 100).rounded() / 100
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd"
            
            let date = dateFormatter.date(from: "\(Calendar.current.component(.month, from: Date()))/\(dateText.text!)")!
            
            alert.title = "Success!"
            alert.message = "Data added."
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true)
            }
            alert.addAction(okAction)
            
            CoreDataSingleton.shared.backgroundContext.perform {
                let _ = Expense(amount: dollar, date: date as NSDate, context: CoreDataSingleton.shared.backgroundContext)
                do {
                    try CoreDataSingleton.shared.backgroundContext.save()
                } catch {
                    fatalError("Error while saving backgroundContext: \(error)")
                }
            }
            CoreDataSingleton.shared.saveContext()
        }
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancel() {
        self.dismiss(animated: true)
    }
    
    @objc private func myTextFieldDidChange(_ textField: UITextField) {
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
            UserDefaults.standard.set(amountString, forKey: "budget")
        }
    }
}
