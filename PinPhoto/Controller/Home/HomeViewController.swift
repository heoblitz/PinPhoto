//
//  TestHomeViewController.swift
//  PinPhoto
//
//  Created by won heo on 2020/09/05.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit
import StoreKit
// import YPImagePicker

final class HomeViewController: UIViewController {
    // MARK:- @IBOutlet Properties
    @IBOutlet private weak var homeCollectionView: UICollectionView!
    
    // MARK:- Properties
    private let groupViewModel = GroupViewModel()
    private let itemViewModel = ItemViewModel()

    // MARK:- View Life Sycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Item".localized
        
        groupViewModel.load()
        groupViewModel.attachObserver(self)
        prepareHomeCollectionView()
        
        if UserDefaults.standard.bool(forKey: "reviewed") == false, groupViewModel.groups.first?.ids.count ?? 0 >= 15 {
            SKStoreReviewController.requestReview()
            UserDefaults.standard.setValue(true, forKey: "reviewed")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        guard let navVc = navigationController as? HomeNavigationController else { return }
        navVc.presentAddButtonView()
    }
    
    // MARK:- Methods
    private func prepareHomeCollectionView() {
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
        homeCollectionView.contentInsetAdjustmentBehavior = .never
        homeCollectionView.alwaysBounceVertical = true
        
        let height: CGFloat = (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) + (navigationController?.navigationBar.frame.height ?? 0.0) + 50
        homeCollectionView.contentInset = UIEdgeInsets(top: height, left: 15, bottom: 15, right: 15)
        
        homeCollectionView.register(UINib(nibName: HomeSectionReusableView.reuseIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:  HomeSectionReusableView.reuseIdentifier)
        homeCollectionView.register(UINib(nibName: HomeHeaderViewCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: HomeHeaderViewCell.cellIdentifier)
        homeCollectionView.register(UINib(nibName: HomeGroupViewCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: HomeGroupViewCell.cellIdentifier)
    }
}

// MARK:- CollectionView Data Source
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return groupViewModel.groups.count - 1
        default:
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeHeaderViewCell.cellIdentifier, for: indexPath) as? HomeHeaderViewCell else {
                return UICollectionViewCell()
            }
            let group = groupViewModel.groups[0]
            let item = itemViewModel.thumbnailItem(ids: group.ids)
            cell.update(at: item)
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeGroupViewCell.cellIdentifier, for: indexPath) as? HomeGroupViewCell else {
                return UICollectionViewCell()
            }
            let group = groupViewModel.groups[indexPath.item + 1]
            let item = itemViewModel.thumbnailItem(ids: group.ids)
            cell.update(at: item, title: group.name)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeSectionReusableView.reuseIdentifier, for: indexPath)
            return cell
        default:
            break
        }
        
        return UICollectionReusableView()
    }
}

// MARK:- CollectionView Data Delegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.item {
            case 0:
                guard let vc = HomeDetailViewController.storyboardInstance() else { return }
                vc.group = groupViewModel.groups[0]
                navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        case 1:
            guard let vc = HomeDetailViewController.storyboardInstance() else { return }
            let group = groupViewModel.groups[indexPath.item + 1]
            vc.group = group
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

// MARK:- CollectionView Delegate Flow Layout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            let width: CGFloat = collectionView.frame.width - 30
            let height: CGFloat = 45
            return CGSize(width: width, height: height)
        }
        
        return CGSize.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            let width: CGFloat = collectionView.frame.width - 30
            let height: CGFloat = collectionView.frame.width - 30
            return CGSize(width: width, height: height)
        case 1:
            let width: CGFloat = (collectionView.frame.width - 40) / 2
            let height: CGFloat = (collectionView.frame.width - 40) / 2
            return CGSize(width: width, height: height)
        default:
            return CGSize.init()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        default:
            return UIEdgeInsets.init()
        }
    }
}

// MARK:- GroupObserver
extension HomeViewController: GroupObserver {
    var groupIdentifier: String {
        return HomeViewController.observerName()
    }

    func updateGroup() {
        self.homeCollectionView.reloadData()
    }
}
