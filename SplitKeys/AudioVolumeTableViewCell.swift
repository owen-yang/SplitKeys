//
//  AudioVolumeTableViewCell.swift
//  SplitKeys
//
//  Created by Owen Yang on 10/30/16.
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import UIKit

class AudioVolumeTableViewCell: SettingTableViewCell {
    
    let volumeStepper = UIStepper()
    let volumeDisplay = UILabel()
    
    override init() {
        super.init()
        
        textLabel?.text = "Volume"
        volumeStepper.value = Settings.audioVolume * 100
        setVolumeDisplayText()
        
        volumeStepper.minimumValue = 0
        volumeStepper.maximumValue = 100
        volumeStepper.stepValue = 10
        volumeStepper.addTarget(self, action: #selector(self.didStep), for: .valueChanged)
        
        contentView.addSubview(volumeStepper)
        volumeStepper.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: volumeStepper, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -8))
        contentView.addConstraint(NSLayoutConstraint(item: volumeStepper, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0))
        
        contentView.addSubview(volumeDisplay)
        volumeDisplay.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: volumeDisplay, attribute: .right, relatedBy: .equal, toItem: volumeStepper, attribute: .left, multiplier: 1, constant: -8))
        contentView.addConstraint(NSLayoutConstraint(item: volumeDisplay, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    func didStep() {
        Settings.audioVolume = volumeStepper.value / 100
        setVolumeDisplayText()
    }
    
    private func setVolumeDisplayText() {
        volumeDisplay.text = String(format: "%.0f%%", volumeStepper.value)
    }
}
