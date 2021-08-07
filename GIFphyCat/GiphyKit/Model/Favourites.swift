

import Foundation
enum Favorites: String {
    case favoriteActors = "favoriteGIF"
    
}






protocol Likeable {
    var favoriteType: Favorites { get }
    
    func likePressed(id: String) -> Bool
    func checkIfFavorite(id: String) -> Bool
}

