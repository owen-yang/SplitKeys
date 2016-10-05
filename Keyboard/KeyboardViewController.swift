//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Owen Yang on 9/28/16.
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController, KeyboardDelegate {
    
    let upperKeyboard = UpperKeyboard()
    let lowerKeyboard = LowerKeyboard()
    
    var currentKeyboard: Keyboard
    
    // TODO: replace nextKeyboardButton and nextModeButton with gestures
    let nextKeyboardButton = UIButton(type: .system)
    let nextModeButton = UIButton(type: .system)
    
    enum Mode {
        case upper
        case lower
        case numeral
        case symbol
    }
    
    private var mode: Mode = .upper {
        didSet {
            switch (mode) {
            case .upper:
                loadKeyboard(upperKeyboard)
            case .lower:
                loadKeyboard(lowerKeyboard)
            default:
                break
            }
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {        
        currentKeyboard = upperKeyboard

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        upperKeyboard.delegate = self
        lowerKeyboard.delegate = self
        
        // TODO: remove when gestures are added
        nextKeyboardButton.setTitle("NextKB", for: .normal)
        nextModeButton.setTitle("NextMode", for: .normal)
        nextKeyboardButton.addTarget(self, action: #selector(UIInputViewController.advanceToNextInputMode), for: .touchUpInside)
        nextModeButton.addTarget(self, action: #selector(self.switchToNextMode), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadKeyboard(upperKeyboard)

        // TODO: remove when gestures are added
        
        // nextKeyboardButton
        view.addSubview(nextKeyboardButton)
        nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: nextKeyboardButton, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: nextKeyboardButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
        
        // nextModeButton
        view.addSubview(nextModeButton)
        nextModeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: nextModeButton, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: nextModeButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))

    }
    
    private func loadKeyboard(_ keyboard: Keyboard) {
        currentKeyboard.removeFromSuperview()
        currentKeyboard = keyboard
        keyboard.resetKeys()
        view.addSubview(keyboard)
        view.sendSubview(toBack: keyboard) // TODO: remove when gestures are added
        keyboard.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: keyboard, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: keyboard, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: keyboard, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: keyboard, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
    }
    
    func didSelect(char: Character) {
        textDocumentProxy.insertText("\(char)")
    }
    
    func switchToNextMode() {
        switch mode {
        case .upper:
            mode = .lower
        case .lower:
            mode = .upper
        default:
            break
        }
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        currentKeyboard.resetKeys()
    }
}
