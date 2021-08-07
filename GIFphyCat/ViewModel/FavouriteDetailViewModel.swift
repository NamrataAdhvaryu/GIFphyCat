//
//  FavouriteDetailViewModel.swift
//  GIFphyCat
//
//  Created by Namrata Akash on 04/08/21.
//

import Foundation
struct FavouriteDetailViewModel {
    
    // MARK:- variable for the viewModel
    let fileHandler: FileHandler
   
    let defaultsManager: UserDefaultsManager

    let GIFId: String
    
    
    
    // MARK:- initializer for the viewModel
    init(GIFId: String, handler: FileHandler,  defaultsManager: UserDefaultsManager) {
        self.GIFId = GIFId
        self.fileHandler = handler
        self.defaultsManager = defaultsManager
        
        
    }
    
    // MARK:- functions for the viewModel
    
}

extension FavouriteDetailViewModel: Likeable {
    var favoriteType: Favorites  {
        .favoriteGIF
    }
    func likePressed(id: String) -> Bool {
        let buttonStatus = defaultsManager.toggleFavorites(id: id, type: favoriteType)
        if (buttonStatus) {
            return true
        } else {
            return false
        }
    }
    
    func checkIfFavorite(id: String) -> Bool {
        if (defaultsManager.checkIfFavorite(id: id, type: favoriteType)) {
            return true
        } else  {
            return false
        }
    }
}
