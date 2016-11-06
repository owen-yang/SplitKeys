//
//  Settings.swift
//  SplitKeys
//
//  Created by Owen Yang on 10/13/16.
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import Foundation

class Settings {

    static private let userDefaults = UserDefaults(suiteName: "group.SplitKeys")!

    static var isAudioEnabled: Bool {
        get {
            return userDefaults.bool(forKey: "isAudioEnabled")
        }
        set(enable) {
            userDefaults.set(enable, forKey: "isAudioEnabled")
        }
    }

    static var audioVolume: Double {
        get {
            return userDefaults.double(forKey: "audioVolume")
        }
        set(audioVolume) {
            userDefaults.set(audioVolume, forKey: "audioVolume")
        }
    }

    static var audioSpeed: Double {
        get {
            return userDefaults.double(forKey: "audioSpeed")
        }
        set(audioSpeed) {
            userDefaults.set(audioSpeed, forKey: "audioSpeed")
        }
    }

    static var heightProportion: Double {
        get {
            return userDefaults.double(forKey: "heightProportion")
        }
        set(heightProportion) {
            userDefaults.set(heightProportion, forKey: "heightProportion")
        }
    }

    static var holdTime: Double {
        get {
            return userDefaults.double(forKey: "holdTime")
        }
        set (holdTime) {
            userDefaults.set(holdTime, forKey: "holdTime")
        }
    }

    static var waitTime: Double {
        get {
            return userDefaults.double(forKey: "waitTime")
        }
        set (waitTime) {
            userDefaults.set(waitTime, forKey: "waitTime")
        }
    }
}
