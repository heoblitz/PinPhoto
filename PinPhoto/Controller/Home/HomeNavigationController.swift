//
//  HomeNavigationController.swift
//  PinPhoto
//
//  Created by won heo on 2020/08/21.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit
import YPImagePicker

class HomeNavigationController: UINavigationController {
    // MARK:- Properties
    private lazy var config: YPImagePickerConfiguration = {
        var config = YPImagePickerConfiguration()
        config.showsPhotoFilters = false
        config.screens = [.library]
        config.targetImageSize = YPImageSize.cappedTo(size: view.frame.height)
        config.library.defaultMultipleSelection = false
        config.library.maxNumberOfItems = 15
        config.hidesStatusBar = false
        return config
    }()
    
    let addButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 25
        return view
    }()
    
    let plusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus")
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK:- View Life Sycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarItem?.title = "Item".localized
    }
    
    override open var childForStatusBarHidden: UIViewController? { // for child vc status bar hidden
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
    
    private func presentaddTextItem() {
        guard let vc = CreateTextItemViewController.storyboardInstance() else {
            return
        }
        let navVc = UINavigationController(rootViewController: vc)
        navVc.modalPresentationStyle = .fullScreen
        
        present(navVc, animated: true)
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
    
    @objc private func presentImagePikcer() {
        let picker = YPImagePicker(configuration: config)

        picker.didFinishPicking { [unowned picker] items, isNotSelect in
            guard let vc = SelectGroupViewController.storyboardInstance() else { return }
            
            if isNotSelect { // 사용자가 선택을 취소했을 때
                picker.dismiss(animated: true, completion: nil)
            }
            // 사용자가 선택을 완료했을 때
            vc.items = items
            vc.selectionType = .addImage
            picker.pushViewController(vc, animated: true)
        }
        
        present(picker, animated: true, completion: nil)
    }
}
