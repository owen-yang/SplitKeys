//
//  ContrastBarSizeTableViewCell.swift
//  SplitKeys
//
//  Created by Owen Yang on 11/6/16.
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import UIKit

class ContrastBarSizeTableViewCell: SettingTableViewCell {
    
    let contrastBarSizeSegmentedControl = UISegmentedControl()
    let contrastBarSizeDisplay = UILabel()
    
    private let contrastBarOptions: [(size: ContrastBarSize, name: String)] = [(.small, "Small"), (.medium, "Medium"), (.large, "Large")]
    
    override init() {
        super.init()

        textLabel?.text = "Contrast Bar Size"

        for (index, option) in contrastBarOptions.enumerated() {
            contrastBarSizeSegmentedControl.insertSegment(withTitle: option.name, at: index, animated: false)
        }
        
        contrastBarSizeSegmentedControl.selectedSegmentIndex = contrastBarOptions.index(where: { (option: (size: ContrastBarSize, name: String)) -> Bool in
            return option.size == ContrastBarSize(rawValue: Settings.contrastBarSize)
        })!
        
        contrastBarSizeSegmentedControl.addTarget(self, action: #selector(self.onSelect), for: .valueChanged)
        
        contentView.addSubview(contrastBarSizeSegmentedControl)
        contrastBarSizeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: contrastBarSizeSegmentedControl, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -8))
        contentView.addConstraint(NSLayoutConstraint(item: contrastBarSizeSegmentedControl, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0))
        
        contentView.addSubview(contrastBarSizeDisplay)
        contrastBarSizeDisplay.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: contrastBarSizeDisplay, attribute: .right, relatedBy: .equal, toItem: contrastBarSizeSegmentedControl, attribute: .left, multiplier: 1, constant: -8))
        contentView.addConstraint(NSLayoutConstraint(item: contrastBarSizeDisplay, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    func onSelect() {
        Settings.contrastBarSize = contrastBarOptions[contrastBarSizeSegmentedControl.selectedSegmentIndex].size.rawValue
    }
}
