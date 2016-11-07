//
//  DualKeyboardView.swift
//  SplitKeys
//
//  Created by Owen Yang on 10/4/16.
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import UIKit

class DualKeyboard: Keyboard {
    
    private let divider = UIView()
    private let leftButton = UIView()
    private let rightButton = UIView()
    
    let leftLabel = UILabel()
    let rightLabel = UILabel()
    
    let leftTapGestureRecognizer = UITapGestureRecognizer()
    let rightTapGestureRecognizer = UITapGestureRecognizer()
    let leftlongPressGestureRecognizer = UILongPressGestureRecognizer()
    let rightlongPressGestureRecognizer = UILongPressGestureRecognizer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        leftButton.addGestureRecognizer(leftTapGestureRecognizer)
        rightButton.addGestureRecognizer(rightTapGestureRecognizer)
        leftButton.addGestureRecognizer(leftlongPressGestureRecognizer)
        rightButton.addGestureRecognizer(rightlongPressGestureRecognizer)
        
        leftTapGestureRecognizer.addTarget(self, action: #selector(didTapButton(sender:)))
        rightTapGestureRecognizer.addTarget(self, action: #selector(didTapButton(sender:)))
        
        // divider
        addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .darkGray
        addConstraint(NSLayoutConstraint(item: divider, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: divider, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: divider, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: divider, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 2))
        
        // leftButton
        addSubview(leftButton)
        leftButton.backgroundColor = defaultButtonColor
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: leftButton, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: leftButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: leftButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: leftButton, attribute: .right, relatedBy: .equal, toItem: divider, attribute: .left, multiplier: 1, constant: 0))
        
        // rightButton
        addSubview(rightButton)
        rightButton.backgroundColor = defaultButtonColor
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: rightButton, attribute: .left, relatedBy: .equal, toItem: divider, attribute: .right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: rightButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: rightButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: rightButton, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
        
        let labelOffset = CGFloat(Settings.contrastBarSize / 2)
        
        // leftLabel
        leftButton.addSubview(leftLabel)
        leftLabel.font = defaultLabelFont
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        leftButton.addConstraint(NSLayoutConstraint(item: leftLabel, attribute: .centerX, relatedBy: .equal, toItem: leftButton, attribute: .centerX, multiplier: 1, constant: 0))
        leftButton.addConstraint(NSLayoutConstraint(item: leftLabel, attribute: .centerY, relatedBy: .equal, toItem: leftButton, attribute: .centerY, multiplier: 1, constant: labelOffset))
        
        // rightLabel
        rightButton.addSubview(rightLabel)
        rightLabel.font = defaultLabelFont
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        rightButton.addConstraint(NSLayoutConstraint(item: rightLabel, attribute: .centerX, relatedBy: .equal, toItem: rightButton, attribute: .centerX, multiplier: 1, constant: 0))
        rightButton.addConstraint(NSLayoutConstraint(item: rightLabel, attribute: .centerY, relatedBy: .equal, toItem: rightButton, attribute: .centerY, multiplier: 1, constant: labelOffset))
    }
}
