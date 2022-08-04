//
//  FavouritesDataDisplayManager.swift
//  StocksApp
//
//  Created by Olzhas Seiilkhanov on 25.07.2022.
//

import UIKit

final class FavouritesDataDisplayManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var favouriteStocks: [Stock] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favouriteStocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as! StockCell
        cell.setUp(with: favouriteStocks[indexPath.row])
        return cell
    }
    
}
