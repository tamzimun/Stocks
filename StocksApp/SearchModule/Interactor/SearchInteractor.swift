//
//  SearchInteractor.swift
//  StocksApp
//
//  Created by Olzhas Seiilkhanov on 25.07.2022.
//

import Foundation

protocol SearchInteractorInput {
    func obtainStocksList()
    func obtainLookupList(_ symbol: String)
}

protocol SearchInteractorOutput: AnyObject {
    func didLoadStocksList(_ stocksList: [Stock])
}

final class SearchInteractor: SearchInteractorInput {
    
    weak var output: SearchInteractorOutput!
    private var networkManager: Networkable
    private var requestManager: RequestManagerProtocol
    
    required init(networkManager: Networkable, requestManager: RequestManagerProtocol) {
        self.networkManager = networkManager
        self.requestManager = requestManager
    }
    
    func obtainStocksList() {
        requestManager.perform(StockRequest.getStocksList(exchage: "US", mic: "XNYS")) { [weak self] (result : Result <[Ticker], APINetworkError>) in
            switch result {
            case .success(let tickersList):
                let shortList = Array(tickersList.prefix(10))
                self?.obtainProfile(with: shortList)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
        
    func obtainLookupList(_ symbol: String) {
        requestManager.perform(StockRequest.getLookupList(q: symbol)) { [weak self] (result : Result <LookupEntity, APINetworkError>) in
            switch result {
            case .success(let list):
                let lookupList = Array(list.result.prefix(10))
                self?.obtainProfile(with: lookupList)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func obtainProfile(with tickerList: [Ticker]) {
        var stockList: [Stock] = []
        let group = DispatchGroup.init()
        
        for index in 0..<tickerList.count {
            group.enter()
            let symbol = tickerList[index].displaySymbol
            requestManager.perform(StockRequest.getProfile(symbol: symbol)) { (result : Result <Profile, APINetworkError>) in
                switch result {
                case .success(let profile):

                    let stock = Stock(profile: profile, ticker: tickerList[index])
                    if stock.profile != nil {
                        stockList.append(stock)
                    }
                    group.leave()
                
                case .failure(let error):
                    print(error.localizedDescription)
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
            self.obtainQuote(with: stockList)
        }
    }
    
    func obtainQuote(with stockList: [Stock]) {
        var stockList: [Stock] = stockList
        
        var list: [Stock] = []
        let group = DispatchGroup.init()
        
        for index in 0..<stockList.count {
            group.enter()
            guard let symbol = stockList[index].profile?.ticker else {
                group.leave()
                return
            }
            requestManager.perform(StockRequest.getQuote(symbol: symbol)) { (result : Result <Quote, APINetworkError>) in
                switch result {
                case .success(var quote):
                    print(quote)
                    guard let dp = quote.dp else { return }
                    quote.dp = round(dp * 100)/100
                    stockList[index].quote = quote
                    list.append(stockList[index])
                    group.leave()
                case .failure(let error):
                    
                    print(error.localizedDescription)
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
            self.cleanStocksList(with: list)
        }
    }
    
    func cleanStocksList(with stockList: [Stock]) {
        var list = stockList
        for index in 0..<list.count {

        }
        self.output.didLoadStocksList(list)
    }
    
}
