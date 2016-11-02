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
    let contrastBarSize = 50
    let contrastBar = UIView()
    
    func resetKeys() {}
    
    func isUserTyping() -> Bool {return false}
    
    func handleButtonTap(sender: UITapGestureRecognizer) {
        fatalError("handleButtonTap(UITapGestureRecognizer) not implemented")
    }
    
    func getStateString() -> String {
        return ""
    }
    
    func getName() -> String {
        return ""
    }
    
    final func didTapButton(sender: UITapGestureRecognizer) {
        handleButtonTap(sender: sender)
        delegate?.handleStateChange()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let contrastBarTranslation = CGFloat(contrastBarSize)
        //contrast bar
        addSubview(contrastBar)
        contrastBar.backgroundColor = .black
        contrastBar.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: contrastBar, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: contrastBar, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: contrastBar, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: contrastBarTranslation))
        addConstraint(NSLayoutConstraint(item: contrastBar, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
    }
    
    // used at the end of sublass init functions to properly add the contrast bar
    // does not handle any adjusting of text or other ui element, simply adds the
    // contrastView as a subView to all given views, so that touches will still be read
    func addContrastBar(views: [UIView]) {
        for view in views {
            view.addSubview(contrastBar)
        }
        bringSubview(toFront: contrastBar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol KeyboardDelegate {
    func didSelect(char: Character)
    func handleStateChange()
}
