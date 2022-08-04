//
//  SearchBarManager.swift
//  StocksApp
//
//  Created by Olzhas Seiilkhanov on 27.07.2022.
//

import UIKit

final class SearchBarManager: NSObject, UISearchBarDelegate {
    
    var onSearchBarTapped: (() -> Void)?
    var onSearchBarTextEditing: ((String) -> Void)?
    var onSearchBarCancelTapped: (() -> Void)?
    
    var lastScheduledSearch: Timer?
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        lastScheduledSearch?.invalidate()
        lastScheduledSearch = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(startSearching(timer:)), userInfo: searchText, repeats: false)
    }
    
    @objc func startSearching(timer: Timer) {
        let searchText = timer.userInfo as! String
        onSearchBarTextEditing?(searchText)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        onSearchBarTapped?()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        onSearchBarCancelTapped?()
    }
}
