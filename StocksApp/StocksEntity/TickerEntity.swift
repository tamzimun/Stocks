//
//  StocksEntity.swift
//  StocksApp
//
//  Created by Aida Moldaly on 26.07.2022.
//

import Foundation

struct LookupEntity: Decodable {
    let result: [Ticker]
}

struct Ticker: Decodable {
    let description: String
    let displaySymbol: String
    let symbol: String
}

