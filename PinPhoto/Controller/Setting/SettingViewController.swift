//
//  SettingViewController.swift
//  PinPhoto
//
//  Created by won heo on 2020/07/04.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    // MARK:- @IBOutlet Properties
    @IBOutlet private weak var settingTableView: UITableView!
    
    // MARK:- Propertises
    private let shared = CoreDataManager.shared
    private let settingTitleDatas: [String] = ["사진 콕", "설정", "기타"]
    private let settingCellDatas: [[String]] = [
        ["버전 정보","사용 방법"],
        ["위젯 크기"],
        ["데이터 초기화하기"]
    ]
    // 여기 고쳐야 할듯
    
    // MARK:- View Life Sycle
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTableView.dataSource = self
        settingTableView.delegate = self
        settingTableView.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK:- Methods
    private func alertDestructiveAllItem() {
        let alert = UIAlertController(title: "데이터를 초기화 하시겠습니까?", message: "데이터는 다시 복구할 수 없습니다.", preferredStyle: .alert)
        
        let removeAction = UIAlertAction(title: "삭제", style: .destructive, handler: { action in
            self.shared.destructiveAllItem(type: .widget)
        })
        let cancleAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(removeAction)
        alert.addAction(cancleAction)
        
        present(alert, animated: true)
    }
    
    private func presentManual() {
        guard let vc = ManualViewController.storyboardInstance() else {
            return
            
        }
        present(vc, animated: true)
    }
}

// MARK:- UITableView Data Source
extension SettingViewController: UITableViewDataSource {
    func numberOfSections(in: UITableView) -> Int {
        return settingCellDatas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingCellDatas[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell") else {
            return UITableViewCell()
        }
                
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = settingCellDatas[indexPath.section][indexPath.row]
                if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    cell.detailTextLabel?.text = appVersion
                }
            default:
                cell.textLabel?.text = settingCellDatas[indexPath.section][indexPath.row]
                cell.detailTextLabel?.text = nil
            }
        default:
            cell.textLabel?.text = settingCellDatas[indexPath.section][indexPath.row]
            cell.detailTextLabel?.text = nil
            cell.textLabel?.textColor = (indexPath.section == 2) ? .red : .label
        }
    
        return cell
    }

    func tableView(_: UITableView, titleForHeaderInSection: Int) -> String? {
        return settingTitleDatas[titleForHeaderInSection]
    }
}

// MARK:- UITableView Delegate
extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.item == 1 {
                 presentManual()
            }
        case 1:
            if indexPath.item == 0 {
                guard let vc = SettingWidgetViewController.storyboardInstance() else { return }
                navigationController?.pushViewController(vc, animated: true)
            }
        case 2:
            if indexPath.item == 0 {
                 alertDestructiveAllItem()
            }
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }
}
