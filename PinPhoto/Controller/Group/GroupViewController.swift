//
//  GroupViewController.swift
//  PinPhoto
//
//  Created by won heo on 2020/09/01.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {
    @IBOutlet private weak var groupTableView: UITableView!
    @IBOutlet private weak var inputTextField: UITextField!
    @IBOutlet private weak var inputTextView: UIView!
    @IBOutlet private weak var inputViewBottom: NSLayoutConstraint!
    
    let groupViewModel = GroupViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // iOS 9 이상 부터 블록 기반의 옵저버를 제외하고, 자동으로 처리해줌.
        // deinit 에서 Observer 제거 필요 X
        groupViewModel.attachObserver(self)
        groupViewModel.load()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAction(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAction(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        //tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        groupTableView.dataSource = self
        
        inputTextView.backgroundColor = UIColor.tapBarColor
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        groupTableView.isEditing = !groupTableView.isEditing
        groupTableView.setEditing(groupTableView.isEditing, animated: true)
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        guard let text = inputTextField.text, !text.isEmpty else { return }
        inputTextField.text = ""
        dismissKeyboard()
        
        groupViewModel.add(name: text)
        groupViewModel.load()
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
            cell.textLabel?.text = group.name
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
        if editingStyle == .delete {
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            guard let name = cell.textLabel?.text else { return }
            groupViewModel.remove(name: name)
            groupViewModel.load()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.section == destinationIndexPath.section {
            groupViewModel.swap(sourceIndexPath, destinationIndexPath)
            groupViewModel.load()
        }
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return sourceIndexPath.section != proposedDestinationIndexPath.section ? sourceIndexPath : proposedDestinationIndexPath
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return indexPath.section == 0 ? .none : .delete
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "위젯" : "분류"
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0 ? false : true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0 ? false : true
    }
}

extension GroupViewController: GroupObserver {
    var groupIdentifier: String {
        get {
            return GroupViewController.observerName()
        }
    }
    
    func updateGroup() {
        OperationQueue.main.addOperation {
            self.groupTableView.reloadSections(IndexSet(1...1), with: .fade)
        }
    }
}

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
