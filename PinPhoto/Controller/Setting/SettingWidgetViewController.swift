//
//  SettingWidgetViewController.swift
//  PinPhoto
//
//  Created by won heo on 2020/08/19.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

final class SettingWidgetViewController: UIViewController {
    // MARK:- @IBOutlet Properties
    @IBOutlet private weak var widgetImageView: UIImageView!
    @IBOutlet private weak var widgetHeaderView: UIView!
    @IBOutlet private weak var widgetHeaderTitleLabel: UILabel!
    @IBOutlet private weak var widgetSettingTableView: UITableView!
    @IBOutlet private weak var widgetImageHeight: NSLayoutConstraint!
    
    // MARK:- Propertises
    private let widgetViewModel = WidgetViewModel()
    private var selectionGenerator: UISelectionFeedbackGenerator?
    private var isImageFill: Bool = false {
        didSet {
            if isImageFill {
                widgetImageView.contentMode = .scaleToFill
            } else {
                widgetImageView.contentMode = .scaleAspectFit
            }
        }
    }
    
    // MARK:- View Life Sycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let height: Float = widgetViewModel.height
        widgetImageHeight.constant = CGFloat(height)
        isImageFill = widgetViewModel.isImageFill
        selectionGenerator = UISelectionFeedbackGenerator()
        selectionGenerator?.prepare()
        widgetSettingTableView.dataSource = self
        
        widgetHeaderView.clipsToBounds = true
        widgetHeaderView.layer.cornerRadius = 10
        widgetHeaderView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        widgetImageView.clipsToBounds = true
        widgetImageView.layer.cornerRadius = 10
        widgetImageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        widgetImageView.translatesAutoresizingMaskIntoConstraints = false
        
        navigationItem.title = "Size".localized
        widgetHeaderTitleLabel.text = "PinPhoto".localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK:- Methods
    static func storyboardInstance() -> SettingWidgetViewController? {
        let storyboard = UIStoryboard(name: SettingWidgetViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
    
    @objc private func sliderChanged(_ sender: UISlider) {
        let mul: Float = round(sender.value)
        let height: Float = 200 + (mul * 50)
        sender.value = mul
        
        if mul != (widgetViewModel.height - 200) / 50 {
            widgetViewModel.height = height
            widgetImageHeight.constant = CGFloat(height)
            selectionGenerator?.selectionChanged()
        }
    }
    
    @objc private func swtichTapped(_ sender: UISwitch) {
        widgetViewModel.isImageFill = sender.isOn
        isImageFill = sender.isOn
    }
}

// MARK:- UITableView Data Source
extension SettingWidgetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingWidgetSwitchCell.cellIdentifier, for: indexPath) as? SettingWidgetSwitchCell else {
                return UITableViewCell()
            }
            cell.imageSwitch.addTarget(self, action: #selector(swtichTapped), for: .valueChanged)
            cell.imageSwitch.isOn = isImageFill
            cell.imageInfoLabel.text = "Fill Widget Image".localized
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingWidgetSliderCell.cellIdentifier, for: indexPath) as? SettingWidgetSliderCell else {
                return UITableViewCell()
            }
            cell.heightSilder.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
            cell.heightSilder.value = (widgetViewModel.height - 200) / 50
            cell.heightBigLabel.text = "Big".localized
            cell.heightSmallLabel.text = "Small".localized
            return cell
        default:
            return UITableViewCell()
        }
    }
}
