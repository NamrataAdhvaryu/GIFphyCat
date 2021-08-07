//
//  NotificationName+Preferences.swift
//  GIFphyCat
//
//  Created by Namrata Akash on 02/08/21.
//

import Foundation


// MARK: - Extending NSNotificationCenter for Preferences
extension Notification.Name
{
    
    // Dispatched when the preferences changed.
    static let PreferencesChanged = Notification.Name("com.namrata.giphy.preferences-changed")
}
