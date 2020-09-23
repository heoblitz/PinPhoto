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
    @IBOutlet private weak var deleteButton: UIBarButtonItem!
    @IBOutlet private weak var sendButton: UIBarButtonItem!
    @IBOutlet private weak var editButton: UIBarButtonItem!
    
    @IBOutlet private weak var toolBar: UIToolbar!
    @IBOutlet private weak var toolBarBottomSpacing: NSLayoutConstraint!
    
    // MARK:- Propertises
    private let itemViewModel: ItemViewModel = ItemViewModel()
    private let groupViewModel: GroupViewModel = GroupViewModel()
    private let widgetViewModel: WidgetViewModel = WidgetViewModel()
    
    static var isEditMode: Bool = false
    var group: Group?
    
    private var selectedCell: [IndexPath:Int64] = [:] { // indexPath:id
        didSet {
            if selectedCell.count > 0 {
                self.deleteButton.isEnabled = true
                self.sendButton.isEnabled = true
            } else {
                self.deleteButton.isEnabled = false
                self.sendButton.isEnabled = false
            }
        }
    }
    
    // MARK:- View Life Sycle
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let group = group {
            itemViewModel.loadFromIds(ids: group.ids)
            groupViewModel.attachObserver(self)
            navigationItem.title = group.name
        }
        
        let editBarbuttonItem = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(editButtonTapped(_:)))
        navigationItem.rightBarButtonItem = editBarbuttonItem
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .systemPink
        tabBarController?.tabBar.isHidden = false
        
        HomeDetailViewController.isEditMode = false
        toolBar.isHidden = true
        toolBarBottomSpacing.constant = tabBarController?.tabBar.frame.size.height ?? 0
        prepareItemCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if navigationItem.title == "위젯에 표시될 항목" {
            NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification,
                                                   object: nil,
                                                   queue: .main) {
                [weak self] notification in
                OperationQueue.main.addOperation {
                    self?.itemCollectionView.reloadData()
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParent {
            groupViewModel.removeOberserver(self)
        }
    }
    
    override func viewSafeAreaInsetsDidChange() {
        let height: CGFloat = view.safeAreaInsets.top
        itemCollectionView.contentInset = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
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
        itemCollectionView.contentInsetAdjustmentBehavior = .never
        itemCollectionView.automaticallyAdjustsScrollIndicatorInsets = false
    }
    
    private func deselectCells() {
        selectedCell.forEach { indexPath, _ in
            let cell = self.itemCollectionView.cellForItem(at: indexPath) as? ItemCustomCell
            cell?.isSelectedForRemove = false
        }
    }
    
    @objc private func setDisplayCell() {
        guard let index = widgetViewModel.currentIndex else { return }
        guard let cell = itemCollectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? ItemCustomCell else { return }
        
        cell.isCellDisplayItem = true
    }
    
    // MARK:- @IBAction Methods
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        sender.title = sender.title == "선택" ? "완료" : "선택"
        
        tabBarController?.tabBar.isHidden.toggle()
        toolBar.isHidden.toggle()
        //addButton.isEnabled.toggle()
        HomeDetailViewController.isEditMode.toggle()
        deselectCells()
        selectedCell = [:]
    }
    
    @IBAction func moveButtonTapped(_ sender: UIBarButtonItem) {
        guard let group = group else { return }
        guard let vc = SelectGroupViewController.storyboardInstance() else { return }
        vc.moveGroupName = group.name
        vc.moveIds = selectedCell.map { $0.value }
        vc.selectionType = .move
        
        let navVc = UINavigationController(rootViewController: vc)
        
        navVc.modalPresentationStyle = .fullScreen
        present(navVc, animated: true)
    }
    
    @IBAction func removeButtonTapped(_ sender: UIBarButtonItem) {
        guard let group = group else { return }
        
        selectedCell.forEach { [weak self] indexPath, id in
            self?.itemViewModel.remove(id: id)
            self?.groupViewModel.removeId(at: group.name, ids: [Int(id)])
            self?.groupViewModel.load()
        }
        selectedCell = [:]
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
        
        if navigationItem.title == "위젯에 표시될 항목" { // 위젯에 표시되어 있는 셀인지 파악
            if let index = widgetViewModel.currentIndex, index == indexPath.item {
                cell.isCellDisplayItem = true
            } else {
                cell.isCellDisplayItem = false
            }
        }
        
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
            
            switch cell.itemType {
            case .text:
                guard let vc = EditTextItemViewController.storyboardInstance() else {
                    return
                }
                vc.item = item
                vc.itemViewModel = itemViewModel
                vc.groupViewModel = groupViewModel
                cell.unfreezeAnimations()
                navigationController?.pushViewController(vc, animated: true)
            case .image:
                guard let vc = EditImageItemViewController.storyboardInstance() else {
                    return
                }
                vc.item = item
                vc.itemViewModel = itemViewModel
                cell.unfreezeAnimations()
                navigationController?.pushViewController(vc, animated: true)
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
extension HomeDetailViewController: GroupObserver {
    var groupIdentifier: String {
        return HomeDetailViewController.observerName()
    }
    
    func updateGroup() {
        guard let group = group, let newGroup = groupViewModel.group(by: group.name) else { return }
        
        itemViewModel.loadFromIds(ids: newGroup.ids)
        itemCollectionView.reloadData()
    }
}
