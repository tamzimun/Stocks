//
//  NetworkResponse.swift
//  StocksApp
//
//  Created by Aida Moldaly on 26.07.2022.
//

import Foundation

enum APINetworkError: Error {
    case failedGET
    case invalidURL
    case dataNotFound
    case httpRequestFailed
    case decodingError
    case dontHaveRights(String)
}

extension APINetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failedGET:
            return "Error: error calling GET"
        case .invalidURL:
            return "Error: Incorrect URL"
        case .dataNotFound:
            return "Error: Did not receive data"
        case .httpRequestFailed:
            return "Error: HTTP request failed"
        case .decodingError:
            return "Error: Failed to decode"
        case .dontHaveRights:
            return "Error: You don't have rights"
        }
    }
}


