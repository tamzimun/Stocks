//
//  FavouritesInteractor.swift
//  StocksApp
//
//  Created by Olzhas Seiilkhanov on 25.07.2022.
//

import Foundation

protocol FavouritesInteractorOutput: AnyObject {
    func didFetchFavouriteStocks(_ favouriteStocks: [Stock])
}

protocol FavouritesInteractorInput {
    func fetchFavouriteStocks()
}

final class FavouritesInteractor: FavouritesInteractorInput {
    
    weak var output: FavouritesInteractorOutput?
    var networkManager: Networkable
    
    required init(networkManager: Networkable) {
        self.networkManager = networkManager
    }
    
    func fetchFavouriteStocks() {
        
    }
    
}
