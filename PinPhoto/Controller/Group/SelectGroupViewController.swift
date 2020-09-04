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

    let groupViewModel = GroupViewModel()
    var items: [YPMediaItem]?
    var itemViewModel: ItemViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .offWhiteOrBlack // YPImagePicker 색상과 같게 하기
        groupTableView.backgroundColor = .offWhiteOrBlack
        let barButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(completeTapped))
        barButtonItem.tintColor = .link
        navigationItem.rightBarButtonItem = barButtonItem
        title = "저장할 그룹 선택"
        
        groupViewModel.load()
        groupTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    static func storyboardInstance() -> SelectGroupViewController? {
        let storyboard = UIStoryboard(name: SelectGroupViewController.storyboardName(), bundle: nil)
        
        return storyboard.instantiateInitialViewController()
    }
    
    @objc private func completeTapped(_ sender: UIBarButtonItem) {
        guard let itemViewModel = itemViewModel, let items = items else { return }
        
        for item in items {
            switch item {
            case .photo(let photo):
                if itemViewModel.numberOfImages < 15 {
                    let id = itemViewModel.idForAdd
                    let imageData: Data? = photo.originalImage.data
 
                    itemViewModel.add(content: 0, image: imageData, text: nil, date: Date(), id: id)
                } else {
                    break
                }
            default:
                break
            }
        }
        
        navigationController?.dismiss(animated: true, completion: nil)
        //dismiss(animated: true, completion: nil)
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
