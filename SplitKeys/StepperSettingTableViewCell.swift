//
//  StepperSettingTableViewCell.swift
//  SplitKeys
//
//  Created by Owen Yang on 11/6/16.
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import UIKit

class StepperSettingTableViewCell: SettingTableViewCell {
    let valueStepper = UIStepper()
    let valueDisplay = UILabel()

    override init() {
        super.init()

        initStepperValues()
        setValueDisplayText()
        valueStepper.addTarget(self, action: #selector(self.didStep), for: .valueChanged)

        contentView.addSubview(valueStepper)
        valueStepper.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: valueStepper, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -8))
        contentView.addConstraint(NSLayoutConstraint(item: valueStepper, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0))

        contentView.addSubview(valueDisplay)
        valueDisplay.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: valueDisplay, attribute: .right, relatedBy: .equal, toItem: valueStepper, attribute: .left, multiplier: 1, constant: -8))
        contentView.addConstraint(NSLayoutConstraint(item: valueDisplay, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0))
    }

    func initStepperValues() {
        fatalError("initStepperValues() has not been implemented")
    }

    func didStep() {
        setValueDisplayText()
    }

    func setValueDisplayText() {
        fatalError("setValueDisplayText() has not been implemented")
    }
}
