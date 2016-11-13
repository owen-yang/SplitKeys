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
    var autocorrectIsOn = false
    var currentKeyboard: Keyboard
    
    let swipeDownRecognizer = UISwipeGestureRecognizer()
    let swipeRightRecognizer = UISwipeGestureRecognizer()
    let swipeLeftRecognizer = UISwipeGestureRecognizer()
    let swipeUpRecognizer = UISwipeGestureRecognizer()
    let doubleSwipeDownRecognizer = UISwipeGestureRecognizer()
    var periodJustEntered = false
    
    var timeSpaceLastUsed = Date()
    var timeBackspaceLastUsed = Date()
    let speechSynthesizer = AVSpeechSynthesizer()
    var characterJustSelected = false
    
    let contrastBar = UIView()
    let suggestedWordLabel = UILabel()
    var suggestedWord: String = "" {
        didSet {
            suggestedWordLabel.text = suggestedWord
        }
    }

    
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
        
        doubleSwipeDownRecognizer.direction = .down
        doubleSwipeDownRecognizer.numberOfTouchesRequired = 2
        doubleSwipeDownRecognizer.addTarget(self, action: #selector(self.dismissKeyboard))
        
        swipeLeftRecognizer.direction = .left
        swipeLeftRecognizer.addTarget(self, action: #selector(self.didSwipeLeft))
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadKeyboard(upperKeyboard)

        let calculatedHeight = UIScreen.main.bounds.height * CGFloat(Settings.heightProportion)
        view.addConstraint(NSLayoutConstraint(item:view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: calculatedHeight))
        
        view.addGestureRecognizer(swipeRightRecognizer)
        view.addGestureRecognizer(swipeDownRecognizer)
        view.addGestureRecognizer(swipeLeftRecognizer)
        view.addGestureRecognizer(swipeUpRecognizer)
        view.addGestureRecognizer(doubleSwipeDownRecognizer)
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
        
        view.addSubview(contrastBar)
        contrastBar.backgroundColor = .black
        contrastBar.isUserInteractionEnabled = false
        contrastBar.translatesAutoresizingMaskIntoConstraints = false

        let labelOffset = CGFloat(Settings.contrastBarSize / 12)
        contrastBar.addSubview(suggestedWordLabel)
        suggestedWordLabel.textColor = .yellow
        suggestedWordLabel.textAlignment = .center
        suggestedWordLabel.font = UIFont.systemFont(ofSize: CGFloat(Settings.contrastBarSize))
        suggestedWordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraint(NSLayoutConstraint(item: contrastBar, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: contrastBar, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: contrastBar, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: CGFloat(Settings.contrastBarSize)))
        view.addConstraint(NSLayoutConstraint(item: contrastBar, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0))

        contrastBar.addConstraint(NSLayoutConstraint(item: suggestedWordLabel, attribute: .centerX, relatedBy: .equal, toItem: contrastBar, attribute: .centerX, multiplier: 1, constant: labelOffset))
        contrastBar.addConstraint(NSLayoutConstraint(item: suggestedWordLabel, attribute: .centerY, relatedBy: .equal, toItem: contrastBar, attribute: .centerY, multiplier: 1, constant: labelOffset))
        
        if Settings.isAudioEnabled {
            speakImmediate(word: currentKeyboard.getName())
        }
        keyboardJustSwitched = true
        handleStateChange()
    }
    
    func didSelect(char: Character) {
        if Settings.isAutocorrectEnabled {
            let delimiterCharSet = ",.!?\")"
            let isDelimiterChar = delimiterCharSet.contains("\(char)")
            let proxy = self.textDocumentProxy
            
            if isDelimiterChar {
                delimiterAutocorrect()
                textDocumentProxy.insertText("\(char)")
            }
            else {
                textDocumentProxy.insertText("\(char)")
                let spellChecker = UITextChecker()
                if let lastWord = proxy.documentContextBeforeInput?.components(separatedBy: " ").last! {
                    let wordRange = NSRange(0..<(lastWord.utf16.count))
                    let misspelledRange = spellChecker.rangeOfMisspelledWord(in: lastWord, range: wordRange, startingAt: 0, wrap: false, language: "en_US")
                    if (misspelledRange.location != NSNotFound) {
                        let wordGuesses = spellChecker.guesses(forWordRange: wordRange, in: lastWord, language: "en_US")
                        if ((wordGuesses?.count) != 0) {
                            suggestedWord = (wordGuesses?[0])!
                            autocorrectIsOn = true
                        }
                    }
                    else {
                        autocorrectIsOn = false
                        suggestedWord = ""
                    }
                }
            }
        }
        else {
            textDocumentProxy.insertText("\(char)")
        }

        if Settings.isAudioEnabled {
            speechSynthesizer.stopSpeaking(at: .immediate)
            speechSynthesizer.speak(createUtterance(word: "\(char)"))
        }
        characterJustSelected = true
    }
    
    func didSwipeLeft() {
        
        if (autocorrectIsOn) {
            autocorrectIsOn = false
            suggestedWord = ""
        }
        else {
            let backspaceDate = Date()
            if currentKeyboard.isUserTyping() {
                currentKeyboard.resetKeys()
                handleStateChange()
            } else {
                if backspaceDate.timeIntervalSince(timeBackspaceLastUsed) < 0.5 && canDeleteWord() {
                    deleteWord()
                } else {
                    backspace()
                }
                timeBackspaceLastUsed = backspaceDate
            }
        }
    }
    
    func backspace() {
        textDocumentProxy.deleteBackward()
        if Settings.isAudioEnabled {
            speakImmediate(word: "backspace")
        }
    }
    
    func didSwipeDown() {
        let spaceDate = Date()
        if spaceDate.timeIntervalSince(timeSpaceLastUsed) < 0.5 && !periodJustEntered {
            handlePeriodSpace()
        } else {
            handleSpace()
        }
        timeSpaceLastUsed = spaceDate
    }
    
    func delimiterAutocorrect() {
        if Settings.isAutocorrectEnabled {
            let proxy = self.textDocumentProxy
            if autocorrectIsOn && canDeleteWord() && suggestedWord != "" {
                deleteWord()
                proxy.insertText(suggestedWord)
            }
            suggestedWord = ""
            autocorrectIsOn = false
        }
    }
    
    func handleSpace() {
        delimiterAutocorrect()
        textDocumentProxy.insertText(" ")
        if Settings.isAudioEnabled {
            speakImmediate(word: "space")
        }
    }
    
    func canDeleteWord() -> Bool {
        return textDocumentProxy.documentContextBeforeInput?.characters.last! != " "
    }

    func deleteWord() {
        let proxy = self.textDocumentProxy
        if let lastWord = proxy.documentContextBeforeInput?.components(separatedBy: " ") {
            for _ in 0 ..< (lastWord.last?.characters.count)! {
                proxy.deleteBackward()
            }
        }
    }
    
    func handlePeriodSpace() {
        textDocumentProxy.deleteBackward()
        delimiterAutocorrect()
        textDocumentProxy.insertText(".")
        textDocumentProxy.insertText(" ")
        if Settings.isAudioEnabled {
            speechSynthesizer.stopSpeaking(at: .immediate)
            speechSynthesizer.speak(createUtterance(word: "."))
            speechSynthesizer.speak(createUtterance(word: "space"))
        }
        periodJustEntered = true
    }
    
    func speakImmediate(word: String) {
        speechSynthesizer.stopSpeaking(at: .immediate)
        speechSynthesizer.speak(createUtterance(word: word))
    }
    
    func announceState(state: String) {
        let wordsArray = state.lowercased().characters.split(separator: " ").map(String.init)
        if !characterJustSelected && !keyboardJustSwitched {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        for word in wordsArray {
            speechSynthesizer.speak(createUtterance(word: word))
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
    
    func createUtterance(word: String) -> AVSpeechUtterance {
        let result = AVSpeechUtterance(string: word)
        result.rate = Float(Settings.audioSpeed)
        result.volume = Float(Settings.audioVolume)
        return result
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
