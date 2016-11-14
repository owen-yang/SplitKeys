//
//  AudioVolumeTableViewCell.swift
//  SplitKeys
//
//  Created by Owen Yang on 10/30/16.
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import UIKit

class AudioVolumeTableViewCell: StepperSettingTableViewCell {

    override init() {
        super.init()
        textLabel?.text = "Volume"
    }

    override func initStepperValues() {
        valueStepper.value = Settings.audioVolume
        valueStepper.minimumValue = 0.0
        valueStepper.maximumValue = 1.0
        valueStepper.stepValue = 0.10
    }

    override func onStep() {
        Settings.audioVolume = valueStepper.value
    }

    override func getValueDisplayText() -> String {
        return String(format: "%.0f%%", valueStepper.value * 100)
    }
}
