//
//  SearchViewController.swift
//  PinPhoto
//
//  Created by won heo on 2020/09/04.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    let searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.tintColor = .systemPink
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}
