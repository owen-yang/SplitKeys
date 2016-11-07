//
//  KeyboardWaitTimeTableViewCell.swift
//  SplitKeys
//
//  Created by Owen Yang on 11/6/16.
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import UIKit

class KeyboardWaitTimeTableViewCell: StepperSettingTableViewCell {

    override init() {
        super.init()
        textLabel?.text = "Wait Time"
    }

    override func initStepperValues() {
        valueStepper.value = Settings.waitTime
        valueStepper.minimumValue = 0.25
        valueStepper.maximumValue = 4.0
        valueStepper.stepValue = 0.25
    }

    override func onStep() {
        Settings.waitTime = valueStepper.value
    }
    
    override func getValueDisplayText() -> String {
        return String(format: "%.2f sec", valueStepper.value)
    }
}
