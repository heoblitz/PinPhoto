//
//  SuggestViewController.swift
//  PinPhoto
//
//  Created by heo on 2020/12/21.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit
import Kingfisher

class SuggestViewController: UIViewController {
    
    @IBOutlet weak var suggestCollectionView: UICollectionView!
    // @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var unsplashes: [Unsplash] = []
    
    private let unsplashViewModel: UnsplashViewModel = UnsplashViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        suggestCollectionView.collectionViewLayout = PinterestLayout()
        
        let pinterestLayout = PinterestLayout()
        pinterestLayout.delegate = self
        pinterestLayout.headerReferenceSize = CGSize(width: view.bounds.width, height: 35)
        suggestCollectionView.contentInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        suggestCollectionView.collectionViewLayout = pinterestLayout
        
        let searchVc = UISearchController(searchResultsController: nil)
        // searchVc.searchBar.tintColor = .white
        searchVc.delegate = self
        searchVc.searchBar.searchBarStyle = .minimal
        searchVc.searchBar.searchTextField.backgroundColor = .lightGray
        searchVc.searchBar.searchTextField.alpha = 0.7
        searchVc.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Please provide the Project title", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        navigationItem.searchController = searchVc
        
        suggestCollectionView.dataSource = self
        suggestCollectionView.delegate = self
        suggestCollectionView.register(UINib(nibName: "SuggestCell", bundle: nil), forCellWithReuseIdentifier: "SuggestCell")
        suggestCollectionView.register(UINib(nibName: "SuggestHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        //
        self.extendedLayoutIncludesOpaqueBars = true
        bind()
    }
    
    private func bind() {
        unsplashViewModel.unsplash.bind { [weak self] unsplashes in
            self?.unsplashes += unsplashes
            self?.suggestCollectionView.reloadData()
            print(unsplashes)
        }
    }
    
    private func request() {
        unsplashViewModel.requestItems()
    }
}

extension SuggestViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return unsplashes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestCell", for: indexPath) as? SuggestCell else { return UICollectionViewCell() }
        let unsplash = unsplashes[indexPath.item]
        
        cell.suggestNameLabel.text = unsplash.name
        cell.suggestImageView.kf.setImage(with: URL(string: unsplash.thumnail.small))
        cell.layer.cornerRadius = 12
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
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//            let width: CGFloat = collectionView.frame.width
//            let height: CGFloat = 500
//            return CGSize(width: width, height: height)
//    }
}

extension SuggestViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return CGFloat(unsplashes[indexPath.item].imageRatio) * (view.bounds.width - 6) / 2
    }
    
    func itemCount() -> Int {
        return unsplashes.count
    }
}

extension SuggestViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        print(yOffset)
        
        if scrollView.contentOffset.y > 0  { //20
            // navigationItem.title = ""
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
