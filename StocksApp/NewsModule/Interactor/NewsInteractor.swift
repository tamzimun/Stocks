//
//  NewsInteractor.swift
//  StocksApp
//
//  Created by Olzhas Seiilkhanov on 25.07.2022.
//

import Foundation

protocol NewsInteractorInput {
    func obtainNews()
    func ontainFilteredNews(with news: [News], category: String)
}

protocol NewsInteractorOutput: AnyObject {
    // Отправляет загруженные с network данные в Presenter
    func didLoadNews(_ news: [News])
    func didFilteredNews(_ news: [News])
}

final class NewsInteractor: NewsInteractorInput {

    weak var output: NewsInteractorOutput!
    private var network: Networkable
    
    required init(network: Networkable) {
        self.network = network
    }
    
    func obtainNews() {
        let queryItem = [URLQueryItem(name: "category", value: "general")]
        network.fetchData(path: "/api/v1/news", queryItems: queryItem) { [weak self] (result : Result <[News], APINetworkError>) in
            switch result {
            case .success(let news):
                self?.output.didLoadNews(news)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func ontainFilteredNews(with news: [News], category: String) {
        var filteredNews: [News] = news
        if category != "All" {
            filteredNews = news.filter { $0.category.lowercased() == category.lowercased() }
        }
        output.didFilteredNews(filteredNews)
    }

//    func ontainFilteredNews(with news: [News], category: String) {
//        var filteredNews = news.filter { filteredNews in
//            if filteredNews.category.lowercased() == category.lowercased() {
//                return true
//            }
//            return false
//        }
//        if category == "All" {
//            filteredNews = news
//        }
//        output.didFilteredNews(filteredNews)
//    }
}
