//
//  EditTextItemViewController.swift
//  PinPhoto
//
//  Created by won heo on 2020/07/15.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class CreateTextItemViewController: UIViewController {
    // MARK:- @IBOutlet Properties
    @IBOutlet private weak var inputTextView: UITextView!
    @IBOutlet private weak var contentView: UIView!
    
    private let widgetGroupName: String = "위젯에 표시될 항목"
    let itemViewModel = ItemViewModel()
    let groupViewModel = GroupViewModel()
    
    var selectedGroup: Group?
    
    // MARK:- Propertises    
    let cancelBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Cancel".localized, style: .plain, target: self, action: #selector(cancelButtonTapped))
        barButtonItem.tintColor = .label
        return barButtonItem
    }()
    
    let nextBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Next".localized, style: .done, target: self, action: #selector(saveButtonTapped))
        barButtonItem.tintColor = .link
        return barButtonItem
    }()
    
    let completeBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Complete".localized, style: .done, target: self, action: #selector(completeButtonTapped))
        barButtonItem.tintColor = .link
        return barButtonItem
    }()
    
    // MARk:- View Life Sycle
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGesture.cancelsTouchesInView = false
        contentView.addGestureRecognizer(tapGesture)
        contentView.isUserInteractionEnabled = true
        nextBarButtonItem.isEnabled = false
        prepareInputTextView()
        
        if let _ = selectedGroup {
            navigationItem.rightBarButtonItem = completeBarButtonItem
        } else {
            navigationItem.rightBarButtonItem = nextBarButtonItem
        }
        navigationItem.leftBarButtonItem = cancelBarButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputTextView.becomeFirstResponder()
    }
    
    // MARk:- Methods
    static func storyboardInstance() -> CreateTextItemViewController? {
        let storyboard = UIStoryboard(name: CreateTextItemViewController.storyboardName(), bundle: nil)
        
        return storyboard.instantiateInitialViewController()
    }
    
    private func prepareInputTextView() {
        inputTextView.delegate = self
        inputTextView.isScrollEnabled = false
        inputTextView.layer.backgroundColor = UIColor.systemBackground.cgColor
        inputTextView.layer.masksToBounds = false
        inputTextView.layer.shadowColor = UIColor.gray.cgColor
        inputTextView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        inputTextView.layer.shadowOpacity = 1.0
        inputTextView.layer.shadowRadius = 0.0
    }
    
    private func ifWidgetMaxCount(itemCount: Int) -> Bool {
        guard let groupName = selectedGroup?.name else { return false }
        
        if groupName == widgetGroupName, groupViewModel.groups[0].numberOfItem + itemCount > 20 {
            return true
        } else {
            return false
        }
    }
    
    private func alertMaxCount() {
        let alert: UIAlertController = UIAlertController(title: "Notice".localized, message: "Item count cannot exceed 20".localized, preferredStyle: .alert)
        let accept: UIAlertAction = UIAlertAction(title: "Confirm".localized, style: .default, handler: nil)
        
        alert.addAction(accept)
        present(alert, animated: true)
    }
    
    // MARK:- @IBAction Methods
    @objc private func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let vc = SelectGroupViewController.storyboardInstance() else { return }
        
        vc.selectionType = .addText
        vc.itemText = inputTextView.text
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func completeButtonTapped(_ sender: UIBarButtonItem) {
        guard let group = selectedGroup else { return }
 
        if ifWidgetMaxCount(itemCount: 1) {
            alertMaxCount()
            return
        }
        
        let id: Int64 = itemViewModel.idForAdd
        itemViewModel.add(content: ItemType.text.value, image: nil, text: inputTextView.text, date: Date(), id: id)
        groupViewModel.insertId(at: group.name, ids: [Int(id)])
        groupViewModel.load()
        
        dismiss(animated: true, completion: nil)
    }

    @objc private func viewTapped() {
        inputTextView.resignFirstResponder()
    }
}

// MARK:- UITextView Delegate
extension CreateTextItemViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
        
        if !textView.text.isEmpty {
            nextBarButtonItem.isEnabled = true
        } else {
            nextBarButtonItem.isEnabled = false
        }
    }
}
