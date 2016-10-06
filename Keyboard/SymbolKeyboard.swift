//
//  SymbolKeyboard.swift
//  SplitKeys
//
//  Created by Kionte Harris on 10/5/16.
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import UIKit

class Symbols: DualKeyboard {
    var charSet: [Character] = [] {
    didSet {
            resetKeys()
        }
    }
    
    private var symbolIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        leftTapGestureRecognizer.addTarget(self, action: #selector(self.didTapButton(sender:)))
        rightTapGestureRecognizer.addTarget(self, action: #selector(self.didTapButton(sender:)))
        leftlongPressGestureRecognizer.addTarget(self, action: #selector(self.didSelectSymbol(sender:)))
        rightlongPressGestureRecognizer.addTarget(self, action: #selector(self.didSelectSymbol(sender:)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapButton(sender: UITapGestureRecognizer) {
        if sender == leftTapGestureRecognizer {
            previousSymbol()
        }
        else if sender == rightTapGestureRecognizer {
            nextSymbol()
        }
    }
    
    func didSelectSymbol(sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
        if sender == leftlongPressGestureRecognizer {
            if symbolIndex == 0 {
                delegate?.didSelect(char: charSet[charSet.count - 1])
            }
            else {
                delegate?.didSelect(char: charSet[symbolIndex - 1])
            }
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
        symbolIndex = 0
    }
    
    private func nextSymbol() {
        if symbolIndex < charSet.count - 1 {
            symbolIndex = symbolIndex + 1
        }
        else {
            symbolIndex = 0
        }
        updateButtonLabels()
    }
    
    private func previousSymbol() {
        if symbolIndex > 0 {
            symbolIndex = symbolIndex - 1
        }
        else { 
            symbolIndex = charSet.count - 1
        }
        updateButtonLabels()
    }
    
    private func updateButtonLabels() {
        if symbolIndex > 0 {
            leftLabel.text = "\(charSet[symbolIndex - 1])"
        }
        else {
            leftLabel.text = "\(charSet[charSet.count - 1])"
        }
        
        if symbolIndex == charSet.count - 1 {
            rightLabel.text = "\(charSet[0])"
        }
        else {
            rightLabel.text = "\(charSet[symbolIndex])"
        }
    }
}

class SymbolKeyboard: Symbols {
    var symbolString: String = ",.-\"_'();=:/*!?$>{}[]\\+|&<%@#^`~"
    override init(frame: CGRect) {
        super.init(frame: frame)
        charSet = Array(symbolString.characters)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
