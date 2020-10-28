//
//  SelectGroupViewController.swift
//  PinPhoto
//
//  Created by won heo on 2020/09/04.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit
import YPImagePicker

class SelectGroupViewController: UIViewController {
    // MARK:- @IBOutlet Properties
    @IBOutlet private weak var groupTableView: UITableView!

    // MARK:- Properties
    private let itemViewModel: ItemViewModel = ItemViewModel()
    private let groupViewModel: GroupViewModel = GroupViewModel()
    private let widgetGroupName: String = "위젯에 표시될 항목"
    
    lazy var cancelBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Cancel".localized, style: .plain, target: self, action: #selector(cancelButtonTapped))
        barButtonItem.tintColor = .label
        return barButtonItem
    }()
    
    var selectionType: SelectionType?
    
    // Add Image
    var items: [YPMediaItem]?
    
    // Add Text
    var itemText: String?
    
    // Move Item
    var moveIds: [Int64]?
    var moveGroupName: String?
    
    var selectedCell: IndexPath? {
        didSet {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        if let type = selectionType, type == .move {
            navigationItem.leftBarButtonItem = cancelBarButtonItem
        }
        
        super.viewDidLoad()
        groupTableView.dataSource = self
        groupTableView.delegate = self
        groupViewModel.load()
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = UIColor.navigationBarTintColor
        
        view.backgroundColor = .offWhiteOrBlack // YPImagePicker 색상과 같게 하기
        groupTableView.backgroundColor = .offWhiteOrBlack
        
        let barButtonItem = UIBarButtonItem(title: "Complete".localized, style: .done, target: self, action: #selector(completeTapped))
        barButtonItem.tintColor = .link
        navigationItem.rightBarButtonItem = barButtonItem
        navigationItem.rightBarButtonItem?.isEnabled = false
        title = "Select group".localized
    }
    
    static func storyboardInstance() -> SelectGroupViewController? {
        let storyboard = UIStoryboard(name: SelectGroupViewController.storyboardName(), bundle: nil)
        
        return storyboard.instantiateInitialViewController()
    }
    
    @objc private func completeTapped(_ sender: UIBarButtonItem) {
        guard let selectionType = selectionType else { return }
        
        switch selectionType {
        case .addImage:
            addImageItem()
        case .addText:
            addTextItem()
        case .move:
            moveItem()
        }
    }
    
    @objc private func cancelButtonTapped() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func cellGroupName() -> String? {
        guard let selectedCell = selectedCell else { return nil }
        
        if selectedCell.section == 0, selectedCell.item == 0 {
            return "위젯에 표시될 항목"
        } else {
            return groupTableView.cellForRow(at: selectedCell)?.textLabel?.text
        }
    }
    
    private func addImageItem() {
        guard let items = items else { return }
        guard let groupName = cellGroupName() else { return }
        
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
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func addTextItem() {
        guard let itemText = itemText else { return }
        guard let groupName = cellGroupName() else { return }
        
        if ifWidgetMaxCount(itemCount: 1) {
            alertMaxCount()
            return
        }
        
        let id: Int64 = itemViewModel.idForAdd
        itemViewModel.add(content: ItemType.text.value, image: nil, text: itemText, date: Date(), id: id)
        groupViewModel.insertId(at: groupName, ids: [Int(id)])
        groupViewModel.load()
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func moveItem() {
        guard let moveIds = moveIds?.sorted(by: { $0 > $1 }), let moveGroupName = moveGroupName else { return }
        guard let groupName = cellGroupName() else { return }
        
        var id: Int64 = itemViewModel.idForAdd
        
        if ifWidgetMaxCount(itemCount: moveIds.count) {
            alertMaxCount()
            return
        }
        
        for move in moveIds {
            guard let item = itemViewModel.itemFromId(at: Int(move)) else { return }
            let copyItem: ItemCopy = ItemCopy(item: item)
            // remove
            groupViewModel.removeId(at: moveGroupName, ids: [Int(move)])
            itemViewModel.remove(id: move)
            groupViewModel.load()
            
            // add
            groupViewModel.insertId(at: groupName, ids: [Int(id)])
            itemViewModel.add(content: copyItem.contentType, image: copyItem.contentImage, text: copyItem.contentText, date: copyItem.updateDate, id: id)
            groupViewModel.load()
            
            // next id
            id += 1
        }
        
        deSelectItem()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func ifWidgetMaxCount(itemCount: Int) -> Bool {
        guard let selectedCell = selectedCell, let groupName = groupTableView.cellForRow(at: selectedCell)?.textLabel?.text else { return false }
        
        if groupName == widgetGroupName, groupViewModel.groups[0].numberOfItem + itemCount > 20 {
            return true
        } else {
            return false
        }
    }
    
    private func alertMaxCount() {
        let alert: UIAlertController = UIAlertController(title: "알림", message: "메모리 제한으로 위젯 항목은 \n 20개를 초과할 수 없습니다!", preferredStyle: .alert)
        let accept: UIAlertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        alert.addAction(accept)
        present(alert, animated: true)
    }
    
    private func deSelectItem() {
        if let tabVc = presentingViewController as? UITabBarController {
            if let navVc = tabVc.selectedViewController as? UINavigationController {
                if let vc = navVc.topViewController as? HomeDetailViewController {
                    vc.deselectCells()
                    vc.selectedCell = [:]
                }
            }
        }
            
    }
}

// MARK:- UITableView Data Source
extension SelectGroupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return groupViewModel.groups.count - 1
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "selectGroupCell") else { return UITableViewCell() }
            let group = groupViewModel.groups[0]
            cell.textLabel?.text = group.name.localized
            cell.detailTextLabel?.text = "\(group.numberOfItem)"
            cell.textLabel?.textColor = .systemPink
            cell.isUserInteractionEnabled = group.name == moveGroupName ? false : true
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "selectGroupCell") else { return UITableViewCell() }
            let group = groupViewModel.groups[indexPath.row + 1]
            cell.textLabel?.text = group.name
            cell.detailTextLabel?.text = "\(group.numberOfItem)"
            cell.isUserInteractionEnabled = group.name == moveGroupName ? false : true
            
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Widget".localized : "Group".localized
    }
}

// MARK:- UITableView Data Delegate
extension SelectGroupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = indexPath
    }
}
