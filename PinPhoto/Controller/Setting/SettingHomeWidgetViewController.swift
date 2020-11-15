//
//  SettingHomeWidgetViewController.swift
//  PinPhoto
//
//  Created by heo on 2020/11/15.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

final class SettingHomeWidgetViewController: UIViewController {
    // MARK:- @IBOutlet Properties
    @IBOutlet private weak var homeWidgetSettingTableView: UITableView!

    var isSwitchOn: Bool = true
    
    // MARK:- View Life Sycle
    override func viewDidLoad() {
        super.viewDidLoad()
        homeWidgetSettingTableView.dataSource = self
        homeWidgetSettingTableView.delegate = self
        
        navigationItem.title = "Item"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK:- Methods
    static func storyboardInstance() -> SettingHomeWidgetViewController? {
        let storyboard = UIStoryboard(name: SettingHomeWidgetViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
    
    @objc private func itemSwitchTapped() {
        isSwitchOn.toggle()
        
        UIView.transition(with: homeWidgetSettingTableView, duration: 0.5, options: .transitionCrossDissolve, animations: { [unowned self] in
            self.homeWidgetSettingTableView.reloadData()
        }, completion: nil)
    }
}

extension SettingHomeWidgetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier:  SettingHomeWidgetSwitchCell.cellIdentifier) as? SettingHomeWidgetSwitchCell else { return UITableViewCell() }
            cell.settingItemSwitch.addTarget(self, action: #selector(itemSwitchTapped), for: .valueChanged)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingHomeWidgetPickerCell.cellIdentifier) as? SettingHomeWidgetPickerCell else { return UITableViewCell() }
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSwitchOn ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return section == 1 ? "위젯에 표시될 항목에 있는 모든 아이템이 시간에 따라 변경됩니다." : nil
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "변경될 시간 설정" : "아이템 표시 설정"
    }
}

extension SettingHomeWidgetViewController: UITableViewDelegate {
    
}
