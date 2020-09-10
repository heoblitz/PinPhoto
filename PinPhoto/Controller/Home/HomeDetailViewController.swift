//
//  MainViewController.swift
//  PinPhoto
//
//  Created by won heo on 2020/06/30.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit
import Photos
import YPImagePicker

class HomeDetailViewController: UIViewController {
    // MARK:- @IBOutlet Properties
    @IBOutlet private weak var itemCollectionView: UICollectionView!
    @IBOutlet private weak var toolbar: UIToolbar!
    @IBOutlet private weak var deleteButton: UIBarButtonItem!
    @IBOutlet private weak var addButtonView: UIView!
    
    // MARK:- Propertises
    private let itemViewModel = ItemViewModel()
    private let groupViewModel = GroupViewModel()
    static var isEditMode: Bool = false
    
    private lazy var config: YPImagePickerConfiguration = {
        var config = YPImagePickerConfiguration()
        config.showsPhotoFilters = false
        config.screens = [.library]
        config.targetImageSize = YPImageSize.cappedTo(size: self.itemCollectionView.bounds.height)
        config.library.defaultMultipleSelection = false
        config.library.maxNumberOfItems = 15
        return config
    }()
    
    private var selectedCell: [IndexPath:Int64] = [:] {
        didSet {
            if selectedCell.count > 0 {
                self.deleteButton.isEnabled = true
            } else {
                self.deleteButton.isEnabled = false
            }
        }
    }
    
    // MARK:- View Life Sycle
    override func viewDidLoad() {
        super.viewDidLoad()
        itemViewModel.loadItems()
        itemViewModel.registerObserver(self)
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .systemPink
        title = "위젯에 나타날 항목"
        tabBarController?.tabBar.isHidden = false
        toolbar.isHidden = true
        
        prepareAddButton()
        prepareItemCollectionView()
    }
    
    // MARK:- Methods
    static func storyboardInstance() -> HomeDetailViewController? {
        let storyboard = UIStoryboard(name: HomeDetailViewController.storyboardName(), bundle: nil)
        
        return storyboard.instantiateInitialViewController()
    }
    
    private func prepareItemCollectionView() {
        itemCollectionView.dataSource = self
        itemCollectionView.delegate = self
        itemCollectionView.allowsMultipleSelection = true
        itemCollectionView.delaysContentTouches = false
    }
    
    private func deselectCells() {
        selectedCell.forEach { indexPath, _ in
            let cell = self.itemCollectionView.cellForItem(at: indexPath) as? ItemCustomCell
            cell?.isSelectedForRemove = false
        }
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
    
    private func presentImagelimitedAlert() {
        let alert = UIAlertController(title: "알림", message: "위젯 메모리 제한으로 인해 \n 이미지는 15개를 초과할 수 없습니다!", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    @objc private func presentAddActionSheet() {
        let actionMenu = UIAlertController(title: nil, message: "아이템 종류", preferredStyle: .actionSheet)
        
        let imageAction = UIAlertAction(title: "이미지 추가하기", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if self.itemViewModel.numberOfImages >= 15 {
                self.presentImagelimitedAlert()
            } else {
                self.presentImagePikcer()
            }
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
    
    private func prepareAddButton() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentAddActionSheet))
        addButtonView.addGestureRecognizer(tapGesture)
        addButtonView.isUserInteractionEnabled = true
        addButtonView.layer.masksToBounds = true
        addButtonView.layer.cornerRadius = addButtonView.frame.height / 2
    }
    
    // MARK:- @IBAction Methods
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        sender.title = sender.title == "편집" ? "완료" : "편집"
        
        tabBarController?.tabBar.isHidden.toggle()
        toolbar.isHidden.toggle()
        //addButton.isEnabled.toggle()
        HomeDetailViewController.isEditMode.toggle()
        deselectCells()
        selectedCell = [:]
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        presentAddActionSheet()
    }
    
    @IBAction func removeButtonTapped(_ sender: UIBarButtonItem) {
        selectedCell.forEach { indexPath, id in
            self.itemViewModel.remove(id: id)
        }
        selectedCell = [:]
        
        itemViewModel.loadItems()
    }
}

// MARK:- UICollectionView Data Source
extension HomeDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemViewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCustomCell.cellIdentifier, for: indexPath) as? ItemCustomCell else {
            return UICollectionViewCell()
        }
        let item = itemViewModel.item(at: indexPath.item)
        
        if selectedCell.contains(where: { (selectedIndexPath, _) in return selectedIndexPath == indexPath }) {
            cell.isSelectedForRemove = true
        } else {
            cell.isSelectedForRemove = false
        }
        cell.update(item)
        
        return cell
    }
}

// MARK:- UICollectionView Delegate
extension HomeDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ItemCustomCell else {
            return
        }
        let item = itemViewModel.item(at: indexPath.item)

        if !HomeDetailViewController.isEditMode { // Default Mode
            cell.freezeAnimations()
            collectionView.deselectItem(at: indexPath, animated: false)
            switch cell.itemtype {
            case "text":
                guard let vc = EditTextItemViewController.storyboardInstance() else {
                    return
                }
                vc.item = item
                vc.itemViewModel = itemViewModel
                cell.unfreezeAnimations()
                navigationController?.pushViewController(vc, animated: true)
            case "image":
                guard let vc = EditImageItemViewController.storyboardInstance() else {
                    return
                }
                vc.item = item
                vc.itemViewModel = itemViewModel
                cell.unfreezeAnimations()
                navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        } else { // Edit Mode
            selectedCell[indexPath] = item.id
            cell.isSelectedForRemove = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? ItemCustomCell
        cell?.isSelectedForRemove = false
        
        selectedCell = selectedCell.filter { selectedIndexPath, id in
            selectedIndexPath != indexPath
        }
    }
}

// MARK:- UICollectionView Delegate Flow Layout
extension HomeDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt: IndexPath) -> CGSize {
        let width = (itemCollectionView.bounds.width - 2) / 3
        let height = (itemCollectionView.bounds.width - 2) / 3
        
        return CGSize(width: width, height: height)
    }
}

// MARK:- ItemObserver Protocol
extension HomeDetailViewController: ItemObserver {
    func updateItem() {
        guard let itemCollectionView = itemCollectionView else {
            return
        }
        itemViewModel.loadItems()
        itemCollectionView.reloadData()
    }
    
    func errorItem(_ error: Error) {
        let alert = UIAlertController(title: "알림", message: error.localizedDescription, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
