//
//  SearchViewController.swift
//  PinPhoto
//
//  Created by won heo on 2020/09/04.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet private weak var searchCollectionView: UICollectionView!
    
    let searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.tintColor = .systemPink
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "분류명을 입력해주세요."
        return search
    }()
    
    let groupViewModel: GroupViewModel = GroupViewModel()
    let itemViewModel: ItemViewModel = ItemViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareSearchViewController()
        prepareSearchCollectionView()
        definesPresentationContext = true
    }
    
    private func prepareSearchViewController() {
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchResultsUpdater = self
        navigationItem.searchController?.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func prepareSearchCollectionView() {
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self
        searchCollectionView.contentInsetAdjustmentBehavior = .never
        searchCollectionView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        searchCollectionView.register(UINib(nibName: "HomeGroupViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeGroupViewCell")
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupViewModel.filterGroup.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeGroupViewCell", for: indexPath) as? HomeGroupViewCell else {
            return UICollectionViewCell()
        }
        
        let group = groupViewModel.filterGroup[indexPath.item]
        let item = itemViewModel.thumbnailItem(ids: group.ids)
        cell.update(at: item, title: group.name)
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = HomeDetailViewController.storyboardInstance() else { return }
        let group = groupViewModel.filterGroup[indexPath.item]
        vc.group = group
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.frame.width - 40) / 2
        let height: CGFloat = (collectionView.frame.width - 40) / 2
        return CGSize(width: width, height: height)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let input: String = searchController.searchBar.text, !input.isEmpty else { return }
        groupViewModel.loadFilterGroup(name: input)
        searchCollectionView.reloadData()
    }
}

extension SearchViewController: UISearchControllerDelegate {
    func willDismissSearchController(_ searchController: UISearchController) {
        groupViewModel.loadFilterGroup(name: "")
        searchCollectionView.reloadData()
    }
}
