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
        charSet = [".", "\"", ")", "(", "?", ":", "'", "!", ";", "-", "*",
                   "@", "_", "=", "%", "$", "#", "&", "/", ">", "{", "}", "[",
                   "]", "\\", "+", "|", "<", "~", "^", "`", ","]
        leftTapGestureRecognizer.addTarget(self, action: #selector(self.didTapButton(sender:)))
        rightTapGestureRecognizer.addTarget(self, action: #selector(self.didTapButton(sender:)))
        leftlongPressGestureRecognizer.addTarget(self, action: #selector(self.didSelectSymbol(sender:)))
        rightlongPressGestureRecognizer.addTarget(self, action: #selector(self.didSelectSymbol(sender:)))
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
    
    override func getStateString() -> [String] {
        return [(symbolIndex > 0 ? "\(charSet[symbolIndex - 1])" : "\(charSet[charSet.count - 1])"),
            "\(charSet[symbolIndex])"]
    }
    
    func didSelectSymbol(sender: UILongPressGestureRecognizer) {
        userTyping = true
        if sender.state == .began {
            if sender == leftlongPressGestureRecognizer {
                index = symbolIndex > 0 ? (symbolIndex - 1) : charSet.count - 1
                delegate?.didSelect(char: charSet[index])
            }
            else if sender == rightlongPressGestureRecognizer {
                delegate?.didSelect(char: charSet[symbolIndex])
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
    
    override func getName() -> String {
        return "Symbols"
    }
}
