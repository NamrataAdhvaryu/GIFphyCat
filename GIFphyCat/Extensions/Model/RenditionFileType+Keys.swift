

import Foundation

// MARK: - Adding Keys to Access Rendition Files

extension RenditionFileType
{
    var sizeKey: String
    {
        switch self
        {
        case .gif:
            return "size"
        case .mp4:
            return "mp4_size"
        case .webp:
            return "webp_size"
        }
    }
    
    var urlKey: String
    {
        switch self {
        case .gif:
            return "url"
        case .mp4:
            return "mp4"
        case .webp:
            return "webp"
        }
    }
}
