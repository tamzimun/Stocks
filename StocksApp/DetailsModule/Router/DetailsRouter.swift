//
//  DetailsRouter.swift
//  StocksApp
//
//  Created by Aida Moldaly on 26.07.2022.
//

import Foundation

import UIKit

protocol DetailsRouterInput {
    func openNewsWebsite(with url: String)
}

final class DetailsRouter: DetailsRouterInput {
    
    weak var viewController: UIViewController?
    
    func openNewsWebsite(with url: String) {

        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
}
