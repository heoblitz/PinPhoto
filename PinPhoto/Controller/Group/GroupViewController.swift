//
//  GroupViewController.swift
//  PinPhoto
//
//  Created by won heo on 2020/09/01.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {
    // MARK:- @IBOutlet Properties
    @IBOutlet private weak var groupTableView: UITableView!
    @IBOutlet private weak var inputTextField: UITextField!
    @IBOutlet private weak var inputTextView: UIView!
    @IBOutlet private weak var inputViewBottom: NSLayoutConstraint!
    
    // MARK:- Properties
    let groupViewModel = GroupViewModel()
    let itemViewModel = ItemViewModel()
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // iOS 9 이상 부터 블록 기반의 옵저버를 제외하고, 자동으로 처리해줌.
        // deinit 에서 Observer 제거 필요 X
        groupViewModel.load()
        groupViewModel.attachObserver(self)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAction(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAction(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.delegate = self
        
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        groupTableView.dataSource = self
        groupTableView.delegate = self
        
        inputTextView.backgroundColor = UIColor.tapBarColor
    }
    
    // MARK:- Methods
    private func presentRemoveAlert(at target: Group) {
        let alert = UIAlertController(title: "삭제하시겠습니까?", message: "분류에 포함된 항목도 모두 삭제됩니다.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let remove = UIAlertAction(title: "삭제", style: .destructive, handler: { [weak self]_ in
            self?.removeGroup(at: target)
        })
        
        alert.addAction(cancel)
        alert.addAction(remove)
        
        present(alert, animated: true)
    }
    
    private func removeGroup(at target: Group) {
        for id in target.ids {
            itemViewModel.remove(id: Int64(id))
        }
        groupViewModel.remove(name: target.name)
        groupViewModel.load()
    }
    
    private func alertSameGroupName() {
        let alert = UIAlertController(title: "알림", message: "이미 같은 분류가 존재합니다!", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(confirm)
        
        present(alert, animated: true)
    }

    // MARK:- @IBAction Methods
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        groupTableView.isEditing = !groupTableView.isEditing
        groupTableView.setEditing(groupTableView.isEditing, animated: true)
        sender.title = groupTableView.isEditing ? "Cancel".localized : "Edit".localized
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        guard let text = inputTextField.text?.trimmingCharacters(in: .whitespaces), !text.isEmpty else { return }
        
        if !groupViewModel.groups.contains(where: { $0.name == text }) {
            inputTextField.text = ""
            dismissKeyboard()
            
            groupViewModel.add(name: text)
            groupViewModel.load()
        } else {
            alertSameGroupName()
        }
    }
    
    @objc private func keyboardAction(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            let adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom
            UIView.animate(withDuration: 0.5) {
                self.inputViewBottom.constant = adjustmentHeight
                self.view.layoutIfNeeded()
            }
            groupTableView.contentOffset.y += 50
        } else {
            UIView.animate(withDuration: 0.5) {
                self.inputViewBottom.constant = 0
                self.view.layoutIfNeeded()
            }
            groupTableView.contentOffset.y -= 50
        }
    }
    
    @objc private func dismissKeyboard() {
        inputTextField.resignFirstResponder()
    }
}

// MARK:- UITableView Data Source
extension GroupViewController: UITableViewDataSource {
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell") else { return UITableViewCell() }
            let group = groupViewModel.groups[0]
            cell.textLabel?.text = group.name.localized
            cell.detailTextLabel?.text = "\(group.numberOfItem)"
            cell.textLabel?.textColor = .systemPink
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell") else { return UITableViewCell() }
            let group = groupViewModel.groups[indexPath.row + 1]
            cell.textLabel?.text = group.name
            cell.detailTextLabel?.text = "\(group.numberOfItem)"
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            guard let name = cell.textLabel?.text, let group = groupViewModel.group(by: name) else { return }
            
            if group.ids.count >= 1 {
                presentRemoveAlert(at: group)
            } else {
                removeGroup(at: group)
            }
             
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.section == destinationIndexPath.section {
            groupViewModel.swap(sourceIndexPath, destinationIndexPath)
            groupViewModel.load()
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return indexPath.section == 0 ? .none : .delete
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Widget".localized : "Group".localized
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0 ? false : true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0 ? false : true
    }
}

// MARK:- UITableView Delegate
extension GroupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return sourceIndexPath.section == proposedDestinationIndexPath.section ? proposedDestinationIndexPath : sourceIndexPath
    }
}

// MARK:- GroupObserver
extension GroupViewController: GroupObserver {
    var groupIdentifier: String {
        get {
            return GroupViewController.observerName()
        }
    }
    
    func updateGroup() {
        OperationQueue.main.addOperation {
            self.groupTableView.reloadData()
        }
    }
}

// MARK:- UIGestureRecognizer Delegate
extension GroupViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool { // tap gesture 가 table cell 탭 했을때 동작되는 문제 해결
        if touch.view?.isDescendant(of: groupTableView) == true {
            if inputViewBottom.constant != 0 { // 키보드가 올라가 있다면
                dismissKeyboard()
            }
           return false
        }
        return true
    }
}
