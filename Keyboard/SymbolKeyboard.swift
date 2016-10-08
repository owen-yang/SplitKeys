//
//  SymbolKeyboard.swift
//  SplitKeys
//
//  Created by Kionte Harris on 10/5/16.
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import UIKit

class SymbolKeyboard: DualKeyboard {
    var charSet: [Character] = [] {
        didSet {
            resetKeys()
        }
    }
    
    private var symbolIndex = 0
    private var index = 0
    private var userTyping = false;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        charSet = [",", ".", "-", "\"", "_", "'", "(", ")", ";", "=", ":",
                   "/", "*", "!", "?", "$", ">", "{", "}", "[", "]", "\\", "+",
                   "|", "&", "<", "%", "@", "#", "^", "`", "~"]
        leftTapGestureRecognizer.addTarget(self, action: #selector(self.didTapButton(sender:)))
        rightTapGestureRecognizer.addTarget(self, action: #selector(self.didTapButton(sender:)))
        leftlongPressGestureRecognizer.addTarget(self, action: #selector(self.didSelectSymbol(sender:)))
        rightlongPressGestureRecognizer.addTarget(self, action: #selector(self.didSelectSymbol(sender:)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapButton(sender: UITapGestureRecognizer) {
        userTyping = true
        if sender == leftTapGestureRecognizer {
            previousSymbol()
        }
        else if sender == rightTapGestureRecognizer {
            nextSymbol()
        }
    }
    
    func didSelectSymbol(sender: UILongPressGestureRecognizer) {
        userTyping = true
        if sender.state == .ended {
            if sender == leftlongPressGestureRecognizer {
                index = (symbolIndex - 1) % charSet.count
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
        symbolIndex -= 1
        symbolIndex %= charSet.count
        updateButtonLabels()
    }
    
    private func updateButtonLabels() {
        if symbolIndex > 0 {
            leftLabel.text = "\(charSet[(symbolIndex - 1)])"
        }
        else {
            leftLabel.text = "\(charSet[charSet.count - 1])"
        }
        rightLabel.text = "\(charSet[symbolIndex])"
    }
    
    override func isUserTyping() -> Bool {
        return userTyping
    }
}
