//
//  SearchDataDisplayManager.swift
//  StocksApp
//
//  Created by Olzhas Seiilkhanov on 25.07.2022.
//

import UIKit
import SkeletonView

final class SearchDataDisplayManager: NSObject {
    
    var stocksList: [Stock] = []
    var lastSearch: [String] = []
    
    var onTickerDidSelect: ((Stock) -> Void)?
    var onFavouriteDidTap: ((Stock) -> Void)?
    var stocksIsEmpty: (() -> Void)?
}

extension SearchDataDisplayManager: SkeletonTableViewDelegate, SkeletonTableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocksList.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UITableView.automaticNumberOfSkeletonRows
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "stockCell"
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        let cell = skeletonView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as? StockCell
        cell?.setUp(with: .skeletonable)
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell") as! StockCell
        cell.setUp(with: stocksList[indexPath.row])
        cell.selectionStyle = .none
        if indexPath.row % 2 == 0 {
            cell.cellView.backgroundColor = .systemGray5
        } else {
            cell.cellView.backgroundColor = .white
        }
        
        cell.onFavouriteDidTap = { [weak self] in
            guard let self = self else { return }
            self.onFavouriteDidTap?(self.stocksList[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onTickerDidSelect?(stocksList[indexPath.row])
    }
}

// MARK: - CollectionView Delegates
extension SearchDataDisplayManager: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lastSearch.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        return cell
    }
    
}
