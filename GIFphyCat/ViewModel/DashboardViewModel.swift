//
//  DashboardViewModel.swift
//  GIFphyCat
//
//  Created by Namrata Akash on 02/08/21.
//

import Foundation
import GiphyKit

class DashboardViewModel: NSObject {
    
    // MARK: - The API Client
    
    
    internal let apiClient: GiphyAPIClient
    
    
    private let apiKey:String = APIKey // Replace APIKey with your API Key
    
    
    // MARK: - Accessing Data
    
    
    private(set) var gifs: [GIF]? = nil
    
    // MARK: - Searching
    var searchTerm: String? = nil {
        didSet {
            self.setNeedsRefresh()
        }
    }
    
    // variables use to store likes in one array
    var likedGifArray = [GIF]()
    var likedGifIDArray = [String]()
    
    // MARK: - Title
    
    public var title:String
    {
        
        var title = NSLocalizedString("Giphy Trending", comment: "A title for the demo app.")
        
        if let term = self.searchTerm, term.count > 0
        {
            title = NSLocalizedString("Giphy Results for \(term)", comment: "")
        }
        
        return title
    }
    
    // MARK: - Responding to Data Changes
    
    
    var refreshHandler:(()->Void)? = nil
    
    // MARK: - Initializing the ViewModel
    
    override init() {
        
        self.apiClient = GiphyAPIClient(with: self.apiKey)
        super.init()
        
        self.loadPreferences()
        let name = Notification.Name.PreferencesChanged
        NotificationCenter.default.addObserver(self, selector: #selector(handlePreferencesChanged(notification:)), name: name, object: nil)
    }
    
    
    // MARK: - Refreshing the View Model
    
    
    @objc func setNeedsRefresh()
    {
        if let term = searchTerm, term.count > 0
        {
            self.refreshSearchResults()
        }
        else
        {
            self.refreshTrending() // No search, show trending
        }
    }
    
    // MARK: - Displaying Results of a Search
    
    
    func refreshSearchResults()
    {
        guard let searchTerm = self.searchTerm else
        {
            return
        }
        
        self.apiClient.search(for: searchTerm) { [weak self] (results:[GIF]?, url: URL?, error: NSError?) in
            guard let strongSelf = self else
            {
                // The view model is gone for some reason.
                return
            }
            
            guard let url = url else
            {
                return
            }
            
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else
            {
                return
            }
            
            guard let currentSearchTerm = strongSelf.searchTerm else
            {
                return
            }
            
            
            let queryItemAsItWouldBeBasedOnCurrentUI = URLQueryItem(name: "q", value: currentSearchTerm)
            let searchTermIsStillRelevant = components.queryItems?.contains(queryItemAsItWouldBeBasedOnCurrentUI) ?? false
            
            if searchTermIsStillRelevant
            {
                strongSelf.gifs = results
                
                if let callback = strongSelf.refreshHandler
                {
                    callback()
                }
            }
        }
    }
    
    // MARK: - Displaying Trending GIFs
    
    func refreshTrending()
    {
        self.apiClient.trending { [weak self] (results:[GIF]?, url: URL?, error: NSError?) in
            
            guard let strongSelf = self else
            {
                // The view model is gone for some reason.
                return
            }
            
            strongSelf.gifs = results
            
            if let callback = strongSelf.refreshHandler
            {
                callback()
            }
        }
    }
    
    
    
}

