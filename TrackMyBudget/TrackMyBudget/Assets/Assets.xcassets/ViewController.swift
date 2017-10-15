//
//  ViewController.swift
//  TrackMyBudget
//
//  Created by pallavi chetia on 10/15/17.
//  Copyright © 2017 Prabhav Chawla. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var History: UITableView!
    let months = ["Month1", "Month2", "Month3" ]
    let data = ["$500", "$100", "$90"]

    override func viewDidLoad() {
        super.viewDidLoad()

        History.delegate = self
        History.dataSource = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return months.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = months[indexPath.row]
        cell.detailTextLabel?.text = data[indexPath.row]
        
        return cell
        
    }

    

}
