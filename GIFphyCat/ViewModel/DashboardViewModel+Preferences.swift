//
//  DashboardViewModel+Preferences.swift
//  GIFphyCat
//
//  Created by Namrata Akash on 02/08/21.
//

import Foundation
import GiphyKit

extension DashboardViewModel
{
    // MARK: - Loading Preferences On Launch
    
    
    func loadPreferences()
    {
        if let language = Preferences.shared.preference(for: .language)
        {
            self.apiClient.language = LanguageCode(rawValue: language)!
        }
        
        if let rating = Preferences.shared.preference(for: .rating)
        {
            self.apiClient.rating = Rating(rawValue: rating)!
        }
    }
    
    // MARK: - Handling Preference Changes
    
    
    @objc func handlePreferencesChanged(notification: Notification)
    {
        if notification.name == .PreferencesChanged
        {
            if let userInfo = notification.userInfo
            {
                if let languageString = userInfo[PreferencesKey.language] as? String,
                   let language = LanguageCode(rawValue: languageString)
                {
                    self.apiClient.language = language
                }
                
                if let ratingString = userInfo[PreferencesKey.rating] as? String,
                   let rating = Rating(rawValue: ratingString)
                {
                    self.apiClient.rating = rating
                }
                
                self.setNeedsRefresh()
            }
        }
    }
}

