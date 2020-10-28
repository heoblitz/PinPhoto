//
//  ManualViewController.swift
//  PinPhoto
//
//  Created by won heo on 2020/08/02.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class ManualViewController: UIViewController {
    // MARK:- @IBOutlet Properties
    @IBOutlet private weak var manualCollectionView: UICollectionView!
    @IBOutlet private weak var manualPageControl: UIPageControl!
    
    // MARK:- Propertises
    private let assetNames: [String] = [
        "manual1", "manual2", "manual3", "manual4", "manual5", "manual6", "manual7", "manual8"
    ]
    
    private let manualTexts: [String] = [
        "1. Today Extension Widget \n Please add items",
        "Left scroll from Home Screen \n and touch edit button",
        "In iOS 14, touch Customize button \n and add Pin Photo widget",
        "Please touch > button to use widget",
        "2. iOS 14 widget \n Left scroll from Home Screen",
        "Click Edit button and then touch + plus in the upper left corner",
        "Add PinPhoto widget",
        "Select item to display in home widget and click display button at the bottom"
    ].map { $0.localized }
    
    // MARK:- View Life Sycle
    override func viewDidLoad() {
        super.viewDidLoad()
        manualCollectionView.dataSource = self
        manualCollectionView.delegate = self
        manualPageControl.numberOfPages = assetNames.count
    }
    
    // MARK:- Methods
    static func storyboardInstance() -> ManualViewController? {
        let storyboard = UIStoryboard(name: ManualViewController.storyboardName(), bundle: nil)
        
        return storyboard.instantiateInitialViewController()
    }

    // MARK:- @IBAction Methods
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK:- UICollectionView Data Source
extension ManualViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assetNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ManualCustomCell.cellIdentifier, for: indexPath) as? ManualCustomCell else {
            return UICollectionViewCell()
        }
        
        cell.manualImageView.image = UIImage(named: assetNames[indexPath.item])
        cell.manualTextLabel.text = manualTexts[indexPath.item]
        
        return cell
    }
}

// MARK:- UICollectionView Delegate
extension ManualViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = manualCollectionView.contentOffset.x / manualCollectionView.frame.size.width;
        
        manualPageControl.currentPage = Int(index)
    }
}

// MARK:- UICollectionView Delegate Flow Layout
extension ManualViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        
        return CGSize(width: width, height: height)
    }
}
