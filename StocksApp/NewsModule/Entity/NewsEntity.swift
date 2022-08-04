//
//  NewsEntity.swift
//  StocksApp
//
//  Created by Aida Moldaly on 26.07.2022.
//

import Foundation

protocol SkeletonableViewModel {
    associatedtype ViewModel = Self
    static var skeletonable: ViewModel { get }
}

struct News: Codable {
    var category: String
    var headline: String
    var image: String
    var datetime: Date
    var source: String
    var summary: String
    var url: String
}

extension News: SkeletonableViewModel {
    static let skeletonable: Self = .init(
        category: "business",
        headline: "German chemicals firm warns of production chain collapse as Putin squeezes gas flows",
        image: "",
        datetime: .now,
        source: "CNBC",
        summary: "Company says it has adjusted its full year guidance for 2022.",
        url: ""
    )
}

// https://finnhub.io/api/v1/news?category=general&token=cbfqc1aad3ictm4bs4l0

