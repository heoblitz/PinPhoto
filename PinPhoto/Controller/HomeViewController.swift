//
//  MainViewController.swift
//  PinPhoto
//
//  Created by won heo on 2020/06/30.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit
import Photos
import BSImagePicker

class HomeViewController: UIViewController {
    // MARK:- @IBOutlet Properties
    @IBOutlet private weak var itemCollectionView: UICollectionView!
    @IBOutlet private weak var toolbar: UIToolbar!
    @IBOutlet private weak var deleteButton: UIBarButtonItem!
    @IBOutlet private weak var addButton: UIBarButtonItem!
    @IBOutlet private weak var noticeView: UIView!
    
    // MARK:- Propertises
    private let imageManager = PHImageManager()
    private let itemViewModel = ItemViewModel()
    
    private var feedbackGenerator: UISelectionFeedbackGenerator?
    private var isEditMode: Bool = false

    private var testSelectedCell: [IndexPath:Int64] = [:] {
        didSet {
            feedbackGenerator?.selectionChanged()
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
        print("home vc momory")
        self.itemCollectionView.dataSource = self
        self.itemCollectionView.delegate = self
        self.itemCollectionView.allowsMultipleSelection = true
        
        self.noticeView.clipsToBounds = false
        self.noticeView.layer.opacity = 0.8
        self.noticeView.layer.cornerRadius = 5
        
        self.itemViewModel.loadItems()
        self.itemCounts = itemViewModel.numberOfItems
        self.itemViewModel.registerObserver(self)
        
        self.setupGenerator()
        self.tabBarController?.tabBar.isHidden = false
        self.toolbar.isHidden = true
    }

    // MARK:- Methods
    private func deselectCells() {
        testSelectedCell.forEach { indexPath, _ in
            let cell = self.itemCollectionView.cellForItem(at: indexPath) as? ItemCustomCell
            cell?.isSelectedForRemove = false
        }
    }
    
    private func presentImagePikcer() {
        let imagePicker = ImagePickerController()
        let imageWidth = itemCollectionView.bounds.height
        let imageSize = CGSize(width: imageWidth, height: imageWidth)
        
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        option.isNetworkAccessAllowed = true
        option.deliveryMode = .highQualityFormat
        option.version = .current
        option.resizeMode = .exact
        
        presentImagePicker(imagePicker, select: { (asset) in
            // User selected an asset. Do something with it. Perhaps begin processing/upload?
        }, deselect: { (asset) in
            // User deselected an asset. Cancel whatever you did when asset was selected.
        }, cancel: { (assets) in
            // User canceled selection.
        }, finish: { (assets) in
            for asset in assets {
                self.imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFit, options: option, resultHandler: {[weak self] image, _ in
                    let image = self?.itemViewModel.convertImageToData(image: image)
                    let id = self?.itemViewModel.idForAdd ?? 0
                    self?.itemViewModel.add(content: 0, image: image, text: nil, date: Date(), id: id)
                    self?.itemViewModel.loadItems()
                    
                    OperationQueue.main.addOperation {
                        self?.itemCollectionView.reloadData()
                    }
                })
            }
        })
    }
    
    private func presentaddTextItem() {
        guard let vc = CreateTextItemViewController.storyboardInstance() else {
            return
        }
        vc.itemViewModel = itemViewModel
        
        present(vc, animated: true)
    }
    
    private func setupGenerator() {
        feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator?.prepare()
    }
    
    // MARK:- @IBAction Methods
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        sender.title = sender.title == "편집" ? "완료" : "편집"
        
        tabBarController?.tabBar.isHidden.toggle()
        toolbar.isHidden.toggle()
        
        addButton.isEnabled.toggle()
        isEditMode.toggle()
        deselectCells()
        testSelectedCell = [:]
        // itemViewModel.printID()
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
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

        if isEditMode {
            testSelectedCell[indexPath] = item.id
            cell.isSelectedForRemove = true
        } else {
            switch cell.itemtype {
            case "text":
                guard let vc = EditTextItemViewController.storyboardInstance() else {
                    return
                }
                vc.item = item
                vc.itemViewModel = itemViewModel
                navigationController?.pushViewController(vc, animated: true)
            case "image":
                guard let vc = EditImageItemViewController.storyboardInstance() else {
                    return
                }
                vc.item = item
                vc.itemViewModel = itemViewModel
                navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
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
        let width = itemCollectionView.bounds.width / 3.1
        let height = itemCollectionView.bounds.width / 3.1
        
        return CGSize(width: width, height: height)
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
