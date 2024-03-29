//
//  ChartsEntity.swift
//  StocksApp
//
//  Created by tamzimun on 26.07.2022.
//

import Foundation

struct FilterEntity {
    var filter: String
}

struct MarketDataResponse: Codable {
    let c, h, l, o: [Double]
    let s: String
    let t: [TimeInterval]

    enum Codingkeys: String, CodingKey {
        case open = "o"
        case close = "c"
        case high = "h"
        case low = "l"
        case status = "s"
        case timestams = "t"

    }

    var candleSticks: [CandleStick] {
        var result = [CandleStick]()
        for index in 0..<o.count {
            result.append(.init(high: h[index],
                    low: l[index],
                    close: c[index],
                    open: o[index],
                    date: Date(timeIntervalSince1970: t[index])
            ))
        }
        let sortedData = result.sorted(by: { $0.date > $1.date })
        return sortedData
    }
}

struct CandleStick {
    let high: Double
    let low: Double
    let close: Double
    let open: Double
    let date: Date
}

struct Candle: Decodable {
    let c: [Double]?
    let h: [Double]?
    let l: [Double]?
    let o: [Double]?
    let s: String?
    let t: [Double]?
    let v: [Double]?
    let error: String?
}
