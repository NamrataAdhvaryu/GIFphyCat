//
//  Preferences.swift
//  GIFphyCat
//
//  Created by Namrata Akash on 02/08/21.
//

import Foundation

class Preferences: NSObject {
    
    // MARK: - Singleton Access
    static let shared = Preferences()
    private override init() {
        super.init()
        self.registerDefaults()
    }
    
    // MARK: - Default Preferences
    
    // Register default values for the preferences.
    func registerDefaults()
    {
        UserDefaults.standard.register(defaults: [
            PreferencesKey.rating.rawValue : "G",
            PreferencesKey.language.rawValue : "en"
        ])
    }
    
    // MARK: - Setting a Specific Preference
    func set(preference: String, for key: PreferencesKey)
    {
        UserDefaults.standard.set(preference, forKey: key.rawValue)
        NotificationCenter.default.post(name: Notification.Name.PreferencesChanged, object: nil, userInfo:[key:preference])
    }
    
    // MARK: - Accessing a Specific Preference
    func preference(for key: PreferencesKey) -> String?
    {
        guard let preference = UserDefaults.standard.string(forKey: key.rawValue) else
        {
            print("\(self.self): Could not read preference for key \(key.rawValue).")
            return nil
        }
        
        return preference
    }
}
