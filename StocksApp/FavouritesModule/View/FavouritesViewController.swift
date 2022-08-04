//
//  FavouritesViewController.swift
//  StocksApp
//
//  Created by Olzhas Seiilkhanov on 25.07.2022.
//

import UIKit

protocol FavouritesViewOutput {
    func didLoadView()
}

protocol FavouritesViewInput: AnyObject {
    func handleObtainedFavouriteStocks(_ favouriteStocks: [Stock])
}

class FavouritesViewController: UIViewController {
    
    var output: FavouritesViewOutput?
    var dataDisplayManager: FavouritesDataDisplayManager?
    var activityView: UIActivityIndicatorView?
    
    private let favouriteLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "Favourites"
        label.font = UIFont.boldSystemFont(ofSize: 30.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let favouriteStocksTable: UITableView = {
        let table = UITableView()
        table.register(StockCell.self, forCellReuseIdentifier: "stockCell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.didLoadView()
        
        makeConstraints()
        configureTableView()
    }
    
    private func configureTableView() {
        favouriteStocksTable.delegate = dataDisplayManager
        favouriteStocksTable.dataSource = dataDisplayManager
    }
    
    private func makeConstraints() {
        view.addSubview(favouriteLabel)
        favouriteLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        view.addSubview(favouriteStocksTable)
        favouriteStocksTable.snp.makeConstraints { make in
            make.top.equalTo(favouriteLabel.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

extension FavouritesViewController: FavouritesViewInput {
    
    func handleObtainedFavouriteStocks(_ favouriteStocks: [Stock]) {
        dataDisplayManager?.favouriteStocks = favouriteStocks
    }
    
}
