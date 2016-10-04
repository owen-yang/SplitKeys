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
    
    private let buttonColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        leftButton.addGestureRecognizer(leftTapGestureRecognizer)
        rightButton.addGestureRecognizer(rightTapGestureRecognizer)
        
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
        leftButton.backgroundColor = buttonColor
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: leftButton, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: leftButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: leftButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: leftButton, attribute: .right, relatedBy: .equal, toItem: divider, attribute: .left, multiplier: 1, constant: 0))
        
        // rightButton
        addSubview(rightButton)
        rightButton.backgroundColor = buttonColor
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: rightButton, attribute: .left, relatedBy: .equal, toItem: divider, attribute: .right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: rightButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: rightButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: rightButton, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
        
        // leftLabel
        leftButton.addSubview(leftLabel)
        leftLabel.font = leftLabel.font?.withSize(40)
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        leftButton.addConstraint(NSLayoutConstraint(item: leftLabel, attribute: .centerX, relatedBy: .equal, toItem: leftButton, attribute: .centerX, multiplier: 1, constant: 0))
        leftButton.addConstraint(NSLayoutConstraint(item: leftLabel, attribute: .centerY, relatedBy: .equal, toItem: leftButton, attribute: .centerY, multiplier: 1, constant: 0))
        
        // rightLabel
        rightButton.addSubview(rightLabel)
        rightLabel.font = rightLabel.font?.withSize(40)
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        rightButton.addConstraint(NSLayoutConstraint(item: rightLabel, attribute: .centerX, relatedBy: .equal, toItem: rightButton, attribute: .centerX, multiplier: 1, constant: 0))
        rightButton.addConstraint(NSLayoutConstraint(item: rightLabel, attribute: .centerY, relatedBy: .equal, toItem: rightButton, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AlphaKeyboard: DualKeyboard {
    var charSet: [Character] = [] {
        didSet {
            resetKeys()
        }
    }
    
    private var leftLowerIndex = 0
    private var leftUpperIndex = 0
    private var rightLowerIndex = 0
    private var rightUpperIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        leftTapGestureRecognizer.addTarget(self, action: #selector(self.didTapButton(sender:)))
        rightTapGestureRecognizer.addTarget(self, action: #selector(self.didTapButton(sender:)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapButton(sender: UITapGestureRecognizer) {
        if sender == leftTapGestureRecognizer {
            if leftLowerIndex == leftUpperIndex {
                delegate?.didSelect(char: charSet[leftLowerIndex])
                resetIndexes()
            } else {
                expandLeftIndexes()
            }
        } else if sender == rightTapGestureRecognizer {
            if rightLowerIndex == rightUpperIndex {
                delegate?.didSelect(char: charSet[rightLowerIndex])
                resetIndexes()
            } else {
                expandRightIndexes()
            }
        }
    }
    
    override func resetKeys() {
        resetIndexes()
    }
    
    private func resetIndexes() {
        leftLowerIndex = 0
        leftUpperIndex = charSet.count / 2 - 1
        rightLowerIndex = min(leftUpperIndex + 1, rightUpperIndex)
        rightUpperIndex = charSet.count - 1
        updateButtonLabels()
    }
    
    private func expandLeftIndexes() {
        rightUpperIndex = leftUpperIndex
        leftUpperIndex = (leftLowerIndex + leftUpperIndex) / 2
        rightLowerIndex = min(leftUpperIndex + 1, rightUpperIndex)
        updateButtonLabels()
    }
    
    private func expandRightIndexes() {
        leftLowerIndex = rightLowerIndex
        leftUpperIndex = (rightLowerIndex + rightUpperIndex) / 2
        rightLowerIndex = min(leftUpperIndex + 1, rightUpperIndex)
        updateButtonLabels()
    }
    
    private func updateButtonLabels() {
        leftLabel.text = "\(charSet[leftLowerIndex])"
        if leftLowerIndex != leftUpperIndex {
            leftLabel.text? += "...\(charSet[leftUpperIndex])"
        }
        
        rightLabel.text = "\(charSet[rightLowerIndex])"
        if rightLowerIndex != rightUpperIndex {
            rightLabel.text? += "...\(charSet[rightUpperIndex])"
        }
    }
}

class UpperKeyboard: AlphaKeyboard {
    override init(frame: CGRect) {
        super.init(frame: frame)
        charSet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LowerKeyboard: AlphaKeyboard {
    override init(frame: CGRect) {
        super.init(frame: frame)
        charSet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
