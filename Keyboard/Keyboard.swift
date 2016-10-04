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
}

protocol KeyboardDelegate {
    func didSelect(char: Character)
}
