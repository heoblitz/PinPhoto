//
//  SettingViewController.swift
//  PinPhoto
//
//  Created by won heo on 2020/07/04.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet private weak var settingTableView: UITableView!
    let shared = CoreDataManager.shared
    private let settingTitleDatas: [String] = ["사진 콕", "기타"]
    private let settingCellDatas: [[String]] = [
        ["만든 이", "사용 방법"],
        ["데이터 초기화하기"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingTableView.dataSource = self
        self.settingTableView.delegate = self
    }
    
    func alertDestructiveAllItem() {
        let alert = UIAlertController(title: "데이터를 초기화 하시겠습니까?", message: "데이터는 다시 복구할 수 없습니다.", preferredStyle: .alert)
        
        let removeAction = UIAlertAction(title: "삭제", style: .destructive, handler: { action in
            self.shared.destructiveAllItem()
        })
        let cancleAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(removeAction)
        alert.addAction(cancleAction)
        
        present(alert, animated: true)
    }
}

extension SettingViewController: UITableViewDataSource {
    // section 이 몇개
    func numberOfSections(in: UITableView) -> Int {
        return settingCellDatas.count
    }
    
    // row 가 몇 개
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return settingCellDatas[0].count
        case 1:
            return settingCellDatas[1].count
        default:
            break
        }
        
        return 0
    }
    // cell 을 어떻게 표시
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell") else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = settingCellDatas[0][indexPath.row]
        case 1:
            cell.textLabel?.text = settingCellDatas[1][indexPath.row]
            cell.textLabel?.textColor = .red
        default:
            break
        }
    
        return cell
    }
    // header 를 어떻게 표시
    func tableView(_: UITableView, titleForHeaderInSection: Int) -> String? {
        var title = ""
        
        switch titleForHeaderInSection {
        case 0:
            title = settingTitleDatas[0]
        case 1:
            title = settingTitleDatas[1]
        default:
            break
        }
        
        return title
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            if indexPath.item == 0 {
                alertDestructiveAllItem()
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }
}
