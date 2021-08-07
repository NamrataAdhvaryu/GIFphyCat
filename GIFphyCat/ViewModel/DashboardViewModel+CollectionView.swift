//
//  DashboardViewModel+CollectionView.swift
//  GIFphyCat
//
//  Created by Namrata Akash on 02/08/21.
//

import Foundation
import GiphyKit

extension DashboardViewModel
{
    // How many sections?
    var numberOfSections: Int {
        return 1
    }
    
    
    func numberOfItems(in section: Int) ->Int
    {
        var count = 0
        
        if let gifs = self.gifs
        {
            count = gifs.count
        }
        
        return count
    }
    
    // MARK: - Accessing Hashtags for a GIF
    
    func hashtags(for indexPath: IndexPath) -> String?
    {
        guard let gifs = self.gifs else
        {
            
            return nil
        }
        
        guard indexPath.row < gifs.count else
        {
            return nil
        }
        
        let gif = gifs[indexPath.row]
        
        var hashtags:String? = nil
        
        if let featured = gif.featuredTags
        {
            hashtags = featured.joined(separator: " #")
        }
        else if let tags = gif.tags
        {
            hashtags = tags.joined(separator: " #")
        }
        
        return hashtags
    }
    
    // MARK: - Accessing GIF Data
    
    
    func gif(for indexPath: IndexPath, with completion:@escaping (Data?, IndexPath)->Void)
    {
        guard let gifs = self.gifs else
        {
            completion(nil, indexPath)
            return
        }
        
        guard indexPath.row < gifs.count else
        {
            completion(nil, indexPath)
            return
        }
        
        let gif = gifs[indexPath.row]
        
        let renditionDesignation = self.bestAvailableRenditionDesignation(for: gif)
        
        guard let rendition = gif.renditions[renditionDesignation] else
        {
            completion(nil, indexPath)
            return
        }
        
        guard let file = rendition.files[.gif] else {
            completion(nil, indexPath)
            return
        }
        
        self.apiClient.item(at: file.url) { (data: Data?) in
            completion(data, indexPath)
        }
        
    }
    
    func likeGif(for indexPath: IndexPath,likeGif:[GIF], with completion:@escaping (Data?, IndexPath)->Void){
        let gif = likeGif[indexPath.row]
        
        let renditionDesignation = self.bestAvailableRenditionDesignation(for: gif)
        
        guard let rendition = gif.renditions[renditionDesignation] else
        {
            completion(nil, indexPath)
            return
        }
        
        guard let file = rendition.files[.gif] else {
            completion(nil, indexPath)
            return
        }
        
        self.apiClient.item(at: file.url) { (data: Data?) in
            completion(data, indexPath)
        }
    }
    
    // MARK: - Choosing the Appropriate Rendition
    
    
    private func bestAvailableRenditionDesignation(for gif:GIF) -> RenditionDesignation
    {
        let designationToReturn: RenditionDesignation = .previewGIF
        
        
        
        return designationToReturn
    }
    
}

