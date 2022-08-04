//
//  StockRequest.swift
//  StocksApp
//
//  Created by Olzhas Seiilkhanov on 03.08.2022.
//

import Foundation

enum StockRequest: RequestProtocol {
    case getStocksList(exchage: String, mic: String)
    case getLookupList(q: String)
    case getProfile(symbol: String)
    case getQuote(symbol: String)
    
    var path: String {
        switch self {
        case .getStocksList:
            return "/api/v1/stock/symbol"
        case .getLookupList:
            return "/api/v1/search"
        case .getProfile:
            return "/api/v1/stock/profile2"
        case .getQuote:
            return "/api/v1/quote"
        }
    }
    
    var urlParams: [String: String?] {
        switch self {
        case let .getStocksList(exchage, mic):
            var params: [String: String] = [:]
            params["exchange"] = exchage
            params["mic"] = mic
            return params
        case let .getLookupList(q):
            var params: [String: String] = [:]
            params["q"] = q
            return params
        case let .getProfile(symbol):
            var params: [String: String] = [:]
            params["symbol"] = symbol
            return params
        case let .getQuote(symbol):
            var params: [String: String] = [:]
            params["symbol"] = symbol
            return params
        }
    }
    
    var requestType: RequestType {
        .GET
    }
}
