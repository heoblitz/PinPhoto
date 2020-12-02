//
//  HomeNavigationController.swift
//  PinPhoto
//
//  Created by won heo on 2020/08/21.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit
import YPImagePicker
import GoogleMobileAds

final class HomeNavigationController: UINavigationController {
    // MARK:- Properties
    private let addButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 25
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.3
        return view
    }()
    
    private let plusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus")
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var bannerView: GADBannerView = {
        let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        // bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.adUnitID = "ca-app-pub-8841719234465294/5699511091"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        return bannerView
    }()
    
    private let widgetGroupName: String = "위젯에 표시될 항목"
    private let itemViewModel = ItemViewModel()
    private let groupViewModel = GroupViewModel()

    // MARK:- View Life Sycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarItem?.title = "Item".localized
        // bannerView = GADBannerView(adSize: kGADAdSizeBanner)
    }
    
    override var childForStatusBarHidden: UIViewController? { // for child vc status bar hidden
        return topViewController
    }
    
    // MARK:- Methods
    func presentAddButtonView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentAddActionSheet))
        addButtonView.addGestureRecognizer(tapGesture)
        addButtonView.isUserInteractionEnabled = true
        addButtonView.addSubview(plusImageView)
        view.addSubview(addButtonView)
        prepareConstraint()
    }
    
    func dismissAddButtonView() {
        plusImageView.removeFromSuperview()
        addButtonView.removeFromSuperview()
    }
    
    private func prepareConstraint() {
        let tabBarHeight: CGFloat = tabBarController?.tabBar.frame.size.height ?? 0

        NSLayoutConstraint.activate([
            addButtonView.widthAnchor.constraint(equalToConstant: 50),
            addButtonView.heightAnchor.constraint(equalToConstant: 50),
            addButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            addButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(25 + tabBarHeight))
        ])
        
        NSLayoutConstraint.activate([
            plusImageView.widthAnchor.constraint(equalToConstant: 30),
            plusImageView.heightAnchor.constraint(equalToConstant: 30),
            plusImageView.centerXAnchor.constraint(equalTo: addButtonView.centerXAnchor),
            plusImageView.centerYAnchor.constraint(equalTo: addButtonView.centerYAnchor)
        ])
    }
     
    private func presentAddItemType(_ type: Int64) {
        switch type {
        case ItemType.image.value:
            presentImagePikcer()
        case ItemType.text.value:
            presentaddTextItem()
        default:
            break
        }
    }
    
    private func presentImagePikcer() {
        let picker = YPImagePicker(configuration: settingImagePickerConfig())
        
        picker.view.addSubview(bannerView)
        
        NSLayoutConstraint.activate([
            bannerView.centerXAnchor.constraint(equalTo: picker.view.centerXAnchor, constant: 0),
            bannerView.bottomAnchor.constraint(equalTo: picker.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        
        picker.didFinishPicking { [unowned picker] items, isNotSelect in
            guard let vc = SelectGroupViewController.storyboardInstance() else { return }
            
            if isNotSelect { // 사용자가 선택을 취소했을 때
                picker.dismiss(animated: true, completion: nil)
            }
            
            if self.isNotNeedGroupSelect() {
                self.saveImageItems(items: items)
                picker.dismiss(animated: true, completion: nil)
            }
            
            // 사용자가 선택을 완료했을 때
            vc.items = items
            vc.selectionType = .addImage
            
            picker.pushViewController(vc, animated: true)
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    private func presentaddTextItem() {
        guard let vc = CreateTextItemViewController.storyboardInstance() else {
            return
        }
        
        if isNotNeedGroupSelect() {
            vc.selectedGroup = getDetailVcGroup()
        }
        
        let navVc = UINavigationController(rootViewController: vc)
        navVc.modalPresentationStyle = .fullScreen
        navVc.view.addSubview(bannerView)
        
        NSLayoutConstraint.activate([
            bannerView.centerXAnchor.constraint(equalTo: navVc.view.centerXAnchor, constant: 0),
            bannerView.bottomAnchor.constraint(equalTo: navVc.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        
        present(navVc, animated: true)
    }
    
    private func isNotNeedGroupSelect() -> Bool {
        guard let topVc = topViewController as? HomeDetailViewController, let _ = topVc.group else {
            return false
        }
        return true
    }
    
    private func getDetailVcGroup() -> Group? {
        guard let topVc = topViewController as? HomeDetailViewController, let group = topVc.group else {
            return nil
        }
        return group
    }
    
    private func settingImagePickerConfig() -> YPImagePickerConfiguration {
        var config = YPImagePickerConfiguration()
        config.showsPhotoFilters = false
        config.screens = [.library]
        config.targetImageSize = YPImageSize.cappedTo(size: view.frame.height)
        config.library.defaultMultipleSelection = false
        config.library.maxNumberOfItems = 15
        config.hidesStatusBar = false
        config.library.skipSelectionsGallery = true
        
        if isNotNeedGroupSelect() {
            config.wordings.next = "Complete".localized
        }
        
        return config
    }
    
    private func saveImageItems(items: [YPMediaItem]) {
        guard let groupName = getDetailVcGroup()?.name else { return }

        var id: Int64 = itemViewModel.idForAdd

        if ifWidgetMaxCount(itemCount: items.count) {
            alertMaxCount()
            return
        }
        
        for item in items {
            switch item {
            case .photo(let photo):
                let imageData: Data? = photo.originalImage.data
                itemViewModel.add(content: ItemType.image.value, image: imageData, text: nil, date: Date(), id: id)
                groupViewModel.insertId(at: groupName, ids: [Int(id)])
                groupViewModel.load()
                
                id += 1
            default:
                break
            }
        }
        
        groupViewModel.noticeObservers()
    }
    
    private func ifWidgetMaxCount(itemCount: Int) -> Bool {
        guard let groupName = getDetailVcGroup()?.name else { return false }
        
        if groupName == widgetGroupName, groupViewModel.groups[0].numberOfItem + itemCount > 20 {
            return true
        } else {
            return false
        }
    }
    
    private func alertMaxCount() {
        let alert: UIAlertController = UIAlertController(title: "Notice".localized, message: "Item count cannot exceed 20".localized, preferredStyle: .alert)
        let accept: UIAlertAction = UIAlertAction(title: "Confirm".localized, style: .default, handler: nil)
        
        alert.addAction(accept)
        present(alert, animated: true)
    }
    
    @objc private func presentAddActionSheet() {
        let actionMenu = UIAlertController(title: nil, message: "Item Type".localized, preferredStyle: .actionSheet)
        
        ItemType.allCases.forEach { type in
            let action = UIAlertAction(title: type.title, style: .default, handler: { [weak self] _ in
                self?.presentAddItemType(type.value)
            })
            actionMenu.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        actionMenu.addAction(cancelAction)
        
        present(actionMenu, animated: true)
    }
}
