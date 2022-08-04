//
//  DetailsInteractor.swift
//  StocksApp
//
//  Created by Aida Moldaly on 26.07.2022.
//

import Foundation

protocol DetailsInteractorInput {
//    func obtainNews()
//    func ontainFilteredNews(with news: [News], category: String)
}

protocol DetailsInteractorOutput: AnyObject {
    // Отправляет загруженные с network данные в Presenter
//    func didLoadNews(_ news: [News])
//    func didFilteredNews(_ news: [News])
}

final class DetailsInteractor: DetailsInteractorInput {

    weak var output: DetailsInteractorOutput!
    private var network: Networkable
    
    required init(network: Networkable) {
        self.network = network
    }
    
//    func obtainNews() {
//        let queryItem = URLQueryItem(name: "category", value: "general")
//        network.fetchData(path: "/api/v1/news", queryItem: queryItem) { [weak self] (result : Result <[News], APINetworkError>) in
//            switch result {
//            case .success(let news):
//                self?.output.didLoadNews(news)
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//    
//    func ontainFilteredNews(with news: [News], category: String) {
//        var filteredNews = news.filter { filteredNews in
//            if filteredNews.category == category {
//                return true
//            }
//            return false
//        }
//        if category == "All" {
//            filteredNews = news
//        }
//        output.didFilteredNews(filteredNews)
//    }
    
    
    // MARK: - Code for Candle data
//    func obtainCandle(with profileList: [Profile]) {
//
//        var stocksList: [Stock] = []
//
//        let currentTime = 1631627048
////        Int(NSDate().timeIntervalSince1970) - 60*60
//        let fromTime = 1631022248
//        let group = DispatchGroup.init()
//
//        for index in 0..<profileList.count {
//            let queryItem = [
//                URLQueryItem(name: "symbol", value: profileList[index].ticker),
//                URLQueryItem(name: "resolution", value: "1"),
//                URLQueryItem(name: "from", value: String(fromTime)),
//                URLQueryItem(name: "to", value: String(currentTime))
//            ]
//
//            group.enter()
//            networkManager.fetchData(path: "/api/v1/stock/candle", queryItems: queryItem) { (result : Result <Candle, APINetworkError>) in
//                switch result {
//                case .success(let candle):
////                    self?.output.didLoadCandle(candle)
//
//                    let stock = Stock(profile: profileList[index], candle: candle)
//                    stocksList.append(stock)
//                    group.leave()
//                case .failure(let error):
//                    print(error.localizedDescription)
//                    group.leave()
//                }
//            }
//        }
//        group.notify(queue: .main) {
//            self.output.didLoadStocksList(stocksList)
//        }
//    }
    
}
