//
//  TestHomeViewController.swift
//  PinPhoto
//
//  Created by won heo on 2020/09/05.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit
import YPImagePicker

class HomeViewController: UIViewController {
    @IBOutlet private weak var homeCollectionView: UICollectionView!
    
    private let itemViewModel = ItemViewModel(.widget)
    private let groupViewModel = GroupViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always
        itemViewModel.loadItems()
        groupViewModel.load()
        groupViewModel.attachObserver(self)
        prepareHomeCollectionView()
    }
    
    private func prepareHomeCollectionView() {
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
        homeCollectionView.contentInsetAdjustmentBehavior = .never
        homeCollectionView.alwaysBounceVertical = true
        let height: CGFloat = (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) + (navigationController?.navigationBar.frame.height ?? 0.0) + 50
        homeCollectionView.contentInset = UIEdgeInsets(top: height, left: 15, bottom: 15, right: 15)
        homeCollectionView.register(UINib(nibName: "HomeSectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeSectionReusableView")
        homeCollectionView.register(UINib(nibName: "HomeHeaderViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeHeaderViewCell")
        homeCollectionView.register(UINib(nibName: "HomeGroupViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeGroupViewCell")
    }
}

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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeHeaderViewCell", for: indexPath) as? HomeHeaderViewCell else {
                return UICollectionViewCell()
            }
            let item = itemViewModel.thumbnailItem
            cell.update(at: item)
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeGroupViewCell", for: indexPath) as? HomeGroupViewCell else {
                return UICollectionViewCell()
            }
            let group = groupViewModel.groups[indexPath.item + 1]
            cell.update(at: group)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeSectionReusableView", for: indexPath)
            return cell
        default:
            break
        }
        
        return UICollectionReusableView()
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.item {
            case 0:
                guard let vc = HomeDetailViewController.storyboardInstance() else { return }
                
                navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
            
        default:
            break
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            let width: CGFloat = collectionView.frame.width - 30
            let height: CGFloat = 40
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

extension HomeViewController: GroupObserver {
    var groupIdentifier: String {
        return HomeViewController.observerName()
    }
    
    func updateGroup() {
        homeCollectionView.reloadSections(IndexSet(1...1))
    }
}
