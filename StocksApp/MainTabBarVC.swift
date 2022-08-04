//
//  MainTabBarVC.swift
//  StocksApp
//
//  Created by Olzhas Seiilkhanov on 25.07.2022.
//

import UIKit

class MainTabBarVC: UITabBarController {
    
    private let titles: [String] = ["Search", "Favourites", "News"]
    private let images: [UIImage] = [
        UIImage(systemName: "magnifyingglass")!,
        UIImage(systemName: "star.fill")!,
        UIImage(systemName: "newspaper")!
    ]

    private var searchVC = UINavigationController(rootViewController: SearchModuleAssembly().assemble())
    private var favouritesVC = FavouritesModuleAssembly().assemble()
    private var newsVC = NewsModuleAssembly().assemle()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        makeTabBarViews()
    }
    
    private func makeTabBarViews() {
        
        tabBar.tintColor = .systemBlue
        tabBar.backgroundColor = .white
        setViewControllers([searchVC, favouritesVC, newsVC], animated: false)
        
        guard let items = self.tabBar.items else { return }
        
        for i in 0..<items.count {
            items[i].title = titles[i]
            items[i].image = images[i]
        }
    }
    
}
