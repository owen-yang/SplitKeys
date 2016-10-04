//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Owen Yang on 9/28/16.
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    
    let doubleView = UIView()
    let divider = UIView()
    
    let leftButton = UIView()
    let leftLabel = UILabel()
    let rightButton = UIView()
    let rightLabel = UILabel()
    
    let leftTapGestureRecognizer = UITapGestureRecognizer()
    let rightTapGestureRecognizer = UITapGestureRecognizer()
    
    let nextKeyboardButton = UIButton(type: .system)
    let nextModeButton = UIButton(type: .system)
    
    let upperChars: [Character] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    let lowerChars: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
    var currentCharSet: [Character]
    
    var leftLowerIndex = 0
    var leftUpperIndex = 0
    var rightLowerIndex = 0
    var rightUpperIndex = 0
    
    enum Mode {
        case upper
        case lower
        case numeral
        case symbol
    }
    
    var mode: Mode = .upper {
        didSet {
            resetButtonBounds()
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        leftLabel.font = leftLabel.font?.withSize(40)
        rightLabel.font = rightLabel.font?.withSize(40)
        
        nextKeyboardButton.setTitle("NextKB", for: .normal)
        nextModeButton.setTitle("NextMode", for: .normal)
        
        currentCharSet = upperChars

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        resetButtonBounds()
        nextKeyboardButton.addTarget(self, action: #selector(UIInputViewController.advanceToNextInputMode), for: .touchUpInside)
        nextModeButton.addTarget(self, action: #selector(self.switchToNextMode), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGestureRecognizers()
        loadSubviews()
        addConstraints()
    }
    
    func loadGestureRecognizers() {
        leftTapGestureRecognizer.addTarget(self, action: #selector(self.didTapButton(sender:)))
        leftButton.addGestureRecognizer(leftTapGestureRecognizer)
        rightTapGestureRecognizer.addTarget(self, action: #selector(self.didTapButton(sender:)))
        rightButton.addGestureRecognizer(rightTapGestureRecognizer)
    }
    
    func loadSubviews() {
        view.addSubview(doubleView)
        
        divider.backgroundColor = .darkGray
        doubleView.addSubview(divider)
        
        leftButton.backgroundColor = .white
        doubleView.addSubview(leftButton)
        
        rightButton.backgroundColor = .white
        doubleView.addSubview(rightButton)
        
        leftButton.addSubview(leftLabel)
        rightButton.addSubview(rightLabel)
        
        doubleView.addSubview(nextKeyboardButton)
        doubleView.addSubview(nextModeButton)
    }
    
    func addConstraints() {
        // doubleView
        doubleView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: doubleView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: doubleView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: doubleView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: doubleView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
        
        // divider
        divider.translatesAutoresizingMaskIntoConstraints = false
        doubleView.addConstraint(NSLayoutConstraint(item: divider, attribute: .centerX, relatedBy: .equal, toItem: doubleView, attribute: .centerX, multiplier: 1, constant: 0))
        doubleView.addConstraint(NSLayoutConstraint(item: divider, attribute: .top, relatedBy: .equal, toItem: doubleView, attribute: .top, multiplier: 1, constant: 0))
        doubleView.addConstraint(NSLayoutConstraint(item: divider, attribute: .bottom, relatedBy: .equal, toItem: doubleView, attribute: .bottom, multiplier: 1, constant: 0))
        doubleView.addConstraint(NSLayoutConstraint(item: divider, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 2))
        
        // leftButton
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        doubleView.addConstraint(NSLayoutConstraint(item: leftButton, attribute: .left, relatedBy: .equal, toItem: doubleView, attribute: .left, multiplier: 1, constant: 0))
        doubleView.addConstraint(NSLayoutConstraint(item: leftButton, attribute: .top, relatedBy: .equal, toItem: doubleView, attribute: .top, multiplier: 1, constant: 0))
        doubleView.addConstraint(NSLayoutConstraint(item: leftButton, attribute: .bottom, relatedBy: .equal, toItem: doubleView, attribute: .bottom, multiplier: 1, constant: 0))
        doubleView.addConstraint(NSLayoutConstraint(item: leftButton, attribute: .right, relatedBy: .equal, toItem: divider, attribute: .left, multiplier: 1, constant: 0))
        
        // leftLabel
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        leftButton.addConstraint(NSLayoutConstraint(item: leftLabel, attribute: .centerX, relatedBy: .equal, toItem: leftButton, attribute: .centerX, multiplier: 1, constant: 0))
        leftButton.addConstraint(NSLayoutConstraint(item: leftLabel, attribute: .centerY, relatedBy: .equal, toItem: leftButton, attribute: .centerY, multiplier: 1, constant: 0))
        
        // rightButton
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        doubleView.addConstraint(NSLayoutConstraint(item: rightButton, attribute: .left, relatedBy: .equal, toItem: divider, attribute: .right, multiplier: 1, constant: 0))
        doubleView.addConstraint(NSLayoutConstraint(item: rightButton, attribute: .top, relatedBy: .equal, toItem: doubleView, attribute: .top, multiplier: 1, constant: 0))
        doubleView.addConstraint(NSLayoutConstraint(item: rightButton, attribute: .bottom, relatedBy: .equal, toItem: doubleView, attribute: .bottom, multiplier: 1, constant: 0))
        doubleView.addConstraint(NSLayoutConstraint(item: rightButton, attribute: .right, relatedBy: .equal, toItem: doubleView, attribute: .right, multiplier: 1, constant: 0))
        
        // rightLabel
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        rightButton.addConstraint(NSLayoutConstraint(item: rightLabel, attribute: .centerX, relatedBy: .equal, toItem: rightButton, attribute: .centerX, multiplier: 1, constant: 0))
        rightButton.addConstraint(NSLayoutConstraint(item: rightLabel, attribute: .centerY, relatedBy: .equal, toItem: rightButton, attribute: .centerY, multiplier: 1, constant: 0))
        
        // nextKeyboardButton
        nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        doubleView.addConstraint(NSLayoutConstraint(item: nextKeyboardButton, attribute: .left, relatedBy: .equal, toItem: doubleView, attribute: .left, multiplier: 1, constant: 0))
        doubleView.addConstraint(NSLayoutConstraint(item: nextKeyboardButton, attribute: .bottom, relatedBy: .equal, toItem: doubleView, attribute: .bottom, multiplier: 1, constant: 0))
        
        // nextModeButton
        nextModeButton.translatesAutoresizingMaskIntoConstraints = false
        doubleView.addConstraint(NSLayoutConstraint(item: nextModeButton, attribute: .right, relatedBy: .equal, toItem: doubleView, attribute: .right, multiplier: 1, constant: 0))
        doubleView.addConstraint(NSLayoutConstraint(item: nextModeButton, attribute: .bottom, relatedBy: .equal, toItem: doubleView, attribute: .bottom, multiplier: 1, constant: 0))
    }
    
    func didTapButton(sender: UITapGestureRecognizer) {
        if sender == leftTapGestureRecognizer {
            print("Left tapped")
        } else if sender == rightTapGestureRecognizer {
            print("Right tapped")
        }
        
        updateButtonBounds(sender: sender)
    }
    
    func updateButtonBounds(sender: UITapGestureRecognizer) {
        if sender == leftTapGestureRecognizer {
            if leftLowerIndex == leftUpperIndex {
                textDocumentProxy.insertText("\(currentCharSet[leftLowerIndex])")
                resetButtonBounds()
            } else {
                expandLeftBounds()
            }
        } else if sender == rightTapGestureRecognizer {
            if rightLowerIndex == rightUpperIndex {
                textDocumentProxy.insertText("\(currentCharSet[rightLowerIndex])")
                resetButtonBounds()
            } else {
                expandRightBounds()
            }
        }
    }
    
    func resetButtonBounds() {
        leftLowerIndex = 0
        leftUpperIndex = 12
        rightLowerIndex = 13
        rightUpperIndex = 25
        updateButtonLabels()
    }
    
    func expandLeftBounds() {
        rightUpperIndex = leftUpperIndex
        leftUpperIndex = (leftLowerIndex + leftUpperIndex) / 2
        rightLowerIndex = leftUpperIndex + 1
        updateButtonLabels()
    }
    
    func expandRightBounds() {
        leftLowerIndex = rightLowerIndex
        leftUpperIndex = (rightLowerIndex + rightUpperIndex) / 2
        rightLowerIndex = leftUpperIndex + 1
        updateButtonLabels()
    }
    
    func updateButtonLabels() {
        switch mode {
        case .upper:
            fallthrough
        case .lower:
            if leftLowerIndex == leftUpperIndex {
                leftLabel.text = "\(currentCharSet[leftLowerIndex])"
            } else {
                leftLabel.text = "\(currentCharSet[leftLowerIndex])...\(currentCharSet[leftUpperIndex])"
            }
            if rightLowerIndex == rightUpperIndex {
                rightLabel.text = "\(currentCharSet[rightLowerIndex])"
            } else {
                rightLabel.text = "\(currentCharSet[rightLowerIndex])...\(currentCharSet[rightUpperIndex])"
            }
        default:
            break
        }
    }
    
    func switchToNextMode() {
        switch mode {
        case .upper:
            currentCharSet = lowerChars
            mode = .lower
        case .lower:
            currentCharSet = upperChars
            mode = .upper
        default:
            break
        }
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        resetButtonBounds()
    }
}
