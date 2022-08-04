//
//  NewsAssembly.swift
//  StocksApp
//
//  Created by Olzhas Seiilkhanov on 25.07.2022.
//

import UIKit

final class NewsModuleAssembly {
    
    func assemle() -> UIViewController {
        
        let dataDisplayManager = NewsDataDisplayManager()
        let viewController = NewsViewController()
        let presenter = NewsPresenter()
        let network: Networkable = NetworkManager.shared
        let interactor = NewsInteractor(network: network)
        let router = NewsRouter()
        
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


        

