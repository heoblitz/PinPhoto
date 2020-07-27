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

class MainViewController: UIViewController {
    // MARK:- IBOutlet Properties
    @IBOutlet private weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    // MARK:- Propertises
    let imageManager = PHImageManager()
    let itemViewModel = ItemViewModel()
    
    var feedbackGenerator: UIFeedbackGenerator?
    var isEditMode: Bool = false

    var testSelectedCell: [IndexPath:Int64] = [:] {
        didSet {
            if testSelectedCell.count > 0 {
                self.deleteButton.isEnabled = true
            } else {
                self.deleteButton.isEnabled = false
            }
        }
    }
    
    // MARk:- View Life Sycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.itemCollectionView.dataSource = self
        self.itemCollectionView.delegate = self
        self.itemCollectionView.allowsMultipleSelection = true
        
        self.tabBarController?.tabBar.isHidden = false
        self.deleteButton.isEnabled = false
        self.toolbar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.itemViewModel.loadItems()
        self.itemCollectionView.reloadData()
    }
    
    // MARK:- Methods
    func deselectCells() {
        testSelectedCell.forEach { indexPath, _ in
            let cell = self.itemCollectionView.cellForItem(at: indexPath) as? ItemCustomCell
            cell?.isSelectedForRemove = false
        }
    }
    
    func presentImagePikcer() {
        let imagePicker = ImagePickerController()
        let imageWidth = itemCollectionView.bounds.width
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
    
    func presentaddTextItem() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "addTextItemViewController") as? EditTextItemViewController else {
            return
        }
        vc.itemViewModel = itemViewModel
        vc.mainItemCollectionView = itemCollectionView
        
        present(vc, animated: true)
    }
    
    // MARK:- IBAction Methods
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        sender.title = sender.title == "편집" ? "완료" : "편집"
        
        tabBarController?.tabBar.isHidden.toggle()
        toolbar.isHidden.toggle()
        isEditMode.toggle()
        deselectCells()
        testSelectedCell = [:]
        
        itemViewModel.printID()
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
extension MainViewController: UICollectionViewDataSource {
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
            cell.itemImage?.contentMode = .scaleAspectFill
            cell.itemImage?.image = itemViewModel.convertDataToImage(data: imageData)
            return cell
        case 1:
            cell.itemtype = "text"
            cell.itemText.text = itemInfo.contentText
            return cell
        default:
            return cell
        }
    }
}

// MARK:- UICollectionView Delegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ItemCustomCell else {
            return
        }
        
        if isEditMode {
            let item = itemViewModel.item(at: indexPath.item)
            testSelectedCell[indexPath] = item.id
            
            cell.isSelectedForRemove = true
        } else {
            if cell.itemtype == "text" {
                guard let vc = storyboard?.instantiateViewController(withIdentifier: "addTextItemViewController") else {
                    return
                }
                navigationController?.pushViewController(vc, animated: true)
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
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt: IndexPath) -> CGSize {
        let width = itemCollectionView.bounds.width / 3.1
        let height = itemCollectionView.bounds.width / 3.1
        
        return CGSize(width: width, height: height)
    }
}