

import Foundation


public class RenditionFile: NSObject {
    
    
    public let fileType: RenditionFileType
    
 
    public let url: URL
    

    public let sizeInBytes: NSInteger
    
   
    public let height: Int?
    
    
    
    public let width: Int?
    
    // MARK: - Initializing a Rendition
    
    public init?(of type: RenditionFileType, with json: [String: Any])
    {
        guard let sizeString = json[type.sizeKey] as? String,
            let sizeNumber = numberFormatter.number(from: sizeString),
            let address = json[type.urlKey] as? String,
            let url = URL(string: address)
            else
        {
            return nil
        }
        
        self.fileType = type
        self.sizeInBytes = sizeNumber.intValue
        self.url = url
        
        if let height = json["height"] as? String
        {
            self.height = numberFormatter.number(from: height)?.intValue
        }
        else
        {
            self.height = nil
        }
        
        if let width = json["width"] as? String
        {
            self.width = numberFormatter.number(from: width)?.intValue
        }
        else
        {
            self.width = nil
        }
        
        super.init()
    }
    
}
