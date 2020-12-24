//
//  SuggestViewController.swift
//  PinPhoto
//
//  Created by heo on 2020/12/21.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit
import Kingfisher

final class SuggestViewController: UIViewController {
    
    @IBOutlet weak var suggestCollectionView: UICollectionView!
    
    private let unsplashViewModel: UnsplashViewModel = UnsplashViewModel()
    private var unsplashes: [Unsplash] = []
    
    var initialYoffset: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView()
        prepareSearchBar()
        bind()
    }
 
    private func bind() {
        unsplashViewModel.unsplash.bind { [weak self] unsplashes in
            self?.unsplashes += unsplashes
            self?.suggestCollectionView.reloadData()
        }
    }
    
    private func request() {
        unsplashViewModel.requestItems()
    }
    
    private func prepareSearchBar() {
        let searchVc = UISearchController(searchResultsController: nil)
        searchVc.delegate = self
        searchVc.searchBar.tintColor = .white
        searchVc.searchBar.searchBarStyle = .minimal
        searchVc.searchBar.searchTextField.backgroundColor = UIColor(r: 58, g: 58, b: 60)
        searchVc.searchBar.searchTextField.alpha = 0.7
        searchVc.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        navigationItem.searchController = searchVc
    }
    
    private func prepareCollectionView() {
        let pinterestLayout = PinterestLayout()
        pinterestLayout.delegate = self
        pinterestLayout.headerReferenceSize = CGSize(width: view.bounds.width, height: 35)
        
        suggestCollectionView.collectionViewLayout = pinterestLayout
        suggestCollectionView.dataSource = self
        suggestCollectionView.delegate = self
        suggestCollectionView.register(UINib(nibName: "SuggestCell", bundle: nil), forCellWithReuseIdentifier: "SuggestCell")
        suggestCollectionView.register(UINib(nibName: "SuggestHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }
}

extension SuggestViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return unsplashes.dropFirst().count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestCell", for: indexPath) as? SuggestCell else { return UICollectionViewCell() }
        let unsplash = Array(unsplashes.dropFirst())[indexPath.item]
        
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
            
            if let headerItem = unsplashes.first {
                cell.headerImage.kf.setImage(with: URL(string: headerItem.thumnail.small))
                cell.headerNameLabel.text = "Photo by " + headerItem.name
            }
            
            return cell
        default:
            break
        }
        
        return UICollectionReusableView()
    }
}

extension SuggestViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let suggestWebVc = SuggestWebViewController.storyboardInstance() else { return }
        
        let item = Array(unsplashes.dropFirst())[indexPath.item]
        
        suggestWebVc.suggestLink = item.link.html
        
        self.present(suggestWebVc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if initialYoffset == 0 {
            initialYoffset = yOffset
        }
        
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

extension SuggestViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return CGFloat(Array(unsplashes.dropFirst())[indexPath.item].imageRatio) * (view.bounds.width - 6) / 2
    }
    
    func itemCount() -> Int {
        return unsplashes.dropFirst().count
    }
}

extension SuggestViewController: UISearchControllerDelegate {
    func willDismissSearchController(_ searchController: UISearchController) {
        suggestCollectionView.setContentOffset(CGPoint(x: 0, y: initialYoffset), animated: true)
    }
}
