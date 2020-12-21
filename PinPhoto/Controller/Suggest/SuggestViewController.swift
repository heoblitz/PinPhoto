//
//  SuggestViewController.swift
//  PinPhoto
//
//  Created by heo on 2020/12/21.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class SuggestViewController: UIViewController {
    
    @IBOutlet weak var suggestCollectionView: UICollectionView!
    // @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var unsplashes: [Unsplash] = []
    
    private let unsplashViewModel: UnsplashViewModel = UnsplashViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        suggestCollectionView.collectionViewLayout = PinterestLayout()
        
        if let layout = suggestCollectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
            layout.headerReferenceSize = CGSize(width: 50, height: 130)
            print("a")
        }
        
        let searchVc = UISearchController(searchResultsController: nil)
        // searchVc.searchBar.tintColor = .white
        searchVc.delegate = self
        navigationItem.searchController = searchVc
        // navigationItem.hidesSearchBarWhenScrolling = false
        // indicatorView.startAnimating()
        
        suggestCollectionView.dataSource = self
        suggestCollectionView.delegate = self
        // suggestCollectionView.register(UINib(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        //
        self.extendedLayoutIncludesOpaqueBars = true
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 300.0)
    }
    
    private func bind() {
        unsplashViewModel.unsplash.bind { [weak self] unsplashes in
            // self?.indicatorView.stopAnimating()
            self?.unsplashes += unsplashes
            self?.suggestCollectionView.reloadData()
        }
    }
    
    private func request() {
        // indicatorView.startAnimating()
        unsplashViewModel.requestItems()
    }
}

extension SuggestViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return unsplashes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SuggestCell else { return UICollectionViewCell() }
        let unsplash = unsplashes[indexPath.item]
        
        // cell.itemImage.kf.setImage(with: URL(string: unsplash.thumnail.small))
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? SuggestHeaderView else {
                return UICollectionReusableView() }
            print("header")
            return cell
        default:
            print("wrong")
            break
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            let width: CGFloat = collectionView.frame.width
            let height: CGFloat = 500
            return CGSize(width: width, height: height)
    }
}

extension SuggestViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return CGFloat(unsplashes[indexPath.item].imageRatio) * (view.bounds.width - 4) / 2
    }
    
    func itemCount() -> Int {
        return unsplashes.count
    }
}

extension SuggestViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if scrollView.contentOffset.y > 0  { //20
            navigationItem.title = ""
        } else {
            // navigationItem.title = "changed"
        }
        
        if yOffset > (contentHeight + 100 - scrollView.frame.height) { //, !indicatorView.isAnimating {
            request()
        }
    }
}

extension SuggestViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        UIView.animate(withDuration: 0.5) {
            self.suggestCollectionView.contentOffset.y += 30
        }
    }
}
