//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Owen Yang on 9/28/16.
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    
    var doubleView: UIView
    var divider: UIView
    var leftButton: UIView
    var rightButton: UIView
    
    var leftTapGestureRecognizer: UITapGestureRecognizer!
    var rightTapGestureRecognizer: UITapGestureRecognizer!
    
    var nextKeyboardButton: UIButton!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        doubleView = UIView()
        doubleView.translatesAutoresizingMaskIntoConstraints = false

        divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        leftButton = UIView()
        leftButton.translatesAutoresizingMaskIntoConstraints = false

        rightButton = UIView()
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        
        nextKeyboardButton = UIButton(type: .system)
        nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        nextKeyboardButton.setTitle("Next", for: .normal)

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGestureRecognizers()
        loadSubviews()
        addConstraints()
    }
    
    func loadGestureRecognizers() {
        leftTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapButton(sender:)))
        leftButton.addGestureRecognizer(leftTapGestureRecognizer)
        rightTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapButton(sender:)))
        rightButton.addGestureRecognizer(rightTapGestureRecognizer)
    }
    
    func loadSubviews() {
        view.addSubview(doubleView)
        
        divider.backgroundColor = .darkGray
        doubleView.addSubview(divider)
        
        leftButton.backgroundColor = .white
        doubleView.addSubview(leftButton)
        
        rightButton.backgroundColor = .white
        doubleView.addSubview(rightButton)
        
        nextKeyboardButton.addTarget(self, action: #selector(UIInputViewController.advanceToNextInputMode), for: .touchUpInside)
        nextKeyboardButton.sizeToFit()
        doubleView.addSubview(nextKeyboardButton)
    }
    
    func addConstraints() {
        // doubleView
        view.addConstraint(NSLayoutConstraint(item: doubleView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: doubleView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: doubleView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: doubleView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
        
        // divider
        doubleView.addConstraint(NSLayoutConstraint(item: divider, attribute: .centerX, relatedBy: .equal, toItem: doubleView, attribute: .centerX, multiplier: 1, constant: 0))
        doubleView.addConstraint(NSLayoutConstraint(item: divider, attribute: .top, relatedBy: .equal, toItem: doubleView, attribute: .top, multiplier: 1, constant: 0))
        doubleView.addConstraint(NSLayoutConstraint(item: divider, attribute: .bottom, relatedBy: .equal, toItem: doubleView, attribute: .bottom, multiplier: 1, constant: 0))
        doubleView.addConstraint(NSLayoutConstraint(item: divider, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 2))
        
        // leftButton
        doubleView.addConstraint(NSLayoutConstraint(item: leftButton, attribute: .left, relatedBy: .equal, toItem: doubleView, attribute: .left, multiplier: 1, constant: 0))
        doubleView.addConstraint(NSLayoutConstraint(item: leftButton, attribute: .top, relatedBy: .equal, toItem: doubleView, attribute: .top, multiplier: 1, constant: 0))
        doubleView.addConstraint(NSLayoutConstraint(item: leftButton, attribute: .bottom, relatedBy: .equal, toItem: doubleView, attribute: .bottom, multiplier: 1, constant: 0))
        doubleView.addConstraint(NSLayoutConstraint(item: leftButton, attribute: .right, relatedBy: .equal, toItem: divider, attribute: .left, multiplier: 1, constant: 0))
        
        // rightButton
        doubleView.addConstraint(NSLayoutConstraint(item: rightButton, attribute: .left, relatedBy: .equal, toItem: divider, attribute: .right, multiplier: 1, constant: 0))
        doubleView.addConstraint(NSLayoutConstraint(item: rightButton, attribute: .top, relatedBy: .equal, toItem: doubleView, attribute: .top, multiplier: 1, constant: 0))
        doubleView.addConstraint(NSLayoutConstraint(item: rightButton, attribute: .bottom, relatedBy: .equal, toItem: doubleView, attribute: .bottom, multiplier: 1, constant: 0))
        doubleView.addConstraint(NSLayoutConstraint(item: rightButton, attribute: .right, relatedBy: .equal, toItem: doubleView, attribute: .right, multiplier: 1, constant: 0))
        
        // nextKeyboardButton
        doubleView.addConstraint(NSLayoutConstraint(item: nextKeyboardButton, attribute: .left, relatedBy: .equal, toItem: doubleView, attribute: .left, multiplier: 1, constant: 0))
        doubleView.addConstraint(NSLayoutConstraint(item: nextKeyboardButton, attribute: .bottom, relatedBy: .equal, toItem: doubleView, attribute: .bottom, multiplier: 1, constant: 0))
    }
    
    func didTapButton(sender: UITapGestureRecognizer) {
        if (sender == leftTapGestureRecognizer) {
            textDocumentProxy.insertText("A")
            print("Left tapped")
        } else if (sender == rightTapGestureRecognizer) {
            textDocumentProxy.insertText("B")
            print("Right tapped")
        }
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    }

}
