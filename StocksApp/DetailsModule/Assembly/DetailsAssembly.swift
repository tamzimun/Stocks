//
//  DetailsAssembly.swift
//  StocksApp
//
//  Created by Aida Moldaly on 26.07.2022.
//

import UIKit

protocol DetailsModuleInput {
    func configure(with stock: Stock)
}

typealias DetailsModuleConfiguration = (DetailsModuleInput) -> Void

final class DetailsAssembly {
    
    func assemble(_ configuration: DetailsModuleConfiguration? = nil) -> DetailsViewController {
        
        let dataDisplayManager = DetailsDataDisplayManager()
        let viewController = DetailsViewController()
        let presenter = DetailsPresenter()
        let network: Networkable = NetworkManager.shared
        let interactor = DetailsInteractor(network: network)
        let router = DetailsRouter()
        
        configuration?(presenter)
        
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
