//
//  NewsPresenter.swift
//  StocksApp
//
//  Created by Olzhas Seiilkhanov on 25.07.2022.
//

import Foundation

enum Categories {
    case all
    case top
    case business
    case technology
}

extension Categories {
    public var category: String? {
        switch self {
        case .all:
            return "All"
        case .top:
            return "Top news"
        case .business:
            return "Business"
        case .technology:
            return "Technology"
        }
    }
}

final class NewsPresenter: NewsViewOutput, NewsInteractorOutput {
    
    weak var view: NewsViewInput!
    var interactor: NewsInteractorInput!
    var router: NewsRouterInput!
    
    // if there are defined number of categories, it's better to create an Enum
    private var categories: [NewsCategoriesEntity] = [
        NewsCategoriesEntity.init(category: "All"),
        NewsCategoriesEntity.init(category: "Top news"),
        NewsCategoriesEntity.init(category: "Business"),
        NewsCategoriesEntity.init(category: "Technology")
    ]
    
    private var news: [News] = []
    
    func didLoadView() {
        view.showLoader()
        interactor.obtainNews()
        view.handleObtainedNewsCategories(categories)
        view.handleObtainedNews(news)
    }
    
    func didSelectCategoryCell(with category: String) {
        interactor.ontainFilteredNews(with: news, category: category)
    }
    
    func didSelectNewsUrlCell(with url: String) {
        router.openNewsWebsite(with: url)
    }
    
    func didLoadNews(_ news: [News]) {
        self.news = news
        view.handleObtainedNews(news)
        view.hideLoader()
    }
    
    func didFilteredNews(_ news: [News]) {
        view.handleObtainedNews(news)
    }

}
