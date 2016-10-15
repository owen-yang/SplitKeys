//
//  SymbolKeyboard.swift
//  SplitKeys
//
//  Created by Kionte Harris on 10/5/16.
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import UIKit
import AVFoundation

class SymbolKeyboard: DualKeyboard {
    var charSet: [Character] = [] {
        didSet {
            resetKeys()
        }
    }
    //Make symbol selection occur after certain amt of time instead of after button release
    private var symbolIndex = 0
    private var index = 0
    private var userTyping = false;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        charSet = [",", ".", "-", "\"", "_", "'", "(", ")", ";", "=", ":",
                   "/", "*", "!", "?", "$", ">", "{", "}", "[", "]", "\\", "+",
                   "|", "&", "<", "%", "@", "#", "^", "`", "~"]
        leftlongPressGestureRecognizer.addTarget(self, action: #selector(self.didSelectSymbol(sender:)))
        rightlongPressGestureRecognizer.addTarget(self, action: #selector(self.didSelectSymbol(sender:)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func handleButtonTap(sender: UITapGestureRecognizer) {
        userTyping = true
        if sender == leftTapGestureRecognizer {
            previousSymbol()
        }
        else if sender == rightTapGestureRecognizer {
            nextSymbol()
        }
    }
    
    override func announceState() {
        if !Settings.isAudioEnabled {
            return
        }
        if !charJustAnnounced {
            speechSynthesizer?.stopSpeaking(at: .immediate)
        }
        let leftUtterance = AVSpeechUtterance(string: symbolIndex > 0 ? "\(charSet[symbolIndex - 1])" : "\(charSet[charSet.count - 1])")
        let rightUtterance = AVSpeechUtterance(string: "\(charSet[symbolIndex])")
        speechSynthesizer?.speak(leftUtterance)
        speechSynthesizer?.speak(rightUtterance)
    }
    
    func didSelectSymbol(sender: UILongPressGestureRecognizer) {
        userTyping = true
        if sender.state == .began {
            if sender == leftlongPressGestureRecognizer {
                index = symbolIndex > 0 ? (symbolIndex - 1) : charSet.count - 1
                charSelected(char: charSet[index])
            }
            else if sender == rightlongPressGestureRecognizer {
                charSelected(char: charSet[symbolIndex])
            }
        }
    }
    
    override func resetKeys() {
        resetIndex()
        updateButtonLabels()
    }
    
    private func resetIndex() {
        userTyping = false
        symbolIndex = 0
    }
    
    private func nextSymbol() {
        symbolIndex += 1
        symbolIndex %= charSet.count
        updateButtonLabels()
    }
    
    private func previousSymbol() {
        symbolIndex += charSet.count - 1
        symbolIndex %= charSet.count
        updateButtonLabels()
    }
    
    private func updateButtonLabels() {
        leftLabel.text = symbolIndex > 0 ? "\(charSet[symbolIndex - 1])" : "\(charSet[charSet.count - 1])"
        rightLabel.text = "\(charSet[symbolIndex])"
    }
    
    override func isUserTyping() -> Bool {
        return userTyping
    }
}
