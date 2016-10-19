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
    var keyboardJustSwitched = false
    
    var currentKeyboard: Keyboard
    
    let swipeDownRecognizer = UISwipeGestureRecognizer()
    let swipeRightRecognizer = UISwipeGestureRecognizer()
    let swipeLeftRecognizer = UISwipeGestureRecognizer()
    let swipeUpRecognizer = UISwipeGestureRecognizer()
    var periodJustEntered = false
    
    var timeSpaceLastUsed = NSDate()
    let speechSynthesizer = AVSpeechSynthesizer()
    let spaceUtterance = AVSpeechUtterance(string: "space")
    let periodUtterance = AVSpeechUtterance(string: ".")
    let backspaceUtterance = AVSpeechUtterance(string: "backspace")
    var characterJustSelected = false
    
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
        swipeDownRecognizer.addTarget(self, action: #selector(self.didSwipeDown))
        
        swipeLeftRecognizer.direction = .left
        swipeLeftRecognizer.addTarget(self, action: #selector(self.didSwipeLeft))
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
        if Settings.isAudioEnabled {
            speakImmediate(word: currentKeyboard.getName())
        }
        keyboardJustSwitched = true
        handleStateChange()
    }
    
    func didSelect(char: Character) {
        textDocumentProxy.insertText("\(char)")
        if Settings.isAudioEnabled {
            speechSynthesizer.stopSpeaking(at: .immediate)
            speechSynthesizer.speak(AVSpeechUtterance(string: "\(char)"))
        }
        characterJustSelected = true
    }
    
    func didSwipeLeft() {
        if currentKeyboard.isUserTyping() {
            currentKeyboard.resetKeys()
            handleStateChange()
        } else {
            handleBackspace()
        }
    }
    
    func handleBackspace() {
        textDocumentProxy.deleteBackward()
        if Settings.isAudioEnabled {
            speakImmediate(word: "backspace")
        }
    }
    
    func didSwipeDown() {
        let spaceDate = NSDate()
        if spaceDate.timeIntervalSince(timeSpaceLastUsed as Date) < 0.5 && !periodJustEntered {
            handlePeriodSpace()
        } else {
            handleSpace()
        }
        timeSpaceLastUsed = spaceDate
    }
    
    func handleSpace() {
        textDocumentProxy.insertText(" ")
        if Settings.isAudioEnabled {
            speakImmediate(word: "space")
        }
    }
    
    func handlePeriodSpace() {
        textDocumentProxy.deleteBackward()
        textDocumentProxy.insertText(".")
        textDocumentProxy.insertText(" ")
        if Settings.isAudioEnabled {
            speechSynthesizer.stopSpeaking(at: .immediate)
            speechSynthesizer.speak(periodUtterance)
            speechSynthesizer.speak(spaceUtterance)
        }
        periodJustEntered = true
    }
    
    func speakImmediate(word: String) {
        speechSynthesizer.stopSpeaking(at: .immediate)
        speechSynthesizer.speak(AVSpeechUtterance(string: word))
    }
    
    func announceState(state: String) {
        let wordsArray = state.lowercased().characters.split(separator: " ").map(String.init)
        if !characterJustSelected && !keyboardJustSwitched {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        for word in wordsArray {
            speechSynthesizer.speak(AVSpeechUtterance(string: word))
        }
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
    
    func handleStateChange() {
        if Settings.isAudioEnabled {
           announceState(state: currentKeyboard.getStateString())
        }
        characterJustSelected = false
        periodJustEntered = false
        keyboardJustSwitched = false
    }
}
