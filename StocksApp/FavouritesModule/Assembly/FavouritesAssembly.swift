//
//  FavouritesAssembly.swift
//  StocksApp
//
//  Created by Olzhas Seiilkhanov on 25.07.2022.
//

import UIKit

typealias FavouritesModuleConfiguration = () -> Void

final class FavouritesModuleAssembly {
    func assemble() -> UIViewController {
        let dataDisplayManager = FavouritesDataDisplayManager()
        let viewController = FavouritesViewController()
        let presenter = FavouritesPresenter()
        let network: Networkable = NetworkManager.shared
        let interactor = FavouritesInteractor(networkManager: network)
        let router = FavouritesRouter()
        
        viewController.dataDisplayManager = dataDisplayManager
        viewController.output = presenter
        
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.output = presenter
        
        router.viewController = viewController
        
        return viewController
    }
}
