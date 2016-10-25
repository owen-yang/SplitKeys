//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Owen Yang on 9/28/16.
//
//  Edited by Samuel Dallstream
//
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import UIKit
import AVFoundation

class KeyboardViewController: UIInputViewController, KeyboardDelegate {
    
    let upperKeyboard = UpperKeyboard()
    let lowerKeyboard = LowerKeyboard()
    let numeralKeyboard = NumeralKeyboard()
    let symbolKeyboard = SymbolKeyboard()
    
    var currentKeyboard: Keyboard
    
    let swipeDownRecognizer = UISwipeGestureRecognizer()
    let swipeRightRecognizer = UISwipeGestureRecognizer()
    let swipeLeftRecognizer = UISwipeGestureRecognizer()
    let swipeUpRecognizer = UISwipeGestureRecognizer()
    
    var timeSpaceLastUsed = NSDate()
    var timeBackspaceLastUsed = NSDate()
    let speechSynthesizer = AVSpeechSynthesizer()
    
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
        symbolKeyboard.delegate = self
        numeralKeyboard.delegate = self
        
        swipeRightRecognizer.direction = .right
        swipeRightRecognizer.addTarget(self, action: #selector(self.switchToNextMode))
        
        swipeUpRecognizer.direction = .up
        swipeUpRecognizer.addTarget(self, action: #selector(UIInputViewController.advanceToNextInputMode))
        
        swipeDownRecognizer.direction = .down
        swipeDownRecognizer.addTarget(self, action: #selector(self.didSpace))
        
        swipeLeftRecognizer.direction = .left
        swipeLeftRecognizer.addTarget(self, action: #selector(self.didBackspace))
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
    
    func giveSelectedFeedback(char: Character) {
        if !Settings.isAudioEnabled {
            return
        }
        let speechUtterance = AVSpeechUtterance(string: "\(char)")
        speechSynthesizer.stopSpeaking(at: .immediate)
        speechSynthesizer.speak(speechUtterance)
    }
    
    func didSelect(char: Character) {
        textDocumentProxy.insertText("\(char)")
        if char != " " {
            giveSelectedFeedback(char: char)
        }
    }
    
    func didBackspace() {
        let backspaceDate = NSDate()
        if currentKeyboard.isUserTyping() {
            currentKeyboard.resetKeys()
        } else {
            if backspaceDate.timeIntervalSince(timeBackspaceLastUsed as Date) < 1 {
                deleteWord()
            } else {
                textDocumentProxy.deleteBackward()
            }
            timeBackspaceLastUsed = backspaceDate
        }
    }
    
    func didSpace() {
        let spaceDate = NSDate()
        if spaceDate.timeIntervalSince(timeSpaceLastUsed as Date) < 0.5 {
            handlePeriodSpace()
        } else {
            didSelect(char: " ")
        }
        timeSpaceLastUsed = spaceDate
    }
    
    func deleteWord() {
        let proxy = self.textDocumentProxy
        if let lastWord: [String]? = proxy.documentContextBeforeInput?.components(separatedBy: " ") {
            if let textArray = lastWord {
                for _ in 0 ..< (textArray.last?.characters.count)! {
                    proxy.deleteBackward()
                }
            }
        }
    }
    
    func handlePeriodSpace() {
        textDocumentProxy.deleteBackward()
        didSelect(char: ".")
        didSelect(char: " ")
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
