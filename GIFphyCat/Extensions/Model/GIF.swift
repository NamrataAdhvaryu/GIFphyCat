

import Foundation


public class GIF: NSObject {
    
    
    public let type: String
    public let id: String
    
    public let identifier: String
    
    // MARK: - Renditions of the GIF
    
    public var renditions: [RenditionDesignation: Rendition]
    
    // MARK: - Accessing the Image on Giphy
    
 
    public let slug: String
    
    
    public var url: URL? {
        let address = "https://giphy.com/gifs/\(self.slug)"
        return URL(string: address)
    }
    
    // MARK: - Sorting/Filtering the GIF
    
  
    public var rating: Rating
    
    
    public var tags: [String]?
    
    public var featuredTags: [String]?
    
    // MARK: - Sharing the GIF
    
   
    public var bitlyURL: URL?
    
    // MARK: - Embedding the GIF
    
   
    public var embedURL: URL?
    
    // MARK: - Attributing a GIF
    
    
    public var source: URL?
   
    public var sourceTLD: URL?
    
  
    public var sourcePost: URL?
    
    
    public var username: String
    
    // MARK: - Determining the Age of the GIF
    
  
    public var createTimestamp: Date?
    

    public var updateTimestamp: Date?
    
    public var trendingTimestamp: Date?
    
   
    public var importTimestamp: Date?
    
    // MARK: - Unused Properties
    
    public var contentURL: String? = nil
    
    // MARK: - Initializing a Result
    
    public init?(with json: [String: Any])
    {
        dateFormatter.setLocalizedDateFormatFromTemplate("YYYY-MM-dd HH:mm:ss")
        
        guard let type = json["type"] as? String else
        {
            return nil
        }
        
        guard let id = json["id"] as? String else
        {
            return nil
        }
        
        guard let slug = json["slug"] as? String else
        {
            return nil
        }
        
        guard let rating = json["rating"] as? String else
        {
            return nil
        }
        
        guard let bitly = json["bitly_url"] as? String else
        {
            return nil
        }
        
        guard let embed = json["embed_url"] as? String else
        {
            return nil
        }
        
        guard let sourceTLDAddress = json["source_tld"] as? String else
        {
            return nil
        }
        
        guard let sourcePage = json["source_post_url"] as? String else
        {
            return nil
        }
        
        guard let source = json["source"] as? String else
        {
            return nil
        }
        
        guard let username = json["username"] as? String else
        {
            return nil
        }
        
        self.type = type
        self.identifier = id
        self.slug = slug
        self.id = id
        // Attribution
        self.bitlyURL = URL(string: bitly)
        self.embedURL = URL(string: embed)
        self.source = URL(string: source)
        self.sourceTLD = URL(string: sourceTLDAddress)
        self.sourcePost = URL(string: sourcePage)
        
        // Search / Filter
        self.rating = Rating(rawValue:rating) ?? .unrated
        self.tags = json["tags"] as? [String]
        self.featuredTags = json["featured_tags"] as? [String]
        
        // Attribution
        self.username = username
        
        // Timestamps
        if let updateTimestamp = json["update_datetime"] as? String
        {
            self.updateTimestamp = dateFormatter.date(from: updateTimestamp)
        }
        
        if let createTimestamp = json["create_datetime"] as? String
        {
            self.createTimestamp = dateFormatter.date(from: createTimestamp)
        }
        
        if let trendingTimestamp = json["trending_datetime"] as? String
        {
            self.trendingTimestamp = dateFormatter.date(from: trendingTimestamp)
        }
        
        if let importTimestamp = json["import_datetime"] as? String
        {
            self.importTimestamp = dateFormatter.date(from: importTimestamp)
        }
        
        
        
        // Renditions
        var transformedRenditions: [RenditionDesignation : Rendition] = [:]
        
        if let renditions = json["images"] as? [String: [String:String]]
        {
            for (key, json) in renditions
            {
                guard let designation = RenditionDesignation(rawValue: key) else
                {
                    continue
                }
                
                guard let rendition = Rendition(with: designation, and: json) else
                {
                    continue
                }
                
                transformedRenditions[designation] = rendition
            }
        }
        self.renditions = transformedRenditions
        
        
    }
}

struct likedGif {
    var id = ""
    var status = false
    
    init(id:String,status:Bool) {
        self.id = id
        self.status = status
    }
}
