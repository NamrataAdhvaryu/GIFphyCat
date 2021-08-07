//
//  GIFListViewModel.swift
//  GIFphyCat
//
//  Created by Namrata Akash on 05/08/21.
//

import Foundation

struct GIFListViewModel {
    
    
    

    enum ListType {
        
        case favoriteGIF
        case favoritesAdded // for letting the VC's know that new favorites have been added
    }
    
    // MARK:- variable for the viewModel
    let defaultsManager: UserDefaultsManager
   
    let fileHandler: FileHandler
    var favoriteGifs: BoxBind<[GIF]?> = BoxBind(nil)
    /// Limiting the actors count to 5, since the api doesn't support multiple ids, calling APIs without the limit, easily exahauts the 500 API call / month free limit of the site.
    /// I do wish that it was more though, sigh.
    let movieId: String
    var offset: Int = 0
    var limit: Int = 5
    var noData: BoxBind<(ListType?)> = BoxBind(nil)
    init(movieId: String = "", handler: FileHandler, defaultsManager: UserDefaultsManager) {
        self.defaultsManager = defaultsManager
        self.fileHandler = handler
        self.movieId = movieId
        
        
    }
    
    func getFavoriteActors() {
        let favorties = defaultsManager.getFavorites(type: favoriteType)
        if (favorties.isEmpty) {
            self.noData.value = .favoriteGIF
        } else {
            self.noData.value = .favoritesAdded
            DispatchQueue.global(qos: .default).async {
                /// I don't like this at all, I wish they had given a way to pass mutiple actor ids at once -_-
                /// I had a hard time deciding whether I should use this API at all.
                if let favoritesArray = self.favoriteGifs.value {
                    if (favoritesArray.count == favorties.count) {
                        return
                    }
                }
                for cast in favorties {
                   
//                    if var GIFList = self.favoriteGifs.value {
//                        GIFList.append((GIF(a)
//                        self.favoriteGifs.value = GIFList
//                        } else {
//                            self.favoriteGifs.value = [GIF(actorFilms: GIFList)]
//                        }
//                    }
                }
            }
        }
    
    
    func actorRemoved(for model: GIF) {
        self.defaultsManager.removeFromFavorites(id: model.id, favorites: defaultsManager.getFavorites(type: favoriteType), type: favoriteType)
        guard var viewModels = self.favoriteGifs.value else { return }
        viewModels = viewModels.filter( {
            $0.id != model.id
        })
        if (viewModels.count == 0) {
            self.noData.value = .favoriteGIF
        }
        self.favoriteGifs.value = viewModels
    }
    
    
}

}

extension GIFListViewModel: Likeable {
    var favoriteType: Favorites  {
        .favoriteActors
    }
    
    func likePressed(id: String) -> Bool {
        let buttonStatus = defaultsManager.toggleFavorites(id: id, type: favoriteType)
        self.getFavoriteActors()
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


