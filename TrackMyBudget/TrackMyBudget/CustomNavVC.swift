//
//  ViewController.swift
//  TrackMyBudget
//
//  Created by Prabhav Chawla on 10/14/17.
//  Copyright © 2017 Prabhav Chawla. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ViewController.add))
    }
    
    @objc func startOver() {
        // NavigationController provides reference to the NavigationController
        self.navigationController?.popToRootViewController(animated: true) // go back to root
    }
}

