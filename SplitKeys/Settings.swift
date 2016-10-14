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
}
