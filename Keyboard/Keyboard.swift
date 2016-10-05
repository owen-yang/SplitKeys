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
    func resetKeys() {}
    var defaultButtonColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
    var defaultLabelFont = UIFont.systemFont(ofSize: 40)
}

protocol KeyboardDelegate {
    func didSelect(char: Character)
}
