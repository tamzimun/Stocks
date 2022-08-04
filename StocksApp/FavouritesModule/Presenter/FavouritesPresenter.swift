//
//  FavouritesPresenter.swift
//  StocksApp
//
//  Created by Olzhas Seiilkhanov on 25.07.2022.
//

import Foundation

final class FavouritesPresenter: FavouritesViewOutput {
    
    weak var view: FavouritesViewInput?
    var interactor: FavouritesInteractorInput?
    var router: FavouritesRouterInput?
    
    func didLoadView() {
        interactor?.fetchFavouriteStocks()
    }
    
}

extension FavouritesPresenter: FavouritesInteractorOutput {
    
    func didFetchFavouriteStocks(_ favouriteStocks: [Stock]) {
        view?.handleObtainedFavouriteStocks(favouriteStocks)
    }
    
}
