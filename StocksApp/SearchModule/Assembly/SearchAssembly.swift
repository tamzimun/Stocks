//
//  SearchAssembly.swift
//  StocksApp
//
//  Created by Olzhas Seiilkhanov on 25.07.2022.
//

import UIKit

typealias SearchModuleConfiguration = () -> Void

final class SearchModuleAssembly {
    func assemble() -> UIViewController {
        let dataDisplayManager = SearchDataDisplayManager()
        let searchBarManager = SearchBarManager()
        let viewController = SearchViewController()
        let presenter = SearchPresenter()
        let network: Networkable = NetworkManager.shared
        let requestManager: RequestManagerProtocol = RequestManager()
        let interactor = SearchInteractor(networkManager: network, requestManager: requestManager)
        let router = SearchRouter()

        viewController.dataDisplayManager = dataDisplayManager
        viewController.searchBarManager = searchBarManager
        viewController.output = presenter
        
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.output = presenter
        
        router.viewController = viewController
        
        return viewController
    }
}
