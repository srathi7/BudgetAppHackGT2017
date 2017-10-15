//
//  CustomNavVC.swift
//  TrackMyBudget
//
//  Created by Prabhav Chawla on 10/14/17.
//  Copyright © 2017 Prabhav Chawla. All rights reserved.
//

import UIKit

class CustomNavVC: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(CustomNavVC.manualAdd))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(CustomNavVC.cameraAdd))
        
        self.navigationItem.leftBarButtonItem?.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    @objc func manualAdd() {
        // TO DO
    }
    
    @objc func cameraAdd() {
        // TO DO
    }
}

