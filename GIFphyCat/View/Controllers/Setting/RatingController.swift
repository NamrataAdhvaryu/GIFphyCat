//
//  RatingController.swift
//  GIFphyCat
//
//  Created by Namrata Akash on 02/08/21.
//

import UIKit
import GiphyKit

class RatingController: NSObject, SettingsDetailController {
    
    
    
    private(set) var title:String? = NSLocalizedString("Content Rating", comment: "The title for the rating picker.")
    
    // MARK: - Listing Ratings
    
    
    private let ratings: [Rating] = [.g, .pg, .pg13, .r]
    
    // MARK: - Generating an Alert Controller
    
    
    var viewController: UIViewController
    {
        // We use this to display the UI a little better.
        let currentSetting = Preferences.shared.preference(for: .rating)
        
        var message = NSLocalizedString("Choose the content rating you wish to see.", comment: "A message for the content picker.")
        
        if let current = currentSetting, let rating = Rating(rawValue: current)
        {
            message.append(" \(NSLocalizedString("You're looking currently looking at content rated", comment: "")) \(rating.displayName).")
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        
        
        for rating in self.ratings
        {
            let title = rating.displayName
            
            var style: UIAlertAction.Style = .default
            
            if let current = currentSetting, rating == Rating(rawValue: current)
            {
                style = .cancel
            }
            
            let actionItem = UIAlertAction(title: title, style: style, handler: { (action:UIAlertAction) in
                Preferences.shared.set(preference: rating.rawValue, for: .rating)
            })
            
            alertController.addAction(actionItem)
        }
        
        return alertController
    }
}

