//
//  AudioSpeedTableViewCell.swift
//  SplitKeys
//
//  Created by Owen Yang on 11/2/16.
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import UIKit
import AVFoundation

class AudioSpeedTableViewCell: SettingTableViewCell {
    
    let speedStepper = UIStepper()
    let speedDisplay = UILabel()
    
    override init() {
        super.init()
                
        textLabel?.text = "Speed"
        speedStepper.value = speedToPercent(speed: Settings.audioSpeed)
        setspeedDisplayText()

        speedStepper.minimumValue = 0
        speedStepper.maximumValue = 200
        speedStepper.stepValue = 10
        speedStepper.addTarget(self, action: #selector(self.didStep), for: .valueChanged)

        contentView.addSubview(speedStepper)
        speedStepper.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: speedStepper, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -8))
        contentView.addConstraint(NSLayoutConstraint(item: speedStepper, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0))
        
        contentView.addSubview(speedDisplay)
        speedDisplay.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: speedDisplay, attribute: .right, relatedBy: .equal, toItem: speedStepper, attribute: .left, multiplier: 1, constant: -8))
        contentView.addConstraint(NSLayoutConstraint(item: speedDisplay, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    func didStep() {
        Settings.audioSpeed = percentToSpeed(percent: speedStepper.value)
        setspeedDisplayText()
    }
    
    private func setspeedDisplayText() {
        speedDisplay.text = String(format: "%.0f%%", speedStepper.value)
    }
    
    private func speedToPercent(speed: Double) -> Double {
        return (speed - Double(AVSpeechUtteranceDefaultSpeechRate)) * 100 + 100
    }
    
    private func percentToSpeed(percent: Double) -> Double {
        return percent * Double(AVSpeechUtteranceDefaultSpeechRate) / 100
    }
}
