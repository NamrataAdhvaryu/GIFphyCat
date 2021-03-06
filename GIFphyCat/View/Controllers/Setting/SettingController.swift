//
//  SettingController.swift
//  GIFphyCat
//
//  Created by Namrata Akash on 02/08/21.
//

import UIKit
import GiphyKit

class SettingsController: NSObject {
    
    // MARK: - External Things We Need to Present
    
    
    private weak var presentingViewController: UIViewController?
    
    // MARK: - Settings Detail Controllers
    
    private let ratingController: RatingController = RatingController()
    private let languageController: LanguageController = LanguageController()
    
    // MARK: - Initializing a Settings Controller
    
    init(with viewController: UIViewController)
    {
        self.presentingViewController = viewController
        
        super.init()
    }
    
    // MARK: - Showing Settings
    
    func present()
    {
        self.presentingViewController?.present(self.rootViewController, animated: true, completion: nil)
    }
    
    // MARK: - Settings Root View Controller
    
    var rootViewController: UIViewController
    {
        let title = NSLocalizedString("Settings", comment: "The title for the root setting screen.")
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        let languageItem = UIAlertAction(title: self.languageController.title, style: .default) { [weak self] (action: UIAlertAction) in
            
            guard let languageController = self?.languageController else
            {
                print("\(self!.self): We don't have a reference to the language settings view controller. Can't present without it, bailing.")
                return
            }
            
            self?.present(settingsViewController: languageController)
        }
        
        let ratingItem = UIAlertAction(title: self.ratingController.title, style: .default) { [weak self] (action: UIAlertAction) in
            
            guard let ratingController = self?.ratingController else
            {
                print("\(self!.self): We don't have a reference to the rating settings view controller. Can't present without it, bailing.")
                return
            }
            
            self?.present(settingsViewController: ratingController)
            
        }
        
        let cancelItem = UIAlertAction(title: NSLocalizedString("Cancel", comment: "A cancel button"), style: .cancel, handler: nil)
        
        alertController.addAction(languageItem)
        alertController.addAction(ratingItem)
        alertController.addAction(cancelItem)
        
        return alertController
    }
    
    // MARK: - Presenting Settings
    
    
    func present(settingsViewController: SettingsDetailController)
    {
        guard let presentingViewController = self.presentingViewController else
        {
            print("\(self.self): We don't have a reference to the presenting view controller. Can't present without it, bailing.")
            return
        }
        
        let alertController = settingsViewController.viewController
        presentingViewController.present(alertController, animated: true, completion: nil)
    }
}

