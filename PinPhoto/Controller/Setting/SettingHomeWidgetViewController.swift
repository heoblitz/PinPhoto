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

    let notificationName = Notification.Name.init("timeSettingChanged")
    let widgetViewModel = WidgetViewModel()
    
    // MARK:- View Life Sycle
    override func viewDidLoad() {
        super.viewDidLoad()
        homeWidgetSettingTableView.dataSource = self
        homeWidgetSettingTableView.delegate = self
        navigationItem.title = "Item".localized
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
        widgetViewModel.isShowAllItems = !widgetViewModel.isShowAllItems
        NotificationCenter.default.post(name: notificationName, object: nil)
        
        UIView.transition(with: homeWidgetSettingTableView, duration: 0.5, options: .transitionCrossDissolve, animations: { [unowned self] in
            self.homeWidgetSettingTableView.reloadData()
        }, completion: nil)
    }
    
    @objc private func timePicked(_ sender: UIDatePicker) {
        let date = sender.date
        widgetViewModel.changeItemTime = date
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
    
        print((components.hour ?? 0 ) * 60 + (components.minute ?? 0))
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
            cell.settingItemSwitch.isOn = widgetViewModel.isShowAllItems
            cell.settingInfoLabel.text = "Show all items in group".localized
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingHomeWidgetPickerCell.cellIdentifier) as? SettingHomeWidgetPickerCell else { return UITableViewCell() }
            cell.timeDatePicker.addTarget(self, action: #selector(timePicked), for: .valueChanged)
            
            if let date =  widgetViewModel.changeItemTime {
                cell.timeDatePicker.date = date
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return widgetViewModel.isShowAllItems ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return section == 1 ? "All items in the group that will be displayed on the widget will change over time".localized : nil
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "Time".localized : "Item".localized
    }
}

extension SettingHomeWidgetViewController: UITableViewDelegate {
    
}
