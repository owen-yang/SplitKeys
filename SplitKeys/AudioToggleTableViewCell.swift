//
//  AudioToggleTableViewCell.swift
//  SplitKeys
//
//  Created by Owen Yang on 10/13/16.
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import UIKit

class AudioToggleTableViewCell: SwitchSettingTableViewCell {

    override init() {
        super.init()
        textLabel?.text = "Enable Audio"
    }
    
    override func initSwitchValue() {
        valueSwitch.isOn = Settings.isAudioEnabled
    }
    
    override func onToggle() {
        Settings.isAudioEnabled = valueSwitch.isOn
    }
}
