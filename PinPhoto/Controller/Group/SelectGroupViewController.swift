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
    @IBOutlet private weak var groupTableView: UITableView!

    private let itemViewModel: ItemViewModel = ItemViewModel()
    private let groupViewModel: GroupViewModel = GroupViewModel()
    
    lazy var cancelBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        barButtonItem.tintColor = .label
        return barButtonItem
    }()
    
    var selectionType: SelectionType?
    var items: [YPMediaItem]? // for image
    var itemText: String? // for text
    
    var moveIds: [Int64]? // for move id
    var moveGroupName: String? // for origin delete
    
    var selectedCell: IndexPath? {
        didSet {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    override func viewDidLoad() {
        if let type = selectionType, type == .move {
            print("add")
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
        
        let barButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(completeTapped))
        barButtonItem.tintColor = .link
        navigationItem.rightBarButtonItem = barButtonItem
        navigationItem.rightBarButtonItem?.isEnabled = false
        title = "저장할 그룹 선택"
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
    
    private func addImageItem() {
        guard let items = items else { return }
        guard let selectedCell = selectedCell, let groupName = groupTableView.cellForRow(at: selectedCell)?.textLabel?.text else { return }
        
        for item in items {
            switch item {
            case .photo(let photo):
                let imageData: Data? = photo.originalImage.data
                let id: Int64 = itemViewModel.idForAdd
                itemViewModel.add(content: 0, image: imageData, text: nil, date: Date(), id: id)
                groupViewModel.insertId(at: groupName, ids: [Int(id)])
                groupViewModel.load()
            default:
                break
            }
        }
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func addTextItem() {
        guard let itemText = itemText else { return }
        guard let selectedCell = selectedCell, let groupName = groupTableView.cellForRow(at: selectedCell)?.textLabel?.text else { return }
        
        let id: Int64 = itemViewModel.idForAdd
        itemViewModel.add(content: 1, image: nil, text: itemText, date: Date(), id: id)
        groupViewModel.insertId(at: groupName, ids: [Int(id)])
        groupViewModel.load()
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func moveItem() {
        guard let moveIds = moveIds, let moveGroupName = moveGroupName else { return }
        guard let selectedCell = selectedCell, let groupName = groupTableView.cellForRow(at: selectedCell)?.textLabel?.text else { return }
        
        for move in moveIds {
            guard let item = itemViewModel.itemFromId(at: Int(move)) else { return }
            // add
            let id = itemViewModel.idForAdd
            groupViewModel.insertId(at: groupName, ids: [Int(id)])
            itemViewModel.add(content: item.contentType, image: item.contentImage, text: item.contentText, date: item.updateDate, id: id)
            groupViewModel.load()
            
            // remove
            groupViewModel.removeId(at: moveGroupName, ids: [Int(move)])
            itemViewModel.remove(id: move)
            groupViewModel.load()
        }
        
        print("move okay")
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

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
            cell.textLabel?.text = group.name
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
        return section == 0 ? "위젯" : "분류"
    }
}

extension SelectGroupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = indexPath
    }
}
