

import Foundation

public enum Rating: String {
    case g = "G"
    case pg = "PG"
    case pg13 = "PG-13"
    case r = "R"
    case unrated = "?"
    
    public var displayName: String {
        switch self {
        case .g:
            return "G"
        case .pg13:
            return "PG-13"
        case .pg:
            return "PG"
        case .r:
            return "R"
        case .unrated:
            return "Unrated"
        }
    }
}
