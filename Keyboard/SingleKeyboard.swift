//
//  SingleKeyboardView.swift
//  SplitKeys
//
//  Created by Owen Yang on 10/4/16.
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import UIKit

class SingleKeyboard: Keyboard {
    
    private let button = UIView()
    let label = UILabel()
    let tapGestureRecognizer = UITapGestureRecognizer()
    let longPressGestureRecognizer = UILongPressGestureRecognizer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        button.addGestureRecognizer(tapGestureRecognizer)
        button.addGestureRecognizer(longPressGestureRecognizer)
                
        addSubview(button)
        button.backgroundColor = defaultButtonColor
        button.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        
        let textTranslation = CGFloat(50 / 2)
        button.addSubview(label)
        label.font = defaultLabelFont
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: textTranslation))
    }
}
