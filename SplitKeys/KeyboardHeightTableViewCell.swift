//
//  KeyboardHeightTableViewCell.swift
//  SplitKeys
//
//  Created by Owen Yang on 11/6/16.
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import UIKit

class KeyboardHeightTableViewCell: StepperSettingTableViewCell {

    override init() {
        super.init()
        textLabel?.text = "Keyboard Height"
    }

    override func initStepperValues() {
        valueStepper.value = Settings.heightProportion
        valueStepper.minimumValue = 0.20
        valueStepper.maximumValue = 0.80
        valueStepper.stepValue = 0.10
    }

    override func onStep() {
        Settings.heightProportion = valueStepper.value
    }

    override func getValueDisplayText() -> String {
        return String(format: "%.0f%%", valueStepper.value * 100)
    }
}
