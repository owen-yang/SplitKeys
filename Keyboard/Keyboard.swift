//
//  KeyboardView.swift
//  SplitKeys
//
//  Created by Owen Yang on 10/4/16.
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import UIKit

class Keyboard: UIView {
    var delegate: KeyboardDelegate?
    var defaultButtonColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
    var defaultLabelFont = UIFont.systemFont(ofSize: 40)
    
    func resetKeys() {}
    
    func isUserTyping() -> Bool {return false}
    
    func handleButtonTap(sender: UITapGestureRecognizer) {
        fatalError("handleButtonTap(UITapGestureRecognizer) not implemented")
    }
    
    func getStateString() -> [String] {
        return [""]
    }
    
    func getName() -> String {
        return ""
    }
    
    final func didTapButton(sender: UITapGestureRecognizer) {
        handleButtonTap(sender: sender)
        delegate?.handleStateChange()
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol KeyboardDelegate {
    func didSelect(char: Character)
    func handleStateChange()
}
