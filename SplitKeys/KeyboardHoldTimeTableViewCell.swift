//
//  KeyboardHoldTimeTableViewCell.swift
//  SplitKeys
//
//  Created by Owen Yang on 11/6/16.
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import UIKit

class KeyboardHoldTimeTableViewCell: StepperSettingTableViewCell {

    override init() {
        super.init()
        textLabel?.text = "Key Hold Time"
    }

    override func initStepperValues() {
        valueStepper.value = Settings.holdTime
        valueStepper.minimumValue = 0.25
        valueStepper.maximumValue = 2.0
        valueStepper.stepValue = 0.25
    }

    override func onStep() {
        Settings.holdTime = valueStepper.value
    }

    override func getValueDisplayText() -> String {
        return String(format: "%.2f sec", valueStepper.value)
    }
}
