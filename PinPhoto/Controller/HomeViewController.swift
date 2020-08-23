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

class HomeViewController: UIViewController {
    // MARK:- @IBOutlet Properties
    @IBOutlet private weak var itemCollectionView: UICollectionView!
    @IBOutlet private weak var toolbar: UIToolbar!
    @IBOutlet private weak var deleteButton: UIBarButtonItem!
    @IBOutlet private weak var addButton: UIBarButtonItem!
    @IBOutlet private weak var noticeView: UIView!
    
    // MARK:- Propertises
    private let itemViewModel = ItemViewModel()
    // private var feedbackGenerator: UISelectionFeedbackGenerator?
    static var isEditMode: Bool = false
    
    private lazy var imagePicker: YPImagePicker = {
        var config = YPImagePickerConfiguration()
        config.showsPhotoFilters = false
        config.screens = [.library]
        config.targetImageSize = YPImageSize.cappedTo(size: self.itemCollectionView.bounds.height)
        let picker = YPImagePicker(configuration: config)
        return picker
    }()
    
    private var testSelectedCell: [IndexPath:Int64] = [:] {
        didSet {
            if testSelectedCell.count > 0 {
                self.deleteButton.isEnabled = true
            } else {
                self.deleteButton.isEnabled = false
            }
        }
    }
    
    private var itemCounts: Int = 0 {
        didSet {
            if itemCounts == 0 {
                self.noticeView.isHidden = false
            } else {
                self.noticeView.isHidden = true
            }
        }
    }
    
    // MARK:- View Life Sycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.itemCollectionView.dataSource = self
        self.itemCollectionView.delegate = self
        self.itemCollectionView.allowsMultipleSelection = true
        self.itemCollectionView.delaysContentTouches = false
        
        self.itemViewModel.loadItems()
        self.itemCounts = itemViewModel.numberOfItems
        self.itemViewModel.registerObserver(self)
        
        self.setupNoticeView()
        // self.setupGenerator()
        self.tabBarController?.tabBar.isHidden = false
        self.toolbar.isHidden = true
    }
    
    // MARK:- Methods
    private func setupGenerator() {
//        feedbackGenerator = UISelectionFeedbackGenerator()
//        feedbackGenerator?.prepare()
    }
    
    private func setupNoticeView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentAddActionSheet))
        tapGesture.cancelsTouchesInView = false
        self.noticeView.isUserInteractionEnabled = true
        self.noticeView.addGestureRecognizer(tapGesture)
        self.noticeView.clipsToBounds = false
        self.noticeView.layer.opacity = 0.8
        self.noticeView.layer.cornerRadius = 5
    }
    
    private func deselectCells() {
        testSelectedCell.forEach { indexPath, _ in
            let cell = self.itemCollectionView.cellForItem(at: indexPath) as? ItemCustomCell
            cell?.isSelectedForRemove = false
        }
    }
    
    private func presentImagePikcer() {
        imagePicker.didFinishPicking { [unowned imagePicker, weak self] items, _ in
            if let photo = items.singlePhoto?.originalImage {
                let imageData = self?.itemViewModel.convertImageToData(image: photo)
                let id = self?.itemViewModel.idForAdd ?? 0
                
                self?.itemViewModel.add(content: 0, image: imageData, text: nil, date: Date(), id: id)
                self?.itemViewModel.loadItems()
                
                OperationQueue.main.addOperation {
                    self?.itemCollectionView.reloadData()
                }
            }
            imagePicker.dismiss(animated: true, completion: nil)
        }
        present(imagePicker, animated: true, completion: nil)
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
    
    // MARK:- @IBAction Methods
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        sender.title = sender.title == "편집" ? "완료" : "편집"
        
        tabBarController?.tabBar.isHidden.toggle()
        toolbar.isHidden.toggle()
        
        addButton.isEnabled.toggle()
        HomeViewController.isEditMode.toggle()
        deselectCells()
        testSelectedCell = [:]
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        presentAddActionSheet()
    }
    
    @IBAction func removeButtonTapped(_ sender: UIBarButtonItem) {
        testSelectedCell.forEach { indexPath, id in
            self.itemViewModel.remove(id: id)
        }
        testSelectedCell = [:]
        
        itemViewModel.loadItems()
        itemCollectionView.reloadData()
    }
}

// MARK:- UICollectionView Data Source
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemViewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageItemcell", for: indexPath) as? ItemCustomCell else {
            return UICollectionViewCell()
        }
        let itemInfo = itemViewModel.item(at: indexPath.item)
        
        if testSelectedCell.contains(where: { (selectedIndexPath, _) in return selectedIndexPath == indexPath }) {
            cell.isSelectedForRemove = true
        } else {
            cell.isSelectedForRemove = false
        }
        
        switch itemInfo.contentType {
        case 0:
            let imageData = itemInfo.contentImage
            cell.itemtype = "image"
            cell.itemImageView?.contentMode = .scaleAspectFill
            cell.itemImageView?.image = itemViewModel.convertDataToImage(data: imageData)
            return cell
        case 1:
            cell.itemtype = "text"
            cell.itemTextLabel.text = itemInfo.contentText
            return cell
        default:
            return cell
        }
    }
}

// MARK:- UICollectionView Delegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ItemCustomCell else {
            return
        }
        let item = itemViewModel.item(at: indexPath.item)

        if !HomeViewController.isEditMode { // Default Mode
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
            testSelectedCell[indexPath] = item.id
            cell.isSelectedForRemove = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? ItemCustomCell
        cell?.isSelectedForRemove = false
        
        testSelectedCell = testSelectedCell.filter { selectedIndexPath, id in
            selectedIndexPath != indexPath
        }
    }
}

// MARK:- UICollectionView Delegate Flow Layout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt: IndexPath) -> CGSize {
        let width = (itemCollectionView.bounds.width - 4) / 3
        let height = (itemCollectionView.bounds.width - 4) / 3
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

// MARK:- ItemObserver Protocol
extension HomeViewController: ItemObserver {
    func updateItem() {
        guard let itemCollectionView = itemCollectionView else {
            return
        }
        print("item updated")
        self.itemViewModel.loadItems()
        self.itemCounts = self.itemViewModel.numberOfItems
        itemCollectionView.reloadData()
    }
    
    func errorItem(_ error: Error) {
        let alert = UIAlertController(title: "알림", message: error.localizedDescription, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
