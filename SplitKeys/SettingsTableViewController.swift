//
//  SettingsTableViewController.swift
//  SplitKeys
//
//  Created by Owen Yang on 10/13/16.
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    let sections = [
        (
            header: "AUDIO",
            cells: [AudioToggleTableViewCell(),
                    AudioVolumeTableViewCell(),
                    AudioSpeedTableViewCell()],
            footer: ""
        ),
        (
            header: "KEYBOARD",
            cells: [KeyboardHeightTableViewCell()],
            footer: "Percent of screen used for keyboard."
        ),
        (
            header: "",
            cells: [KeyboardHoldTimeTableViewCell()],
            footer: "Minimum hold time for tap-and-hold gestures to trigger."
        ),
        (
            header: "",
            cells: [KeyboardWaitTimeTableViewCell()],
            footer: "Minimum wait time before the numeral keyboard enters the selected numeral."
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "SplitKeys Settings"
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sections[indexPath.section].cells[indexPath.row]
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footer
    }
}
