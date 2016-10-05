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
    let numeralKeyboard = SingleKeyboard()
    let symbolKeyboard = SingleKeyboard()
    
    var currentKeyboard: Keyboard
    
    let swipeDownRecognizer = UISwipeGestureRecognizer()
    let swipeRightRecognizer = UISwipeGestureRecognizer()
    let swipeLeftRecognizer = UISwipeGestureRecognizer()
    let swipeUpRecognizer = UISwipeGestureRecognizer()
    let twoSwipeDownRecognizer = UISwipeGestureRecognizer()
    
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
            case .numeral:
                loadKeyboard(numeralKeyboard)
            case .symbol:
                loadKeyboard(symbolKeyboard)
            }
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {        
        currentKeyboard = upperKeyboard

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        upperKeyboard.delegate = self
        lowerKeyboard.delegate = self
        
        swipeRightRecognizer.direction = UISwipeGestureRecognizerDirection.right
        swipeRightRecognizer.addTarget(self, action: #selector(self.switchToNextMode))
        
        swipeUpRecognizer.direction = UISwipeGestureRecognizerDirection.up
        swipeUpRecognizer.addTarget(self, action: #selector(UIInputViewController.advanceToNextInputMode))
        
        swipeDownRecognizer.direction = UISwipeGestureRecognizerDirection.down
        swipeDownRecognizer.addTarget(self, action: #selector(self.didSpace))
        
        swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirection.left
        swipeLeftRecognizer.addTarget(self, action: #selector(self.didBackspace))
        
        twoSwipeDownRecognizer.numberOfTouchesRequired = 2
        twoSwipeDownRecognizer.direction = UISwipeGestureRecognizerDirection.down
        twoSwipeDownRecognizer.addTarget(self, action: #selector(self.didPeriodSpace))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadKeyboard(upperKeyboard)

        view.addGestureRecognizer(swipeRightRecognizer)
        view.addGestureRecognizer(swipeDownRecognizer)
        view.addGestureRecognizer(swipeLeftRecognizer)
        view.addGestureRecognizer(swipeUpRecognizer)
        view.addGestureRecognizer(twoSwipeDownRecognizer)

    }
    
    private func loadKeyboard(_ keyboard: Keyboard) {
        currentKeyboard.removeFromSuperview()
        currentKeyboard = keyboard
        keyboard.resetKeys()
        view.addSubview(keyboard)
        keyboard.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: keyboard, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: keyboard, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: keyboard, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: keyboard, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
    }
    
    func didSelect(char: Character) {
        textDocumentProxy.insertText("\(char)")
    }
    
    func didBackspace() {
        if currentKeyboard.isUserTyping() {
            currentKeyboard.resetKeys()
        } else {
            textDocumentProxy.deleteBackward()
        }
    }
    
    func didSpace() {
        self.didSelect(char: " ")
    }
    
    func didPeriodSpace() {
        self.didSelect(char: ".")
        self.didSelect(char: " ")
    }
    
    func switchToNextMode() {
        switch mode {
        case .upper:
            mode = .lower
        case .lower:
            mode = .numeral
        case .numeral:
            mode = .symbol
        case .symbol:
            mode = .upper
        }
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        currentKeyboard.resetKeys()
    }
}
