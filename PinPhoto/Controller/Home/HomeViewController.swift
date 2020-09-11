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
    @IBOutlet private weak var addButtonView: UIView!

    private let itemViewModel = ItemViewModel()
    private let groupViewModel = GroupViewModel()
    
    private lazy var config: YPImagePickerConfiguration = {
        var config = YPImagePickerConfiguration()
        config.showsPhotoFilters = false
        config.screens = [.library]
        config.targetImageSize = YPImageSize.cappedTo(size: self.homeCollectionView.bounds.height)
        config.library.defaultMultipleSelection = false
        config.library.maxNumberOfItems = 15
        return config
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always
        itemViewModel.loadItems()
        groupViewModel.load()
        
        prepareHomeCollectionView()
        prepareAddButton()
    }
    
    private func prepareHomeCollectionView() {
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
        homeCollectionView.contentInsetAdjustmentBehavior = .never
        homeCollectionView.alwaysBounceVertical = true
        homeCollectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        homeCollectionView.register(UINib(nibName: "HomeSectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeSectionReusableView")
        homeCollectionView.register(UINib(nibName: "HomeHeaderViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeHeaderViewCell")
        homeCollectionView.register(UINib(nibName: "HomeGroupViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeGroupViewCell")
    }
    
    private func prepareAddButton() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentAddActionSheet))
        addButtonView.addGestureRecognizer(tapGesture)
        addButtonView.isUserInteractionEnabled = true
        addButtonView.layer.masksToBounds = true
        addButtonView.layer.cornerRadius = addButtonView.frame.height / 2
    }
    
    private func presentImagePikcer() {
        let picker = YPImagePicker(configuration: config)

        picker.didFinishPicking { [unowned picker, weak self] items, isNotSelect in
            guard let self = self else { return }
            guard let vc = SelectGroupViewController.storyboardInstance() else { return }
            
            if isNotSelect { // 사용자가 선택을 취소했을 때
                picker.dismiss(animated: true, completion: nil)
            }
            // 사용자가 선택을 완료했을 때
            vc.itemViewModel = self.itemViewModel
            vc.items = items
            picker.pushViewController(vc, animated: true)
        }

        present(picker, animated: true, completion: nil)
    }
    
    private func presentaddTextItem() {
        guard let vc = CreateTextItemViewController.storyboardInstance() else {
            return
        }
        vc.itemViewModel = itemViewModel
        
        present(vc, animated: true)
    }
    
    @objc private func presentAddActionSheet() {
        let actionMenu = UIAlertController(title: nil, message: "아이템 종류", preferredStyle: .actionSheet)
        
        let imageAction = UIAlertAction(title: "이미지 추가하기", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.presentImagePikcer()
        })
        
        let textAction = UIAlertAction(title: "텍스트 추가하기", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.presentaddTextItem()
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        actionMenu.addAction(imageAction)
        actionMenu.addAction(textAction)
        actionMenu.addAction(cancelAction)
        
        present(actionMenu, animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return groupViewModel.groups.count
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeGroupViewCell", for: indexPath)
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
        let height: CGFloat = (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) + (navigationController?.navigationBar.frame.height ?? 0.0)
        return UIEdgeInsets(top: height, left: 0, bottom: 30, right: 0)
    }
}
