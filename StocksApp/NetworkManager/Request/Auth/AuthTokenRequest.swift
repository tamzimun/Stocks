//
//  AuthTokenRequest.swift
//  StocksApp
//
//  Created by Aida Moldaly on 02.08.2022.
//

import Foundation

enum AuthTokenRequest: RequestProtocol {
    case auth

    var path: String {
        "/v2/oauth2/token"
    }

    var params: [String: Any] {
        [:]
    }

    var addAuthorizationToken: Bool {
        false
    }

    var requestType: RequestType {
        .POST
    }
}
