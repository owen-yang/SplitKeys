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
    
    let keyboards = [UpperKeyboard(), LowerKeyboard(), NumeralKeyboard(), SpecialCharsKeyboard(), EmojiKeyboard()]
    var keyboardJustSwitched = false
    var autocorrectIsOn = false
    var currentKeyboard: Keyboard
    
    let swipeUpRecognizer = UISwipeGestureRecognizer()
    let swipeDownRecognizer = UISwipeGestureRecognizer()
    let swipeLeftRecognizer = UISwipeGestureRecognizer()
    let swipeRightRecognizer = UISwipeGestureRecognizer()
    let doubleSwipeDownRecognizer = UISwipeGestureRecognizer()
    let doubleSwipeRightRecognizer = UISwipeGestureRecognizer()
    var periodJustEntered = false
    
    var timeSpaceLastUsed = Date()
    var timeBackspaceLastUsed = Date()
    var speechSynthesizer = AVSpeechSynthesizer()
    var characterJustSelected = false
    
    let contrastBar = UIView()
    let suggestedWordLabel = UILabel()
    var suggestedWord: String = "" {
        didSet {
            suggestedWordLabel.text = suggestedWord
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {        
        currentKeyboard = keyboards[0]
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        for keyboard in keyboards {
            keyboard.delegate = self
        }
        
        swipeDownRecognizer.direction = .down
        swipeDownRecognizer.addTarget(self, action: #selector(self.switchToNextMode))
        
        swipeUpRecognizer.direction = .up
        swipeUpRecognizer.addTarget(self, action: #selector(UIInputViewController.advanceToNextInputMode))
        
        swipeRightRecognizer.direction = .right
        swipeRightRecognizer.addTarget(self, action: #selector(self.didSwipeRight))
        
        doubleSwipeRightRecognizer.direction = .right
        doubleSwipeRightRecognizer.numberOfTouchesRequired = 2
        doubleSwipeRightRecognizer.addTarget(self, action: #selector(self.handleNewLine))
        
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
        loadKeyboard(keyboards[0])

        let calculatedHeight = UIScreen.main.bounds.height * CGFloat(Settings.heightProportion)
        view.addConstraint(NSLayoutConstraint(item:view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: calculatedHeight))
        
        for gestureRecognizer in [swipeUpRecognizer, swipeDownRecognizer, swipeLeftRecognizer, swipeRightRecognizer, doubleSwipeDownRecognizer, doubleSwipeRightRecognizer] {
            view.addGestureRecognizer(gestureRecognizer)
        }
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
        view.addConstraint(NSLayoutConstraint(item: contrastBar, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: contrastBar, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: contrastBar, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: CGFloat(Settings.contrastBarSize)))
        view.addConstraint(NSLayoutConstraint(item: contrastBar, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0))

        contrastBar.addSubview(suggestedWordLabel)
        suggestedWordLabel.textColor = .yellow
        suggestedWordLabel.textAlignment = .center
        suggestedWordLabel.font = UIFont.systemFont(ofSize: CGFloat(Settings.contrastBarSize) * 0.8)
        suggestedWordLabel.translatesAutoresizingMaskIntoConstraints = false
        contrastBar.addConstraint(NSLayoutConstraint(item: suggestedWordLabel, attribute: .centerX, relatedBy: .equal, toItem: contrastBar, attribute: .centerX, multiplier: 1, constant: 0))
        contrastBar.addConstraint(NSLayoutConstraint(item: suggestedWordLabel, attribute: .centerY, relatedBy: .equal, toItem: contrastBar, attribute: .centerY, multiplier: 1, constant: 0))
        contrastBar.addConstraint(NSLayoutConstraint(item: suggestedWordLabel, attribute: .height, relatedBy: .equal, toItem: contrastBar, attribute: .height, multiplier: 1, constant: 0))
        contrastBar.addConstraint(NSLayoutConstraint(item: suggestedWordLabel, attribute: .width, relatedBy: .equal, toItem: contrastBar, attribute: .width, multiplier: 1, constant: 0))
        
        if Settings.isAudioEnabled {
            speakImmediate(words: [currentKeyboard.getName()])
        }
        keyboardJustSwitched = true
        handleStateChange()
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        currentKeyboard.resetKeys()
    }
    
    func didSelect(char: Character) {
        speakImmediate(words: ["\(char)"])
        characterJustSelected = true
        if Settings.isAutocorrectEnabled {
            if ",.!?\")".contains("\(char)") {
                delimiterAutocorrect()
                textDocumentProxy.insertText("\(char)")
            } else {
                textDocumentProxy.insertText("\(char)")
                let spellChecker = UITextChecker()
                if let lastWord = textDocumentProxy.documentContextBeforeInput?.components(separatedBy: " ").last {
                    let wordRange = NSRange(0..<(lastWord.utf16.count))
                    let misspelledRange = spellChecker.rangeOfMisspelledWord(in: lastWord, range: wordRange, startingAt: 0, wrap: false, language: "en_US")
                    if misspelledRange.location != NSNotFound {
                        let wordGuesses = spellChecker.guesses(forWordRange: wordRange, in: lastWord, language: "en_US")
                        if wordGuesses?.count != 0 {
                            suggestedWord = (wordGuesses?[0])!
                            announceAutoCorrect(phrase: "Did you mean " + suggestedWord + "?")
                            autocorrectIsOn = true
                        }
                    } else {
                        autocorrectIsOn = false
                        suggestedWord = ""
                    }
                }
            }
        } else {
            textDocumentProxy.insertText("\(char)")
        }
    }
    
    func didSwipeLeft() {
        if autocorrectIsOn {
            autocorrectIsOn = false
            suggestedWord = ""
            return
        }
        
        if currentKeyboard.isUserTyping() {
            currentKeyboard.resetKeys()
            handleStateChange()
            return
        }
        
        let backspaceDate = Date()
        if backspaceDate.timeIntervalSince(timeBackspaceLastUsed) < 0.5 && canDeleteWord() {
            deleteWord()
        } else {
            backspace()
        }
        timeBackspaceLastUsed = backspaceDate
    }
    
    func backspace() {
        textDocumentProxy.deleteBackward()
        speakImmediate(words: ["backspace"])
    }
    
    func didSwipeRight() {
        let spaceDate = Date()
        if spaceDate.timeIntervalSince(timeSpaceLastUsed) < 0.5 && !periodJustEntered {
            handlePeriodSpace()
        } else {
            handleSpace()
        }
        timeSpaceLastUsed = spaceDate
    }
    
    func handlePeriodSpace() {
        speakImmediate(words: [".", "space"])
        textDocumentProxy.deleteBackward()
        delimiterAutocorrect()
        textDocumentProxy.insertText(". ")
        periodJustEntered = true
    }
    
    func handleSpace() {
        speakImmediate(words: ["space"])
        delimiterAutocorrect()
        textDocumentProxy.insertText(" ")
    }
    
    func handleNewLine() {
        textDocumentProxy.insertText("\n")
        speakImmediate(words: ["new line"])
    }
    
    func delimiterAutocorrect() {
        if !Settings.isAutocorrectEnabled {
            return
        }

        if autocorrectIsOn && canDeleteWord() && suggestedWord != "" {
            deleteWord()
            textDocumentProxy.insertText(suggestedWord)
            announceAutoCorrect(phrase: "Autocorrected to " + suggestedWord)
            
        }
        suggestedWord = ""
        autocorrectIsOn = false
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
    
    func speakImmediate(words: [String]) {
        stopSynthesizer()
        speakWords(words: words, delayFirst: false)
    }
    
    func speakWords(words: [String], delayFirst: Bool) {
        if !Settings.isAudioEnabled {
            return
        }
        var first = true
        for word in words {
            speechSynthesizer.speak(createUtterance(word: word, delay: first && delayFirst))
            first = false
        }
    }
    
    func announceAutoCorrect(phrase: String) {
        if !Settings.isAutocorrectAudioEnabled {
            return
        }
        speakWords(words: [phrase], delayFirst: false)
    }
    
    func announceState(state: [String]) {
        if state.count <= 0 {
            return
        }
        
        if !characterJustSelected && !keyboardJustSwitched {
            stopSynthesizer()
        }
        speakWords(words: state[0].lowercased().characters.split(separator: " ").map(String.init), delayFirst: false)
        for i in 1 ..< state.count {
            let wordsArray = state[i].lowercased().characters.split(separator: " ").map(String.init)
            speakWords(words: wordsArray, delayFirst: true)
        }
        
    }
    
    func stopSynthesizer() {
        speechSynthesizer.stopSpeaking(at: .immediate)
        speechSynthesizer = AVSpeechSynthesizer()
    }

    func switchToNextMode() {
        let currentIndex = keyboards.index(of: currentKeyboard)!
        loadKeyboard(keyboards[(currentIndex + 1) % keyboards.count])
    }
    
    func createUtterance(word: String, delay: Bool) -> AVSpeechUtterance {
        let result = AVSpeechUtterance(string: word)
        result.rate = Float(Settings.audioSpeed)
        result.volume = Float(Settings.audioVolume)
        result.preUtteranceDelay = delay ? 0.3 : 0
        return result
    }
    
    func handleStateChange() {
        announceState(state: currentKeyboard.getStateString())
        characterJustSelected = false
        periodJustEntered = false
        keyboardJustSwitched = false
    }
}
