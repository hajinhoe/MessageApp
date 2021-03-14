//
//  UserSettings.swift
//  MessageApp
//
//  Created by jinho on 2021/03/14.
//

import Foundation
import Combine

class UserSettings {
    static let shared = UserSettings()

    var isInitialized: Bool
    var name: String
    
    init() {
        self.isInitialized = UserDefaults.standard.bool(forKey: "isInitialized")
        self.name = UserDefaults.standard.string(forKey: "name") ?? ""
    }
    
    func initialize(name: String) {
        self.name = name
        self.isInitialized = true
        
        UserDefaults.standard.setValue(name, forKey: "name")
        UserDefaults.standard.setValue(true, forKey: "isInitialized")
    }
}
