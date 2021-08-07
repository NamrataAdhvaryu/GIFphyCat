

import Foundation
import CoreGraphics


public class Rendition: NSObject {
    

    public let designation: RenditionDesignation
    
    // MARK: - The Dimensions of the Rendition
    
   
    public let dimensions: CGSize
    
    public let files: [RenditionFileType:RenditionFile]
    
    // MARK: - Initializing a Rendition
    

    public init?(with designation: RenditionDesignation, and json: [String: Any])
    {
        self.designation = designation
        
        guard let widthString = json["width"] as? String,
            let heightString = json["height"] as? String,
            let width = numberFormatter.number(from: widthString),
            let height = numberFormatter.number(from: heightString)
            else
        {
            return nil
        }
        
        self.dimensions = CGSize(width: width.intValue, height: height.intValue)
        
        var files: [RenditionFileType:RenditionFile] = [:]
        let types: [RenditionFileType] = [.gif, .mp4, .webp]
        
        for fileType in types
        {
            if let renditionFile = RenditionFile(of: fileType, with: json)
            {
                files[fileType] = renditionFile
            }
        }
        
        self.files = files
        
        super.init()
    }
}
