//
//  AutocorrectAudioToggleTableViewCell.swift
//  SplitKeys
//
//  Created by Owen Yang on 11/6/16.
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import UIKit

class AutocorrectAudioToggleTableViewCell: SwitchSettingTableViewCell {
    
    override init() {
        super.init()
        textLabel?.text = "Enable Autocorrect Audio"
    }
    
    override func initSwitchValue() {
        valueSwitch.isOn = Settings.isAutocorrectAudioEnabled
    }
    
    override func onToggle() {
        Settings.isAutocorrectAudioEnabled = valueSwitch.isOn
    }
}
