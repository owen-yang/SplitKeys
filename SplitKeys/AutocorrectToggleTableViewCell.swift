//
//  AutocorrectToggleTableViewCell.swift
//  SplitKeys
//
//  Created by Owen Yang on 11/6/16.
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import UIKit

class AutocorrectToggleTableViewCell: SwitchSettingTableViewCell {
    
    override init() {
        super.init()
        textLabel?.text = "Enable Autocorrect"
    }
    
    override func initSwitchValue() {
        valueSwitch.isOn = Settings.isAutocorrectEnabled
    }
    
    override func onToggle() {
        Settings.isAutocorrectEnabled = valueSwitch.isOn
    }
}
