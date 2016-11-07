//
//  Settings.swift
//  SplitKeys
//
//  Created by Owen Yang on 10/13/16.
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import Foundation
import AVFoundation

enum ContrastBarSize: Double {
    case small = 20.0
    case medium = 35.0
    case large = 50.0
}

class Settings {

    static private let userDefaults = UserDefaults(suiteName: "group.SplitKeys")!

    private struct Defaults {
        static let isAudioEnabled = true
        static let audioVolume = 1.0
        static let audioSpeed = AVSpeechUtteranceDefaultSpeechRate
        static let heightProportion = 0.2
        static let holdTime = 0.5
        static let waitTime = 1.0
        static let isAutocorrectEnabled = true
        static let contrastBarSize = ContrastBarSize.medium.rawValue
    }

    static var isAudioEnabled: Bool {
        get {
            return userDefaults.object(forKey: "isAudioEnabled") as! Bool? ?? Defaults.isAudioEnabled
        }
        set(enable) {
            userDefaults.set(enable, forKey: "isAudioEnabled")
        }
    }

    static var audioVolume: Double {
        get {
            return userDefaults.object(forKey: "audioVolume") as! Double? ?? Defaults.audioVolume
        }
        set(audioVolume) {
            userDefaults.set(audioVolume, forKey: "audioVolume")
        }
    }

    static var audioSpeed: Double {
        get {
            return userDefaults.object(forKey: "audioSpeed") as! Double? ?? Double(Defaults.audioSpeed)
        }
        set(audioSpeed) {
            userDefaults.set(audioSpeed, forKey: "audioSpeed")
        }
    }

    static var heightProportion: Double {
        get {
            return userDefaults.object(forKey: "heightProportion") as! Double? ?? Defaults.heightProportion
        }
        set(heightProportion) {
            userDefaults.set(heightProportion, forKey: "heightProportion")
        }
    }

    static var holdTime: Double {
        get {
            return userDefaults.object(forKey: "holdTime") as! Double? ?? Defaults.holdTime
        }
        set (holdTime) {
            userDefaults.set(holdTime, forKey: "holdTime")
        }
    }

    static var waitTime: Double {
        get {
            return userDefaults.object(forKey: "waitTime") as! Double? ?? Defaults.waitTime
        }
        set (waitTime) {
            userDefaults.set(waitTime, forKey: "waitTime")
        }
    }
    
    static var contrastBarSize: Double {
        get {
            return userDefaults.object(forKey: "contrastBarSize") as! Double? ?? Defaults.contrastBarSize
        }
        set (contrastBarSize) {
            userDefaults.set(contrastBarSize, forKey: "contrastBarSize")
        }
    }
    
    static var isAutocorrectEnabled: Bool {
        get {
            return userDefaults.object(forKey: "isAutocorrectEnabled") as! Bool? ?? Defaults.isAutocorrectEnabled
        }
        set(enable) {
            userDefaults.set(enable, forKey: "isAutocorrectEnabled")
        }
    }
}
