//
//  AudioToggleTableViewCell.swift
//  SplitKeys
//
//  Created by Owen Yang on 10/13/16.
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import UIKit

class AudioToggleTableViewCell: SettingTableViewCell {
    
    let audioSwitch = UISwitch()
    
    override init() {
        super.init()
        
        textLabel?.text = "Enable Audio"
        audioSwitch.isOn = Settings.isAudioEnabled
        
        contentView.addSubview(audioSwitch)
        audioSwitch.addTarget(self, action: #selector(self.didToggle), for: .valueChanged)
        audioSwitch.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: audioSwitch, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -8))
        contentView.addConstraint(NSLayoutConstraint(item: audioSwitch, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    func didToggle() {
        Settings.isAudioEnabled = audioSwitch.isOn
    }
}
