//
//  SuggestViewController.swift
//  PinPhoto
//
//  Created by heo on 2020/12/21.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit
import Kingfisher
import Lottie

final class SuggestViewController: UIViewController {
    // MARK:- @IBOutlet Properties
    @IBOutlet weak var suggestCollectionView: UICollectionView!
    
    // MARK:- Propertises
    private let unsplashViewModel: UnsplashViewModel = UnsplashViewModel()
    private var headerUnsplash: Unsplash?
    private var unsplashes: [Unsplash] = []
        
    private var animationView: AnimationView = {
        let animation = Animation.named("loading")
        let animationView = AnimationView(animation: animation)
        animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.backgroundColor = UIColor(r: 44, g: 44, b: 46)
        animationView.loopMode = .loop
        return animationView
    }()

    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        prepareCollectionView()
        prepareSearchBar()
        prepareAnimationView()
        
        // unsplashViewModel.fetchSuggestKeyword()
        
        unsplashViewModel.requestSuggestClassification {
            self.bind()
            self.completeIntialImages()
        }
    }
 
    // MARK:- Methods
    private func bind() {
        unsplashViewModel.unsplash.bind { [weak self] unsplashes in
            if self?.unsplashes.isEmpty ?? true {
                self?.headerUnsplash = unsplashes.first
                self?.unsplashes = Array(unsplashes.dropFirst())
            } else {
                self?.unsplashes += unsplashes
            }
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
        suggestCollectionView.register(UINib(nibName: SuggestCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: SuggestCell.cellIdentifier)
        suggestCollectionView.register(UINib(nibName: SuggestHeaderView.reuseIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SuggestHeaderView.reuseIdentifier)
    }
    
    private func prepareAnimationView() {
        let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            animationView.topAnchor.constraint(equalTo: view.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
        
        animationView.play()
    }
    
    private func completeIntialImages() {
        navigationController?.isNavigationBarHidden = false
        
        UIView.animate(withDuration: 1, animations: {
            self.animationView.alpha = 0
        }, completion: { _ in
            self.removeAnimationView()
        })
    }
    
    private func removeAnimationView() {
        animationView.stop()
        animationView.removeFromSuperview()
    }
}

// MARK:- UICollectionView Data Source
extension SuggestViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return unsplashes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestCell.cellIdentifier, for: indexPath) as? SuggestCell else { return UICollectionViewCell() }
        
        let unsplash = unsplashes[indexPath.item]
        cell.update(by: unsplash)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SuggestHeaderView.reuseIdentifier, for: indexPath) as? SuggestHeaderView else {
                return UICollectionReusableView() }
            
            if let unsplash = headerUnsplash {
                reusableView.update(by: unsplash)
            }
            
            return reusableView
        default:
            break
        }
        
        return UICollectionReusableView()
    }
}

// MARK:- UICollectionView Delegate
extension SuggestViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let suggestWebVc = SuggestWebViewController.storyboardInstance() else { return }
        
        let unsplash = unsplashes[indexPath.item]
        suggestWebVc.suggestLink = unsplash.link.html
        
        self.present(suggestWebVc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if yOffset > (contentHeight + 100 - scrollView.frame.height) {
            request()
        }
    }
}

// MARK:- PinterestLayout Delegate
extension SuggestViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let unsplash = unsplashes[indexPath.item]
        let ratio = CGFloat(unsplash.imageRatio)
        
        return ratio * (view.bounds.width - 6) / 2
    }
    
    func itemCount() -> Int {
        return unsplashes.count
    }
}

// MARK:- UISearchController Delegate
extension SuggestViewController: UISearchControllerDelegate {
}
