//
//  DashboardViewController+Search.swift
//  GIFphyCat
//
//  Created by Namrata Akash on 02/08/21.
//

import UIKit


extension DashboardViewController : UISearchBarDelegate
{
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.viewModel.searchTerm = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.searchTerm = nil
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
