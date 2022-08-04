//
//  DetailsPresenter.swift
//  StocksApp
//
//  Created by Aida Moldaly on 26.07.2022.
//

import Foundation

final class DetailsPresenter: DetailsViewOutput, DetailsInteractorOutput, DetailsModuleInput {
    
    weak var view: DetailsViewInput!
    var interactor: DetailsInteractorInput!
    var router: DetailsRouterInput!
    
    private var stock: Stock!
    
    private var filter: [FilterEntity] = [
        FilterEntity.init(filter: "15"),
        FilterEntity.init(filter: "30"),
        FilterEntity.init(filter: "60"),
        FilterEntity.init(filter: "D"),
        FilterEntity.init(filter: "W"),
        FilterEntity.init(filter: "M")
    ]

    func configure(with stock: Stock) {
        self.stock = stock
    }
    
    func didLoadView() {
//        interactor.obtainNews()
        view.handleObtainedFilter(filter)
        view.handleObtainedStock(stock)
//        view.hundleObtainedNews(news)
    }
//
    func didSelectFilterCell(with filter: String) {
//        interactor.ontainFilteredNews(with: news, category: category)
    }

    func didSelectCompanyUrl(with url: String) {
        router.openNewsWebsite(with: url)
    }
//
//    func didLoadNews(_ news: [News]) {
//        self.news = news
//        view.hundleObtainedNews(news)
//    }
//
//    func didFilteredNews(_ news: [News]) {
//        view.hundleObtainedNews(news)
//    }

}
