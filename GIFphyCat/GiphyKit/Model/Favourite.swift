//
//  Favourite.swift
//  GIFphyCat
//
//  Created by Namrata Akash on 04/08/21.
//


import UIKit

enum Favorites: String {
    case favoriteGIF = "favoriteGIF"
    
}



protocol Likeable {
    var favoriteType: Favorites { get }
    
    func likePressed(id: String) -> Bool
    func checkIfFavorite(id: String) -> Bool
}

