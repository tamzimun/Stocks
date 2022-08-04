//
//  SearchPresenter.swift
//  StocksApp
//
//  Created by Olzhas Seiilkhanov on 25.07.2022.
//

import Foundation

final class SearchPresenter: SearchViewOutput {
    
    weak var view: SearchViewInput!
    var interactor: SearchInteractorInput!
    var router: SearchRouterInput!
    
    func didLoadView() {
        view.showLoader()
        interactor.obtainStocksList()
    }
    
    func didTapSearchBar() {
        view.handleSearchBarTap()
    }
    
    func didStartEditingSearchBar(_ text: String) {
        interactor.obtainLookupList(text)
    }
    
    func didTapCancelSearchBar() {
        view.handleSearchBarCancel()
    }
    
    func didResignSearchBar() {
        interactor.obtainStocksList()
    }
    
    func didSelectTickerCell(at stock: Stock) {
        router.openDetailsModule(with: stock)
    }
    
    func didTapFavourite(at stock: Stock) {
        // Check if stock is favourite
        print(stock.ticker?.displaySymbol ?? "no symbol")
        print(stock.profile?.name ?? "no name")
    }
}

extension SearchPresenter: SearchInteractorOutput {
    
    func didLoadStocksList(_ stocksList: [Stock]) {
        view.handleObtainedStocksList(stocksList)
        view.hideLoader()
    }
    
}
