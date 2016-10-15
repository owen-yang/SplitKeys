//
//  SettingsTableViewController.swift
//  SplitKeys
//
//  Created by Owen Yang on 10/13/16.
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    let cells = [
        [
            AudioToggleTableViewCell()
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "SplitKeys Settings"
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.section][indexPath.row]
    }
}
