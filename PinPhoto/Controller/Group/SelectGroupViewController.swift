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
    
    var selectedCell: IndexPath? {
        didSet {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }

    let groupViewModel = GroupViewModel()
    var items: [YPMediaItem]?
    var itemViewModel: ItemViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupTableView.dataSource = self
        groupTableView.delegate = self
        groupViewModel.load()
        
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
        guard let itemViewModel = itemViewModel, let items = items else { return }
        guard let selectedCell = selectedCell, let groupName = groupTableView.cellForRow(at: selectedCell)?.textLabel?.text else { return }
        
        var ids: [Int] = []
        
        for item in items {
            switch item {
            case .photo(let photo):
                if itemViewModel.numberOfImages < 15 {
                    let id = itemViewModel.idForAdd
                    let imageData: Data? = photo.originalImage.data
 
                    itemViewModel.add(content: 0, image: imageData, text: nil, date: Date(), id: id)
                    ids.append(Int(id))
                } else {
                    break
                }
            default:
                break
            }
        }
        groupViewModel.insertId(at: groupName, ids: ids)
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension SelectGroupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupViewModel.groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "selectGroupCell") else { return UITableViewCell() }
        let group = groupViewModel.groups[indexPath.row]
        
        cell.textLabel?.text = group.name
        cell.textLabel?.textColor = group.name == "위젯" ? .systemPink : .label
        cell.detailTextLabel?.text = "\(group.numberOfItem)"

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "내 그룹"
    }
}

extension SelectGroupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = indexPath
    }
}
