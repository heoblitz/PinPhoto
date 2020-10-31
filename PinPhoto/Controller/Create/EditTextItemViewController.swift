//
//  EditTextItemViewController.swift
//  PinPhoto
//
//  Created by won heo on 2020/07/31.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class EditTextItemViewController: UIViewController {
    // MARK:- @IBOutlet Properties
    @IBOutlet private weak var itemTextView: UITextView!
    @IBOutlet private weak var saveButton: UIBarButtonItem!
    
    // MARK:- Propertises
    var itemViewModel: ItemViewModel?
    var groupViewModel: GroupViewModel?
    var item: Item?
    
    // MARK:- View Life Sycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        
        navigationItem.title = item?.updateDate.title
        prepareItemTextView()
        setTextViewSize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navVc = navigationController as? HomeNavigationController else { return }
        navVc.dismissAddButtonView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navVc = navigationController as? HomeNavigationController else { return }
        navVc.presentAddButtonView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.itemTextView.becomeFirstResponder()
    }
    
    // MARK:- Methods
    static func storyboardInstance() -> EditTextItemViewController? {
        let storyboard = UIStoryboard(name: EditTextItemViewController.storyboardName(), bundle: nil)
        
        return storyboard.instantiateInitialViewController()
    }
    
    private func setTextViewSize() {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = itemTextView.sizeThatFits(size)
        
        itemTextView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
    
    private func prepareItemTextView() {
        itemTextView.delegate = self
        itemTextView.text = item?.contentText
        itemTextView.isScrollEnabled = false
        itemTextView.layer.backgroundColor = UIColor.systemBackground.cgColor
        itemTextView.layer.masksToBounds = false
        itemTextView.layer.shadowColor = UIColor.gray.cgColor
        itemTextView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        itemTextView.layer.shadowOpacity = 1.0
        itemTextView.layer.shadowRadius = 0.0
    }
    
    @objc private func viewTapped() {
        view.endEditing(true)
    }
    
    // MARK:- @IBAction Methods
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if let item = item {
            itemViewModel?.edit(content: item.contentType, image: nil, text: itemTextView.text, date: item.updateDate, id: item.id)
        }
        
        //navigationController?.popToRootViewController(animated: true)
        groupViewModel?.load()
        navigationController?.popViewController(animated: true)
    }
}

// MARK:- UITextView Delegate
extension EditTextItemViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty, textView.text == "" {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
        
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}
