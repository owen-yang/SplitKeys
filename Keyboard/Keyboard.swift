//
//  KeyboardView.swift
//  SplitKeys
//
//  Created by Owen Yang on 10/4/16.
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import UIKit
import AVFoundation

class Keyboard: UIView {
    var delegate: KeyboardDelegate?
    var defaultButtonColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
    var defaultLabelFont = UIFont.systemFont(ofSize: 40)
    var charJustAnnounced = false
    var speechSynthesizer: AVSpeechSynthesizer?
    
    func resetKeys() {}
    
    func isUserTyping() -> Bool {return false}
    
    func announceSelected(char: Character) {
        if !Settings.isAudioEnabled {
            return
        }
        let utterance = AVSpeechUtterance(string: "\(char)")
        speechSynthesizer?.stopSpeaking(at: .immediate)
        speechSynthesizer?.speak(utterance)
        charJustAnnounced = true
    }
    
    func handleButtonTap(sender: UITapGestureRecognizer) {
        fatalError("handleButtonTap(UITapGestureRecognizer) not implemented")
    }
    
    func announceState() {
        //fatalError("announceState() not implemented")
    }
    
    final func charSelected(char: Character) {
        delegate?.didSelect(char: char)
        announceSelected(char: char)
        charJustAnnounced = true
    }
    
    final func didTapButton(sender: UITapGestureRecognizer) {
        handleButtonTap(sender: sender)
        announceState()
        charJustAnnounced = false
    }
}

protocol KeyboardDelegate {
    func didSelect(char: Character)
}
