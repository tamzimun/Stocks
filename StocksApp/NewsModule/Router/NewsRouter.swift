//
//  NewsRouter.swift
//  StocksApp
//
//  Created by Olzhas Seiilkhanov on 25.07.2022.
//

import UIKit

protocol NewsRouterInput {
    func openNewsWebsite(with url: String)
}

final class NewsRouter: NewsRouterInput {
    
    weak var viewController: UIViewController?
    
    func openNewsWebsite(with url: String) {
        
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
}
