//
//  FavouritesRouter.swift
//  StocksApp
//
//  Created by Olzhas Seiilkhanov on 25.07.2022.
//

import UIKit

protocol FavouritesRouterInput {
    func openDetailsModule(with stock: Profile)
}

final class FavouritesRouter: FavouritesRouterInput {

    weak var viewController: UIViewController?
    
    func openDetailsModule(with stock: Profile) {
    
    }
    
}
