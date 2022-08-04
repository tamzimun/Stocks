//
//  SearchRouter.swift
//  StocksApp
//
//  Created by Olzhas Seiilkhanov on 25.07.2022.
//

import UIKit

protocol SearchRouterInput {
    func openDetailsModule(with stock: Stock)
}

final class SearchRouter: SearchRouterInput {
    weak var viewController: UIViewController?
    
    func openDetailsModule(with stock: Stock) {
        let viewController = DetailsAssembly().assemble() { (input) in
            input.configure(with: stock)
        }
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
}
