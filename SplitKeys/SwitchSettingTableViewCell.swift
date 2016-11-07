//
//  SwitchSettingTableViewCell.swift
//  SplitKeys
//
//  Created by Owen Yang on 11/6/16.
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import UIKit

class SwitchSettingTableViewCell: SettingTableViewCell {
    
    let valueSwitch = UISwitch()
    
    override init() {
        super.init()

        initSwitchValue()

        contentView.addSubview(valueSwitch)
        valueSwitch.addTarget(self, action: #selector(self.onToggle), for: .valueChanged)
        valueSwitch.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: valueSwitch, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -8))
        contentView.addConstraint(NSLayoutConstraint(item: valueSwitch, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    func initSwitchValue() {
        fatalError("initSwitchValue() has not been implemented")
    }
    
    func onToggle() {
        // Do nothing; subclasses may override
    }
}
